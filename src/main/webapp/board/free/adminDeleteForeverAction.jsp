<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.free.FreeBoardDao" %>

<%
String roleType = (String) session.getAttribute("roleType");

// 관리자만 허용
if (!"3".equals(roleType) && !"9".equals(roleType)) {
    response.sendRedirect("list.jsp");
    return;
}

int board_idx = Integer.parseInt(request.getParameter("board_idx"));

FreeBoardDao dao = new FreeBoardDao();
dao.deleteBoardForever(board_idx);

// 삭제 후 관리자 리스트로
response.sendRedirect("list.jsp?msg=deleted");
%>
