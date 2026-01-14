<%@page import="movie.MovieWishDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int movieIdx=Integer.parseInt(request.getParameter("movieIdx"));
	String loginok=(String)session.getAttribute("loginok");
	String id=(String)session.getAttribute("idok");
	
	//session.setAttribute("loginStatus", true);
	Boolean loginStatus=(Boolean)session.getAttribute("loginStatus");
	if(loginStatus==null || id==null){
		response.sendRedirect("../login/loginForm.jsp");
		return;
	}
	
	MovieWishDao dao = new MovieWishDao();
	dao.insertWish(movieIdx, id);
	
%>