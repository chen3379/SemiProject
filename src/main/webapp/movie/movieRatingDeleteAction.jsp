<%@page import="movie.MovieRatingDao"%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int movieIdx=Integer.parseInt(request.getParameter("movie_idx"));
	String id=(String)session.getAttribute("idok");

	MovieRatingDao dao = new MovieRatingDao();
	dao.deleteRating(movieIdx, id);
%>