<%@page import="board.free.FreeBoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

FreeBoardDao dao = new FreeBoardDao();
dao.deleteBoard(board_idx);

// 삭제 후 목록 이동
response.sendRedirect("list.jsp");
%>