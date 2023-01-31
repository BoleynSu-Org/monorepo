<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.server.User"%>
<%
    User user = new User(request, response);
    String announcement = user.getAnnouncement();
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Boleyn Su's Online Judge</title>
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
                            <li class="active"><a href="/">Home</a></li>
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
                    <article class="panel panel-default">
                        <header class="panel-heading">
                            <h1 class="panel-title">Announcement</h1>
                        </header>
                        <div class="panel-body">
                            <%=announcement%>
                        </div>
                    </article>
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
