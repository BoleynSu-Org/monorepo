<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.server.User"%>
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
    content="2;URL=<%=user.get("url").replaceAll("<", "&lt;").replaceAll(">", "&gt;")%>" />
</head>
<body>
    <p><%=user.get("message").replaceAll("<", "&lt;").replaceAll(">", "&gt;")%></p>
</body>
</html>
