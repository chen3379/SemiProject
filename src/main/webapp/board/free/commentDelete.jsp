<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="board.comment.FreeCommentDao" %>

<%
String loginId = (String) session.getAttribute("loginid");

if (loginId == null) {
    out.print("{\"status\":\"LOGIN_REQUIRED\"}");
    return;
}

int comment_idx = Integer.parseInt(request.getParameter("comment_idx"));

FreeCommentDao dao = new FreeCommentDao();
dao.deleteComment(comment_idx, loginId);

out.print("{\"status\":\"SUCCESS\"}");
%>