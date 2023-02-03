package su.boleyn.oj.server;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.ResultSet;
import java.sql.SQLException;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import su.boleyn.oj.core.Config;
import su.boleyn.oj.core.FileUtils;
import su.boleyn.oj.core.SQL;
import su.boleyn.oj.judge.RunnerGrpc;
import su.boleyn.oj.judge.Task;

public class User extends Config {
    private static final String RUNNER_HOST = getOrElse("RUNNER_HOST", "localhost");
    private static final int RUNNER_PORT = Integer.parseInt(getOrElse("RUNNER_PORT", "1993"));
    private static final ManagedChannel channel = ManagedChannelBuilder.forAddress(RUNNER_HOST, RUNNER_PORT)
            .usePlaintext().maxInboundMessageSize(100 * 1024 * 1024).build();
    private static final RunnerGrpc.RunnerBlockingStub runner = RunnerGrpc.newBlockingStub(channel);

    static final String ADMIN_ACCOUNT = "boleynsu";

    private HttpServletRequest request;
    private HttpServletResponse response;
    private String username, token;

    public User(HttpServletRequest req, HttpServletResponse res) throws UnsupportedEncodingException {
        request = req;
        response = res;
        request.setCharacterEncoding("utf-8");
        response.setHeader("pragma", "no-cache");
        response.setHeader("cache-control", "no-cache, no-store, must-revalidate");
        response.setDateHeader("expires", 0);
    }

    public String get(String key) {
        String value = request.getParameter(key);
        return value == null ? "" : value;
    }

    public void go(String message, String url) throws IOException {
        response.sendRedirect("/redirect?message=" + message + "&url=" + url);
    }

    public String getAnnouncement() {
        try {
            return FileUtils.read("/config/Announcement");
        } catch (IOException e) {
            return null;
        }
    }

