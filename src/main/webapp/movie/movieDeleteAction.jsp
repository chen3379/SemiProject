<%@page import="org.apache.jasper.compiler.Node.Scriptlet"%>
<%@page import="movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
//영화상세페이지에서 삭제 버튼 클릭 시 영화 고유번호 받아서
//영화 삭제 처리 후 해당 영화가 있던 페이지 번호의 영화 목록으로 이동
String movieIdx = request.getParameter("movie_idx");

MovieDao dao = new MovieDao();
dao.deleteMovie(movieIdx);

response.sendRedirect("movieList.jsp");
%>