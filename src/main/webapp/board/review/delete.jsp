<%@page import="board.review.ReviewBoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

ReviewBoardDao dao = new ReviewBoardDao();
dao.deleteBoard(board_idx);

// 삭제 후 목록 이동
response.sendRedirect("list.jsp");
%>
