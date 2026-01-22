<%@page import="board.free.FreeBoardDao"%>
<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

FreeBoardDao dao = new FreeBoardDao();
dao.hideBoard(board_idx);   // is_deleted = 1

response.sendRedirect("list.jsp?msg=hidden");
return;
%>