    public boolean register() {
        try {
            if (!get("password").equals(get("confirm_password")))
                return false;
            if (!get("username").matches("[a-zA-Z0-9._\\-]*")) {
                return false;
            }
            SQL.register(get("username"), get("password"));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public boolean isRegister() {
        return !("".equals(get("username")) || "".equals(get("password")) || "".equals(get("confirm_password")));
    }

    public boolean login() {
        try {
            String username = get("username");
            String password = get("password");
            if (SQL.match(username, password)) {
                Cookie cookie;
                cookie = new Cookie("username", username);
                cookie.setMaxAge(60 * 60 * 24);
                cookie.setHttpOnly(true);
                response.addCookie(cookie);
                cookie = new Cookie("token", SQL.generateToken(username));
                cookie.setMaxAge(60 * 60 * 24);
                cookie.setHttpOnly(true);
                response.addCookie(cookie);
                return true;
            } else {
                return false;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean isLogin() {
        return !("".equals(get("username")) || "".equals(get("password")));
    }

    public boolean submit() {
        try {
            SQL.submit(username, get("problem"), get("source"));
            return true;
        } catch (SQLException | NumberFormatException e) {
            return false;
        }
    }

    public boolean isSubmit() {
        return !("".equals(get("problem")) || "".equals(get("source")));
    }

    public boolean isRunCustomTest() {
        return !"".equals(get("source"));
    }

    public void runCustomTest() throws IOException {
        PrintWriter out = response.getWriter();
        if (!hasLogin()) {
            out.println("Please login in first.");
        } else {
            Task task = Task.newBuilder().setSource(get("source")).setInput(get("input")).build();
            String output = runner.run(task).getOutput();
            if (output.length() > 1024 * 4) {
                output = "Only the first 4k chars are shown.\n" + output.substring(0, 1024 * 4);
            }
            out.println(output);
        }
    }

    public boolean hasLogin() {
        Cookie[] cookies = request.getCookies();
        if (cookies == null)
            return false;
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("username")) {
                username = cookie.getValue();
            }
            if (cookie.getName().equals("token")) {
                token = cookie.getValue();
            }
        }
        if (username == null) {
            return false;
        }
        try {
            return SQL.matchToken(username, token);
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean isAdmin() {
        return hasLogin() && username.equals(ADMIN_ACCOUNT);
    }

    public String getUsername() {
        return username;
    }

    public ResultSet searchSubmission() throws SQLException {
        String condition = "";
        String order = "order by id desc";
        int page = 1;
        try {
            page = Math.max(page, Integer.parseInt(get("page")));
        } catch (NumberFormatException e) {
        }
        long pid = 0;
        try {
            pid = Long.parseLong(get("pid"));
        } catch (NumberFormatException e) {
        }
        if (pid != 0)
            condition += " and pid=" + pid;
        if ("accepted".equals(get("result"))) {
            condition += " and result='accepted'";
        }
        try {
            // FIXME SQL injection!
            // Registered username should be fine.
            // username.matches("[a-zA-Z0-9._\\-]*") must be true for registered username.
            ResultSet rs = SQL.getUserByUsername(get("username"));
            if (rs.next())
                condition += " and username='" + get("username").replaceAll("'", "''") + "'";
        } catch (SQLException e) {
        }
        long cid = 0;
        try {
            cid = Long.parseLong(get("cid"));
        } catch (NumberFormatException e) {
        }
        if (cid != 0) {
            condition += " and pid in (select contest_problem.pid from contest_problem where cid=" + cid + ")";
            condition += " and submit_time between (select begin from contest where id=" + cid
                    + ") and (select end from contest where id=" + cid + ")";
        }
        return SQL.searchSubmission(condition, order, page);
    }

    public String getSubmissionSource() {
        try {
            if (hasLogin()) {
                long sid = Long.parseLong(get("sid"));
                ResultSet rs;
                rs = SQL.getSubmissionById(sid);
                rs.next();
                if (!isAdmin() && !getUsername().equals(rs.getString("username")))
                    return null;
                return rs.getString("source");
            } else {
                return null;
            }
        } catch (NumberFormatException | SQLException e) {
            return null;
        }
    }

    public ResultSet searchProblem() throws SQLException {
        String condition = "";
        String order = "";
        int page = 1;
        try {
            page = Math.max(page, Integer.parseInt(get("page")));
        } catch (NumberFormatException e) {
        }
        if (!isAdmin()) {
            condition += " and published=true";
        }
        long cid = 0;
        try {
            cid = Long.parseLong(get("cid"));
        } catch (NumberFormatException e) {
        }
        if (cid != 0) {
            condition += " and id in (select contest_problem.pid from contest_problem where cid=" + cid + ")";
        }
        long pid = 0;
        try {
            pid = Long.parseLong(get("pid"));
        } catch (NumberFormatException e) {
        }
        if (pid != 0) {
            condition += " and id=" + pid;
        }
        return SQL.searchProblem(condition, order, page);
    }

    public int getAcceptedOfProblem(long id) throws SQLException {
        String condition = "";
        long cid = 0;
        try {
            cid = Long.parseLong(get("cid"));
        } catch (NumberFormatException e) {
        }
        if (cid != 0) {
            condition += " and pid in (select contest_problem.pid from contest_problem where cid=" + cid + ")";
            condition += " and submit_time between (select begin from contest where id=" + cid
                    + ") and (select end from contest where id=" + cid + ")";
        }
        return SQL.getAcceptedOfProblem(id, condition);
    }

    public int getSubmissionsOfProblem(long id) throws SQLException {
        String condition = "";
        long cid = 0;
        try {
            cid = Long.parseLong(get("cid"));
        } catch (NumberFormatException e) {
        }
        if (cid != 0) {
            condition += " and pid in (select contest_problem.pid from contest_problem where cid=" + cid + ")";
            condition += " and submit_time between (select begin from contest where id=" + cid
                    + ") and (select end from contest where id=" + cid + ")";
        }
        return SQL.getSubmissionsOfProblem(id, condition);
    }

    public String getProblemTitle() {
        try {
            long id = Long.parseLong(get("pid"));
            ResultSet rs = SQL.getProblemById(id);
            rs.next();
            if (!isAdmin() && !rs.getBoolean("published"))
                return null;
            return rs.getString("title");
        } catch (SQLException | NumberFormatException e) {
            return null;
        }
    }

    public String getProblemContent() {
        try {
            long id = Long.parseLong(get("pid"));
            ResultSet rs = SQL.getProblemById(id);
            rs.next();
            if (!isAdmin() && !rs.getBoolean("published"))
                return null;
            String code = rs.getString("code");
            return FileUtils.read("/" + code + "/" + getProblemTitle());
        } catch (SQLException | IOException | NumberFormatException e) {
            return null;
        }
    }

    public ResultSet searchContest() throws SQLException {
        String condition = "";
        String order = "order by id desc";
        int page = 1;
        try {
            page = Math.max(page, Integer.parseInt(get("page")));
        } catch (NumberFormatException e) {
        }
        return SQL.searchContest(condition, order, page);
    }

    public String getContestTitle() {
        try {
            long id = Long.parseLong(get("cid"));
            ResultSet rs = SQL.getContestById(id);
            rs.next();
            return rs.getString("title");
        } catch (SQLException e) {
            return null;
        }
    }

    public boolean isContest() {
        long cid = 0;
        try {
            cid = Long.parseLong(get("cid"));
        } catch (NumberFormatException e) {
        }
        return cid != 0;
    }

    public ResultSet getAllSubmission() throws SQLException {
        String condition = "";
        long cid = 0;
        try {
            cid = Long.parseLong(get("cid"));
        } catch (NumberFormatException e) {
        }
        if (cid != 0) {
            condition += " and pid in (select contest_problem.pid from contest_problem where cid=" + cid + ")";
            condition += " and submit_time between (select begin from contest where id=" + cid
                    + ") and (select end from contest where id=" + cid + ")";
        }
        return SQL.getAllSubmissions(condition);
    }

    public boolean isSend() {
        return !get("message").equals("");
    }

    public String sendChatMessage() throws SQLException {
        if (hasLogin()) {
            SQL.sendChatMessage(username, get("message"));
            return "successfully sent!";
        } else {
            return "login first!";
        }
    }

    public ResultSet getChatMessage() throws SQLException {
        return SQL.getChatMessage();
    }

    public void setContentType(String contentType) {
        response.setContentType(contentType);
    }
}
