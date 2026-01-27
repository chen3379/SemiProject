<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="board.free.FreeBoardDao" %>

<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

FreeBoardDao dao = new FreeBoardDao();
boolean success = dao.restoreBoard(board_idx);

out.print("{\"success\": " + success + "}");
%>
