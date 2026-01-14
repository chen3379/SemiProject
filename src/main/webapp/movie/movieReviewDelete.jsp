<%@page import="movie.MovieReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int movieIdx=Integer.parseInt(request.getParameter("movieIdx"));

	MovieReviewDao dao=new MovieReviewDao();
	dao.deleteReview(movieIdx);
%>