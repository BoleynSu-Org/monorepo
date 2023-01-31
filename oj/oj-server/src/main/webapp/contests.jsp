<%@page import="java.awt.List"%>
<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.server.User,java.sql.ResultSet,java.util.ArrayList"%>
<%
    User user = new User(request, response);
    boolean isContest = user.isContest();
    ResultSet rs = null;
    try {
        rs = user.searchContest();
        if (!rs.isBeforeFirst()) {
            user.go("No such page.", "/contests");
        }
    } catch (Exception e) {
        user.go("No such page.", "/contests");
    }
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Boleyn Su's Online Judge - Contests</title>
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
<script src="/webjars/jquery/3.6.3/jquery.min.js"></script>
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
                            <li><a href="/standings">Standings</a></li>
                            <li class="active"><a href="/contests">Contests</a></li>
                            <li><a href="/custom_test">Custom Test</a></li>
                            <li><a href="/login">Login</a></li>
                            <li><a href="/register">Register</a></li>
                        </ul>
                    </nav>
                </div>
                <div class="col-md-8" id="body">
                    <h3>Contests</h3>
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th class="col-md-1">#</th>
                                <th class="col-md-4">Title</th>
                                <th class="col-md-2">Begin</th>
                                <th class="col-md-2">End</th>
                                <th class="col-md-3">Progress</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                while (rs.next()) {
                            %>
                            <tr>
                                <td><%=rs.getString("id")%></td>
                                <td><a href="/problemset?cid=<%=rs.getString("id")%>"><%=rs.getString("title")%></a></td>
                                <td><%=rs.getDate("begin")%> <%=rs.getTime("begin")%></td>
                                <td><%=rs.getDate("end")%> <%=rs.getTime("end")%></td>
                                <td>
                                    <div class="progress" style="margin: 0">
                                        <%
                                            long prog = (long) (100.0 * (new java.util.Date().getTime() - rs.getTimestamp("begin").getTime())
                                                        / (rs.getTimestamp("end").getTime() - rs.getTimestamp("begin").getTime()));
                                                prog = Math.max(Math.min(prog, 100), 0);
                                                long rh = (rs.getTimestamp("end").getTime() - new java.util.Date().getTime()) / 1000 / 60 / 60;
                                        %>
                                        <div
                                            class="progress-bar progress-bar-success progress-bar-striped active"
                                            role="progressbar" aria-valuenow="<%=prog%>"
                                            aria-valuemin="0" aria-valuemax="100"
                                            style="width: <%=prog%>%"></div>
                                    </div> <%
     if (prog == 100) {
 %><strong>Ended</strong> <%
     } else {
 %><%=rh%> hour(s) left<%
     }
 %>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <ul class="pagination">
                        <%
                            int cur = 1;
                            try {
                                cur = Math.max(1, Integer.parseInt(user.get("page")));
                            } catch (NumberFormatException e) {
                            }
                        %>
                        <li><a href="/contests?page=<%=(cur - 1)%>">&laquo;</a></li>
                        <li><a><%=cur%></a></li>
                        <li><a href="/contests?page=<%=(cur + 1)%>">&raquo;</a></li>
                    </ul>
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
