<!-- 별점입력 + 별점통계갱신 -->

<%@page import="movie.MovieRatingStatDao"%>
<%@page import="movie.MovieRatingDto"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="movie.MovieRatingDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");	
	
	int movieIdx=Integer.parseInt(request.getParameter("movieIdx"));
	String id=(String)session.getAttribute("idok");
	String scoreStr=request.getParameter("score");
	BigDecimal score=new BigDecimal(scoreStr);
	
	//session.setAttribute("loginStatus", true);
	Boolean loginStatus=(Boolean)session.getAttribute("loginStatus");
	if(loginStatus==null || id==null){
		response.sendRedirect("../login/loginForm.jsp");
		return;
	}
	
	MovieRatingDao dao=new MovieRatingDao();
	dao.insertRating(movieIdx, id, score);
	
	//별점 통계 갱신(평균,개수 업데이트)
	MovieRatingStatDao statDao=new MovieRatingStatDao();
	statDao.refreshStat(movieIdx);
	
%>
