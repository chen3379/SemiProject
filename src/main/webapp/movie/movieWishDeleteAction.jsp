<%@page import="org.json.simple.JSONObject"%>
<%@page import="movie.MovieWishDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	JSONObject json = new JSONObject();
	
	String movieIdxStr = request.getParameter("movie_idx");
	String id = (String)session.getAttribute("id");
	Boolean loginStatus = (Boolean)session.getAttribute("loginStatus");
	
	// 파라미터 체크
	if(movieIdxStr == null || movieIdxStr.trim().isEmpty()){
	    json.put("status","FAIL");
	    json.put("message","movie_idx missing");
	    out.print(json.toString());
	    return;
	}
	
	int movieIdx = Integer.parseInt(movieIdxStr);
	
	// 로그인 체크
	if(loginStatus == null || loginStatus != true || id == null){
	    json.put("status","FAIL");
	    json.put("message","LOGIN_REQUIRED");
	    out.print(json.toString());
	    return;
	}
	
	MovieWishDao dao = new MovieWishDao();
	
	try{
	    dao.deleteWish(movieIdx, id);
	    json.put("status","OK");
	}catch(Exception e){
	    e.printStackTrace();
	    json.put("status","FAIL");
	    json.put("message","DB_ERROR");
	}
	
	out.print(json.toString());
%>
