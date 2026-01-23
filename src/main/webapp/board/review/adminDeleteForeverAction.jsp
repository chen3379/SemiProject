<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.review.ReviewBoardDao" %>

<%
String roleType = (String) session.getAttribute("roleType");

// 관리자 체크
if (!"3".equals(roleType) && !"9".equals(roleType)) {
    response.sendRedirect("list.jsp");
    return;
}

int board_idx = Integer.parseInt(request.getParameter("board_idx"));

ReviewBoardDao dao = new ReviewBoardDao();
dao.deleteBoardForever(board_idx);

// 리뷰 리스트로 이동
response.sendRedirect("list.jsp?msg=deleted");
%>
