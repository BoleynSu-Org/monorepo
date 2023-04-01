<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.core.HtmlUtils,su.boleyn.oj.server.User,java.sql.ResultSet"%><%
    User user = new User(request, response);
    if (user.isSend()) {
%><%=HtmlUtils.sanitizeTextContent(user.sendChatMessage())%><%
    } else {
        ResultSet rs = user.getChatMessage();
        while (rs.next()) {
%>
<p>
    <span class="user"><%=HtmlUtils.sanitizeTextContent(rs.getString("sender"))%></span>
    : <span class="message"><%=HtmlUtils.sanitizeTextContent(rs.getString("message"))%></span>
</p>
<%
    }
    }
%>
