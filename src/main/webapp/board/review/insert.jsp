<%@page import="board.review.ReviewBoardDao"%>
<%@page import="board.review.ReviewBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

// 파라미터
String genre = request.getParameter("genre_type");
String title = request.getParameter("title");
String content = request.getParameter("content");

// 스포일러 체크 (체크 안 하면 null)
boolean isSpoiler = request.getParameter("is_spoiler") != null;

// 파일명 (첨부 안 하면 null)
String filename = request.getParameter("filename");

// 로그인 세션 (관리자/유저 공통)
String loginId = (String) session.getAttribute("loginid");

if (loginId == null) {
    response.sendRedirect("/login/login.jsp");
    return;
}

// DTO 조립
ReviewBoardDto dto = new ReviewBoardDto();
dto.setGenre_type(genre);
dto.setTitle(title);
dto.setContent(content);
dto.setId(loginId);               // 이메일(id)
dto.setIs_spoiler_type(isSpoiler);
dto.setFilename(filename);

// DAO
ReviewBoardDao dao = new ReviewBoardDao();
dao.insertBoard(dto);

// 목록으로 이동
response.sendRedirect("list.jsp");
%>
