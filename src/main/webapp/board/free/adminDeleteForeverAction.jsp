<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="board.free.FreeBoardDao" %>

<%
String roleType = (String) session.getAttribute("roleType");

if (!"3".equals(roleType) && !"9".equals(roleType)) {
    out.print("{\"success\": false, \"error\": \"unauthorized\"}");
    return;
}

int board_idx = Integer.parseInt(request.getParameter("board_idx"));

FreeBoardDao dao = new FreeBoardDao();
dao.deleteBoardForever(board_idx);

out.print("{\"success\": true}");
%>
