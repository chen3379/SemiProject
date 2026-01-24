<%@page import="board.free.FreeBoardDao"%>
<%@page import="board.free.FreeBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String category = request.getParameter("category");
String title = request.getParameter("title");
String content = request.getParameter("content");

// 스포일러 체크 여부 (체크 안 하면 null)
boolean spoiler = request.getParameter("is_spoiler") != null;

// 로그인 세션
String loginId = (String)session.getAttribute("loginid");

if (loginId == null) {
    response.sendRedirect("/login/login.jsp");
    return;
}

// DTO 조립
FreeBoardDto dto = new FreeBoardDto();
dto.setCategory_type(category);
dto.setTitle(title);
dto.setContent(content);
dto.setId(loginId);
dto.setIs_spoiler_type(spoiler);  

// DAO
FreeBoardDao dao = new FreeBoardDao();
dao.insertBoard(dto);

response.sendRedirect("list.jsp");
%>
