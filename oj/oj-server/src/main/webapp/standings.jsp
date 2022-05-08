<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.server.User,java.sql.ResultSet,java.util.*"%>
<%
    User user = new User(request, response);
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Boleyn Su's Online Judge - Standings</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
html, body {
    height: 100%;
}

#wrap {
    min-height: 100%;
    height: auto !important;
    height: 100%;
    margin: 0 auto -42px;
    padding: 0 0 42px;
}

#footer {
    background-color: #f5f5f5;
    border-top: 1px solid #e5e5e5;
}

#body {
    padding-top: 40px;
}
</style>
<link rel="stylesheet" href="/webjars/bootstrap/3.4.1/css/bootstrap.min.css" />
<link rel="stylesheet"
    href="/webjars/bootstrap/3.4.1/css/bootstrap-theme.min.css" />
<script src="/webjars/jquery/3.6.0/jquery.min.js"></script>
<script src="/webjars/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="/static/my.js"></script>
</head>
<body>
    <div id="wrap">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <header class="page-header">
                        <h2>Boleyn Su's Online Judge</h2>
                    </header>
                    <nav>
                        <ul class="nav nav-pills nav-stacked">
                            <li><a href="/">Home</a></li>
                            <li><a href="/problemset">Problem set</a></li>
                            <li><a href="/submit">Submit</a></li>
                            <li><a href="/status">Status</a></li>
                            <li <%if (!user.isContest()) {%> class="active" <%}%>><a
                                href="/standings">Standings</a></li>
                            <li><a href="/contests">Contests</a></li>
                            <li><a href="/custom_test">Custom Test</a></li>
                            <li><a href="/login">Login</a></li>
                            <li><a href="/register">Register</a></li>
                        </ul>
                    </nav>
                </div>
                <div class="col-md-8" id="body">
                    <%
                        if (user.isContest()) {
                    %>
                    <article class="panel panel-default">
                        <header class="panel-heading">
                            <h1 class="panel-title"><%=user.getContestTitle()%></h1>
                        </header>
                        <div class="panel-body">
                            <ul class="nav nav-tabs">
                                <li><a href="/problemset?cid=<%=user.get("cid")%>">Problems</a></li>
                                <li><a href="/submit?cid=<%=user.get("cid")%>">Submit</a></li>
                                <li><a href="/status?cid=<%=user.get("cid")%>">Status</a></li>
                                <li class="active"><a
                                    href="/standings?cid=<%=user.get("cid")%>">Standings</a></li>
                            </ul>
                            <%
                                }
                            %>
                            <h3>Standings</h3>
                            <%
                                ResultSet rs = user.getAllSubmission();
                                Map<String, Integer> rank = new HashMap<String, Integer>();
                                ArrayList<String> select = new ArrayList<String>();
                                Map<String, Set<Long>> solved = new HashMap<String, Set<Long>>();
                                Map<String, Map<Long, Integer>> tried = new HashMap<String, Map<Long, Integer>>();
                                Map<String, String> lastAccepted = new HashMap<String, String>();
                                while (rs.next()) {
                                    Long pid = rs.getLong("pid");
                                    String username = rs.getString("username");
                                    boolean accepted = rs.getString("result").equals("accepted");
                                    if (rank.get(username) == null) {
                                        rank.put(username, select.size());
                                        select.add(username);
                                        tried.put(username, new HashMap<Long, Integer>());
                                        solved.put(username, new HashSet<Long>());
                                    }
                                    if (accepted && !solved.get(username).contains(pid)) {
                                        lastAccepted.put(username,
                                                rs.getDate("submit_time").toString() + " " + rs.getTime("submit_time").toString());
                                        solved.get(username).add(pid);
                                        while (!rank.get(username).equals(0)) {
                                            int r = rank.get(username);
                                            String p = select.get(r - 1);
                                            if (solved.get(p).size() < solved.get(username).size()) {
                                                rank.put(p, r);
                                                rank.put(username, r - 1);
                                                select.set(r, p);
                                                select.set(r - 1, username);
                                            } else
                                                break;
                                        }
                                    }
                                    if (!solved.get(username).contains(pid)) {
                                        if (tried.get(username).get(pid) == null)
                                            tried.get(username).put(pid, 0);
                                        tried.get(username).put(pid, tried.get(username).get(pid) + 1);
                                    }
                                }
                                ArrayList<Long> problems = new ArrayList<Long>();
                                rs = user.searchProblem();
                                while (rs.next()) {
                                    Long id = rs.getLong("id");
                                    problems.add(id);
                                }
                                if (user.isContest()) {
                            %>
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Username</th>
                                        <th>Solved</th>
                                        <%
                                            for (int i = 0; i < problems.size(); i++) {
                                        %><th><%=problems.get(i)%></th>
                                        <%
                                            }
                                        %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (int r = 0; r < select.size(); r++) {
                                                String username = select.get(r);
                                    %>
                                    <tr>
                                        <td><%=r + 1%></td>
                                        <td><%=username%></td>
                                        <td><%=solved.get(username).size()%></td>
                                        <%
                                            for (int i = 0; i < problems.size(); i++) {
                                                        Long pid = problems.get(i);
                                                        if (solved.get(username).contains(pid)) {
                                        %>
                                        <td class="text-success">accepted</td>
                                        <%
                                            } else if (tried.get(username).get(pid) != null) {
                                        %>
                                        <td class="text-danger"><small><%=tried.get(username).get(pid)%>
                                                wrong try/tries</small></td>
                                        <%
                                            } else {
                                        %>
                                        <td></td>
                                        <%
                                            }
                                                    }
                                        %>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                            <%
                                } else {
                            %>
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Username</th>
                                        <th>Solved</th>
                                        <th>Last Accepted</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (int r = 0; r < select.size(); r++) {
                                                String username = select.get(r);
                                    %>
                                    <tr>
                                        <td><%=r + 1%></td>
                                        <td><%=username%></td>
                                        <td><%=solved.get(username).size()%></td>
                                        <td><%=lastAccepted.getOrDefault(username, "")%></td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                            <%
                                }
                            %>
                            <%
                                if (user.isContest()) {
                            %>
                        </div>
                    </article>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>
    <div id="footer">
        <div class="container">
            <footer class="text-center">
                Boleyn Su's Online Judge is an open source project released under
                MIT license at <a href="https://boleyn.su/source/oj">boleyn.su/source/oj</a>.<br />
                &copy;2013-2020 Boleyn Su. All Rights Reserved.
            </footer>
        </div>
    </div>
</body>
</html>
