package su.boleyn.oj.core;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class SQL extends Config {
    private static final String DB_HOST = getOrElse("DB_HOST", "localhost");
    private static final String DB_NAME = getOrElse("DB_NAME", "online_judge");
    private static final String DB_USER = getOrFail("DB_USER");
    private static final String DB_PASSWD = getOrFail("DB_PASSWD");

    private static Connection connection = null;

    private static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed() || !connection.isValid(0)) {
            try {
                connection = DriverManager.getConnection("jdbc:mariadb://" + DB_HOST + "/" + DB_NAME, DB_USER, DB_PASSWD);
                connection.createStatement().execute("show tables;");
            } catch (SQLException e) {
                init();
                connection = DriverManager.getConnection("jdbc:mariadb://" + DB_HOST + "/" + DB_NAME, DB_USER, DB_PASSWD);
            }
        }
        return connection;
    }

    private static PreparedStatement prepareStatement(String sql) throws SQLException {
        return getConnection().prepareStatement(sql);
    }

    private static Statement createStatement() throws SQLException {
        return getConnection().createStatement();
    }

    public static void submit(String username, String problem, String source)
            throws SQLException, NumberFormatException {
        long pid = Long.parseLong(problem);
        PreparedStatement ps = null;
        ps = prepareStatement(
                "insert into submission(username,pid,source,result,time,memory) values(?,?,?,'waiting',0,0);");
        ps.setString(1, username);
        ps.setLong(2, pid);
        ps.setString(3, source);
        ps.execute();

        Statement st = SQL.createStatement();
        ResultSet rs = st.executeQuery("select last_insert_id();");
        rs.next();
        long id = rs.getLong(1);

        st.execute("lock tables queue write;");
        ps = prepareStatement("insert into queue(id) values(?);");
        ps.setLong(1, id);
        ps.execute();
        st.execute("unlock tables;");
    }

    public static void setResult(long id, String result, int time, int memory) throws SQLException {
        PreparedStatement ps = prepareStatement(
                "update submission set result=?,time=?,memory=?,submit_time=submit_time where id=?;");
        ps.setString(1, result);
        ps.setInt(2, time);
        ps.setInt(3, memory);
        ps.setLong(4, id);
        ps.execute();
    }

    public static boolean match(String username, String password) throws SQLException {
        PreparedStatement ps = prepareStatement(
                "select count(*) from user where username=? and password=sha2(?, 256);");
        ps.setString(1, username);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        return rs.next() && rs.getLong(1) == 1;
    }

    public static String generateToken(String username) throws SQLException {
        PreparedStatement ps = prepareStatement(
                "select sha2(concat(username, \":\", password, \":\", curdate()), 256) from user where username=?;");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        rs.next();
        return rs.getString(1);
    }

    public static boolean matchToken(String username, String token) throws SQLException {
        PreparedStatement ps = prepareStatement(
                "select count(*) from user where username=? and sha2(concat(username, \":\", password, \":\", curdate()), 256) = ?;");
        ps.setString(1, username);
        ps.setString(2, token);
        ResultSet rs = ps.executeQuery();
        return rs.next() && rs.getLong(1) == 1;
    }

    public static ResultSet getUsers() throws SQLException {
        Statement st = SQL.createStatement();
        return st.executeQuery("select * from user;");
    }

    public static ResultSet getUserByUsername(String username) throws SQLException {
        PreparedStatement ps = prepareStatement("select * from user where username=?;");
        ps.setString(1, username);
        return ps.executeQuery();
    }

    public static ResultSet getSubmissionById(long id) throws SQLException {
        return searchSubmission(" and id=" + id, "", 1);
    }

    public static ResultSet getProblemById(long id) throws SQLException {
        return searchProblem(" and id=" + id, "", 1);
    }

    public static ResultSet getContestById(long id) throws SQLException {
        PreparedStatement ps = prepareStatement("select * from contest where id=?;");
        ps.setLong(1, id);
        return ps.executeQuery();
    }

    public static long getIdInQueue() throws SQLException {
        Statement st = createStatement();
        st.execute("lock tables queue write;");
        try {
            ResultSet rs = st.executeQuery("select id from queue order by submit_time;");
            rs.next();
            long id = rs.getLong(1);
            PreparedStatement ps = prepareStatement("delete from queue where id=?;");
            ps.setLong(1, id);
            ps.execute();
            st.execute("unlock tables;");
            return id;
        } catch (SQLException e) {
            st.execute("unlock tables;");
            throw e;
        }
    }

    public static ResultSet searchSubmission(String condition, String order, long page) throws SQLException {
        Statement st = createStatement();
        return st.executeQuery("select * from submission where true " + condition + " " + order + " limit "
                + (page - 1) * 20 + ",20;");
    }

    public static ResultSet searchProblem(String condition, String order, long page) throws SQLException {
        Statement st = createStatement();
        return st.executeQuery(
                "select * from problem where true " + condition + " " + order + " limit " + (page - 1) * 20 + ",20;");
    }

    public static long getAcceptedOfProblem(long id, String condition) throws SQLException {
        PreparedStatement ps = prepareStatement(
                "select count(*) from submission where pid=? and result='accepted'" + condition + ";");
        ps.setLong(1, id);
        ResultSet rs = ps.executeQuery();
        rs.next();
        return rs.getLong(1);
    }

    public static long getSubmissionsOfProblem(long id, String condition) throws SQLException {
        PreparedStatement ps = prepareStatement("select count(*) from submission where pid=?" + condition + ";");
        ps.setLong(1, id);
        ResultSet rs = ps.executeQuery();
        rs.next();
        return rs.getLong(1);
    }

    public static ResultSet getAllSubmissions(String condition) throws SQLException {
        Statement st = createStatement();
        return st.executeQuery("select * from submission where true " + condition + ";");
    }

    public static ResultSet searchContest(String condition, String order, long page) throws SQLException {
        Statement st = createStatement();
        return st.executeQuery(
                "select * from contest where true " + condition + " " + order + " limit " + (page - 1) * 20 + ",20;");
    }

    public static void register(String username, String password) throws SQLException {
        PreparedStatement ps = prepareStatement("insert into user values(?,sha2(?, 256));");
        ps.setString(1, username);
        ps.setString(2, password);
        ps.execute();
    }

    public static void sendChatMessage(String sender, String message) throws SQLException {
        PreparedStatement ps = prepareStatement("insert into chat(sender,message) values(?,?);");
        ps.setString(1, sender);
        ps.setString(2, message);
        ps.execute();
    }

    public static ResultSet getChatMessage() throws SQLException {
        Statement st = createStatement();
        ResultSet rs = st.executeQuery("select * from chat order by time desc limit 0,30;");
        return rs;
    }

    private static void init() throws SQLException {
        Connection connection = DriverManager.getConnection("jdbc:mariadb://" + DB_HOST, DB_USER, DB_PASSWD);
        Statement statement = connection.createStatement();
        statement.execute("create database " + DB_NAME + ";");
        statement.execute("use " + DB_NAME + ";");
        statement.execute("create table user(username varchar(16) primary key,password varchar(64) not null);");

        statement.execute(
                "create table problem(id bigint auto_increment primary key,title varchar(256) not null,code varchar(16) not null unique,testcase bigint not null,time_limit bigint not null,published bool not null);");

        statement.execute(
                "create table submission(id bigint auto_increment primary key,submit_time timestamp not null,username varchar(16) not null,pid bigint not null,source text not null,result varchar(128),time int,memory int,foreign key(username) references user(username),foreign key(pid) references problem(id));");
        statement.execute("create index submission_username_index on submission(username);");
        statement.execute("create index submission_pid_index on submission(pid);");
        statement.execute("create index submission_result_index on submission(result);");

        statement.execute(
                "create table queue(submit_time timestamp,id bigint primary key,foreign key(id) references submission(id));");

        statement.execute(
                "create table contest(id bigint auto_increment primary key,title varchar(256),begin timestamp,end timestamp);");
        statement.execute(
                "create table contest_problem(cid bigint,pid bigint,foreign key(cid) references contest(id),foreign key(pid) references problem(id));");
        statement.execute("create index contest_problem_cid_index on contest_problem(cid);");

        statement.execute(
                "create table chat(time timestamp,sender varchar(16),message text not null,foreign key(sender) references user(username));");
    }

}
