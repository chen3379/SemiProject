<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="board.review.ReviewBoardDao" %>

<%
String roleType = (String) session.getAttribute("roleType");

if (!"3".equals(roleType) && !"9".equals(roleType)) {
    out.print("{\"success\": false}");
    return;
}

int board_idx = Integer.parseInt(request.getParameter("board_idx"));

ReviewBoardDao dao = new ReviewBoardDao();
boolean success = dao.deleteBoardForever(board_idx);

out.print("{\"success\": " + success + "}");
%>
