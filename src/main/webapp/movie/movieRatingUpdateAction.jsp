<%@page import="movie.MovieRatingDao"%>
<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");	
	
	int movieIdx=Integer.parseInt(request.getParameter("movie_idx"));
	String id=(String)session.getAttribute("idok");
	String scoreStr=request.getParameter("score");
	BigDecimal score=new BigDecimal(scoreStr);
	
	MovieRatingDao dao = new MovieRatingDao();
	dao.updateRating(movieIdx, id, score);
%>