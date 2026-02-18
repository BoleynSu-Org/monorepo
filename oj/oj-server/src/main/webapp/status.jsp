<%@page import="java.awt.List"%>
<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.core.HtmlUtils,su.boleyn.oj.server.User,java.sql.ResultSet"%>
<%
    User user = new User(request, response);
    String cid = user.get("cid");
    try {
        Long.parseLong(cid);
    } catch (NumberFormatException e) {
        cid = "";
    }
    String pid = user.get("pid");
    try {
        Long.parseLong(pid);
    } catch (NumberFormatException e) {
        pid = "";
    }
    ResultSet rs = null;
    try {
        rs = user.searchSubmission();
        if (!rs.isBeforeFirst()) {
            user.go("No such page.", "/status?cid=" + user.get("cid"));
        }
    } catch (Exception e) {
        user.go("No such page.", "/status?cid=" + user.get("cid"));
    }
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Boleyn Su's Online Judge - Status</title>
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
<link rel="stylesheet" href="/webjars/bootstrap/<%=su.boleyn.oj.server.Versions.BOOTSTRAP_VERSION%>/css/bootstrap.min.css" />
<link rel="stylesheet"
    href="/webjars/bootstrap/<%=su.boleyn.oj.server.Versions.BOOTSTRAP_VERSION%>/css/bootstrap-theme.min.css" />
<script src="/webjars/bootstrap/<%=su.boleyn.oj.server.Versions.BOOTSTRAP_VERSION%>/js/bootstrap.min.js"></script>
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
                            <li <%if (!user.isContest()) {%> class="active" <%}%>><a
                                href="/status">Status</a></li>
                            <li><a href="/standings">Standings</a></li>
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
                            <h1 class="panel-title"><%=HtmlUtils.sanitizeTextContent(user.getContestTitle())%></h1>
                        </header>
                        <div class="panel-body">
                            <ul class="nav nav-tabs">
                                <li><a href="/problemset?cid=<%=cid%>">Problems</a></li>
                                <li><a href="/submit?cid=<%=cid%>">Submit</a></li>
                                <li class="active"><a
                                    href="/status?cid=<%=cid%>">Status</a></li>
                                <li><a href="/standings?cid=<%=cid%>">Standings</a></li>
                            </ul>
                            <%
                                }
                            %>
                            <h3>
                                Status<%
                                if (user.hasLogin()) {
                            %>
                                |<small><a
                                    href="/status?cid=<%=cid%>&username=<%=HtmlUtils.sanitizeAttribute(user.getUsername())%>">My
                                        status</a></small>
                                <%
                                    }
                                %>
                            </h3>
                            <table class="table table-hover table-condensed">
                                <thead>
                                    <tr>
                                        <th class="col-md-1">#</th>
                                        <th class="col-md-1">Problem</th>
                                        <th class="col-md-2">User</th>
                                        <th class="col-md-3">Submit Time</th>
                                        <th class="col-md-3">Result</th>
                                        <th class="col-md-1">Time</th>
                                        <th class="col-md-1">Memory</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        boolean hasLogin = user.hasLogin();
                                        while (rs.next()) {
                                            String result = rs.getString("result");
                                    %><tr>
                                        <td>
                                            <%
                                                if (hasLogin && (user.getUsername().equals(rs.getString("username")) || user.isAdmin())) {
                                            %><a
                                            href="/submission?cid=<%=cid%>&sid=<%=rs.getLong("id")%>"><%=rs.getLong("id")%></a>
                                            <%
                                                } else {
                                            %><%=rs.getLong("id")%> <%
     }
 %>
                                        </td>
                                        <td><a
                                            href="/problem?cid=<%=cid%>&pid=<%=rs.getLong("pid")%>"><%=rs.getLong("pid")%></a></td>
                                        <td><%=HtmlUtils.sanitizeTextContent(rs.getString("username"))%></td>
                                        <td><%=rs.getDate("submit_time")%> <%=rs.getTime("submit_time")%></td>
                                        <td><strong
                                            class="<%=result.startsWith("accepted")                                ? "text-success"
                                                    : result.startsWith("judge error")                             ? "text-info"
                                                    : result.startsWith("running") || result.startsWith("waiting") ? ""
                                                    :                                                                "text-danger"%>"><%=HtmlUtils.sanitizeTextContent(result)%></strong></td>
                                        <td><%=rs.getInt("time")%>ms</td>
                                        <td><%=rs.getInt("memory")%>kb</td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                            <ul class="pagination">
                                <%
                                    long cur = 1;
                                    try {
                                        cur = Math.max(1, Long.parseLong(user.get("page")));
                                    } catch (NumberFormatException e) {
                                    }
                                %>
                                <li><a
                                    href="/status?cid=<%=cid%>&page=<%=(cur - 1)%>&username=<%=HtmlUtils.sanitizeAttribute(user.get("username"))%>&pid=<%=pid%>&result=<%=HtmlUtils.sanitizeAttribute(user.get("result"))%>">&laquo;</a></li>
                                <li><a><%=cur%></a></li>
                                <li><a
                                    href="/status?cid=<%=cid%>&page=<%=(cur + 1)%>&username=<%=HtmlUtils.sanitizeAttribute(user.get("username"))%>&pid=<%=pid%>&result=<%=HtmlUtils.sanitizeAttribute(user.get("result"))%>">&raquo;</a></li>
                            </ul>
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
