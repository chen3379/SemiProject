<%@page import="movie.MovieReviewDao"%>
<%@page import="movie.MovieReviewDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String id=request.getParameter("id");
	String content=request.getParameter("content");

	MovieReviewDto dto=new MovieReviewDto();
	dto.setId(id);
	dto.setContent(content);
	
	MovieReviewDao dao=new MovieReviewDao();
	dao.updateReview(dto);

%>