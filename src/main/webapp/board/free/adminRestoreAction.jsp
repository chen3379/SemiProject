<%@page import="board.free.FreeBoardDao"%>
<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

FreeBoardDao dao = new FreeBoardDao();
dao.restoreBoard(board_idx);   // is_deleted = 0

response.sendRedirect("list.jsp?msg=restored");
%>

