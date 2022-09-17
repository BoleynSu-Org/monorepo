<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.server.User,java.sql.ResultSet"%>
<%
    User user = new User(request, response);
    String pid = user.get("pid");
    String title = user.getProblemTitle();
    String content = user.getProblemContent();
    if (title == null) {
        user.go("No such problem", "/problemset?cid=" + user.get("cid"));
    }
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Boleyn Su's Online Judge - Problem - <%=title%></title>
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

pre {
    white-space: pre-wrap;
}
</style>
<link rel="stylesheet" href="/webjars/bootstrap/3.4.1/css/bootstrap.min.css" />
<link rel="stylesheet"
    href="/webjars/bootstrap/3.4.1/css/bootstrap-theme.min.css" />
<script src="/webjars/jquery/3.6.1/jquery.min.js"></script>
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
                                <li><a href="/standings?cid=<%=user.get("cid")%>">Standings</a></li>
                            </ul>
                            <%
                                }
                            %>
                            <h3><%=title%></h3>
                            <div>
                                <%=content%>
                            </div>
                            <a class="btn btn-primary"
                                href="/submit?cid=<%=user.get("cid")%>&pid=<%=pid%>">Submit</a>
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
