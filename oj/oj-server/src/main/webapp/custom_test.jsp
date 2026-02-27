<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.server.User, jakarta.servlet.jsp.SkipPageException"%><%
    User user = new User(request, response);
    String pid = user.get("pid");
    if (user.isRunCustomTest()) {
        user.runCustomTest();
        throw new jakarta.servlet.jsp.SkipPageException();
    }
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Boleyn Su's Online Judge - Custom Test</title>
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
<script src="/static/editarea/edit_area_full.js"></script>
<script>
    editAreaLoader.init({
        id : "source",
        start_highlight : true,
        allow_toggle : true,
        word_wrap : true,
        language : "en",
        syntax : "c"
    });
    document.addEventListener('DOMContentLoaded', function () {
        var form = document.getElementById('custom_test_form');
        if (form) {
            form.addEventListener('submit', function (e) {
                var source = editAreaLoader.getValue("source");
                var input = document.getElementById('input').value;
                if (source == "" && input == "") {
                    return;
                }
                document.getElementById('source').disabled = true;
                document.getElementById('input').disabled = true;
                document.getElementById('run').disabled = true;
                document.getElementById('output').value = "Running...";
                fetch('/custom_test', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams({ source: source, input: input })
                })
                    .then(response => response.text())
                    .then(data => {
                        document.getElementById('output').value = data;
                    })
                    .catch(function () {
                        document.getElementById('output').value = "An error occurred!";
                    })
                    .finally(function () {
                        document.getElementById('source').disabled = false;
                        document.getElementById('input').disabled = false;
                        document.getElementById('run').disabled = false;
                    });
                e.preventDefault();
            });
        }
    });
</script>
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
                            <li class="active"><a href="/custom_test">Custom Test</a></li>
                            <li><a href="/login">Login</a></li>
                            <li><a href="/register">Register</a></li>
                        </ul>
                    </nav>
                </div>
                <div class="col-md-8" id="body">
                    <h3>Custom Test</h3>
                    <form id="custom_test_form">
                        <div class="form-group">
                            <label>Source</label>
                            <textarea class="form-control" id="source" rows="18"
                                name="source" /></textarea>
                        </div>
                        <button class="btn btn-primary" id="run" type="submit">Run</button>
                        <div class="form-group row">
                            <span class="col-md-6">
                                <label>Input</label>
                                <textarea class="form-control" id="input" rows="10" name="input" /></textarea>
                            </span>
                            <span class="col-md-6">
                                <label>Output</label>
                                <textarea class="form-control" id="output" rows="10" name="output" disabled /></textarea>
                            </span>
                        </div>
                    </form>
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

