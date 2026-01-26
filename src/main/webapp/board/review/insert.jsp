<%@page import="board.review.ReviewBoardDao"%>
<%@page import="board.review.ReviewBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

String genre = request.getParameter("genre_type");
String title = request.getParameter("title");
String content = request.getParameter("content");

boolean isSpoiler = request.getParameter("is_spoiler") != null;

String filename = request.getParameter("filename");

String loginId = (String) session.getAttribute("loginid");

if (loginId == null) {
    response.sendRedirect("/login/login.jsp");
    return;
}

ReviewBoardDto dto = new ReviewBoardDto();
dto.setGenre_type(genre);
dto.setTitle(title);
dto.setContent(content);
dto.setId(loginId);               
dto.setIs_spoiler_type(isSpoiler);
dto.setFilename(filename);

ReviewBoardDao dao = new ReviewBoardDao();
dao.insertBoard(dto);

response.sendRedirect("list.jsp");
%>
