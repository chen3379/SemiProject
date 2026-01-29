<%@page import="board.free.FreeBoardDao"%>
<%@page import="board.free.FreeBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String category = request.getParameter("category");
String title = request.getParameter("title");
String content = request.getParameter("content");

boolean spoiler = request.getParameter("is_spoiler") != null;

String loginId = (String)session.getAttribute("loginid");

if (loginId == null) {
    response.sendRedirect("/login/login.jsp");
    return;
}

FreeBoardDto dto = new FreeBoardDto();
dto.setCategory_type(category);
dto.setTitle(title);
dto.setContent(content);
dto.setId(loginId);
dto.setIs_spoiler_type(spoiler);  

FreeBoardDao dao = new FreeBoardDao();
dao.insertBoard(dto);

response.sendRedirect("list.jsp");
%>
