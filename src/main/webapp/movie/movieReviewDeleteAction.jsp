<%@page import="org.json.simple.JSONObject"%>
<%@page import="movie.MovieReviewDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

JSONObject json = new JSONObject();

String movieIdxStr  = request.getParameter("movie_idx");
String reviewIdxStr = request.getParameter("review_idx");

if(movieIdxStr == null || reviewIdxStr == null){
  json.put("status", "FAIL");
  json.put("msg", "param missing");
  out.print(json.toString());
  return;
}

int movieIdx  = Integer.parseInt(movieIdxStr);
int reviewIdx = Integer.parseInt(reviewIdxStr);

MovieReviewDao dao = new MovieReviewDao();
dao.deleteReview(reviewIdx);

json.put("status", "OK");
json.put("movie_idx", movieIdx);
json.put("review_idx", reviewIdx);
out.print(json.toString());
%>