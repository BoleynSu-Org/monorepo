<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.core.HtmlUtils,su.boleyn.oj.server.User"%>
<%
    User user = new User(request, response);
    if (!user.get("url").startsWith("/") || user.get("url").startsWith("//")) {
        user.go("Redirecting to home page", "/");
    }
%>
<!doctype html>
<html>
<head>
<title>Redirecting</title>
<meta http-equiv="refresh"
    content="2;URL=<%=HtmlUtils.sanitizeAttribute(user.get("url"))%>" />
</head>
<body>
    <p><%=HtmlUtils.sanitizeTextContent(user.get("message"))%></p>
</body>
</html>
