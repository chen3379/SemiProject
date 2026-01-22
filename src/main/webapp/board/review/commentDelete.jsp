<%@page import="board.comment.ReviewCommentDao"%>
<%@ page contentType="application/json; charset=UTF-8" %>

<%
String loginId = (String) session.getAttribute("loginid");

if (loginId == null) {
    out.print("{\"status\":\"LOGIN_REQUIRED\"}");
    return;
}

int comment_idx = Integer.parseInt(request.getParameter("comment_idx"));

ReviewCommentDao dao = new ReviewCommentDao();
dao.deleteComment(comment_idx, loginId);

out.print("{\"status\":\"SUCCESS\"}");
%>
