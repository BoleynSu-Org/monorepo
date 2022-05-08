<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.server.User,java.sql.ResultSet"%>
<%
    User user = new User(request, response);
    String source = user.getSubmissionSource();
    if (source == null) {
        user.go("Permission denied.", "/status?cid=" + user.get("cid"));
    } else {
        user.setContentType("text/plain");
%><%=source%>
<%
    }
%>