<%@page pageEncoding="utf-8" language="java"
    import="su.boleyn.oj.server.User,java.sql.ResultSet"%><%
    User user = new User(request, response);
    if (user.isSend()) {
%><%=user.sendChatMessage()%><%
    } else {
        ResultSet rs = user.getChatMessage();
        while (rs.next()) {
%>
<p>
    <span class="user"><%=rs.getString("sender").replaceAll("<", "&lt;")
                            .replaceAll(">", "&gt;")%></span>
    : <span class="message"><%=rs.getString("message").replaceAll("<", "&lt;")
                            .replaceAll(">", "&gt;")%></span>
</p>
<%
    }
    }
%>
