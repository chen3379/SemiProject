<%@page import="movie.MovieWishDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int movieIdx=Integer.parseInt(request.getParameter("movie_idx"));
	String id=(String)session.getAttribute("idok");
	
	MovieWishDao dao = new MovieWishDao();
	dao.deleteWish(movieIdx, id);
		
%>