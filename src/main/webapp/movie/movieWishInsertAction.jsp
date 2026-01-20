<%@page import="movie.MovieWishDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");	

	int movieIdx=Integer.parseInt(request.getParameter("movie_idx"));
	String id=(String)session.getAttribute("id");
	
	//로그인 체크
	Boolean loginStatus=(Boolean)session.getAttribute("loginStatus");
	if(loginStatus==null || !loginStatus || id==null){
		response.sendRedirect("../login/loginForm.jsp");
		return;
	}
	
	MovieWishDao dao = new MovieWishDao();
	dao.insertWish(movieIdx, id);
	
%>