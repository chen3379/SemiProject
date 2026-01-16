<%-- 별점입력 + 별점통계갱신 --%>

<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="movie.MovieRatingDao"%>
<%@page import="movie.MovieRatingStatDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
JSONObject json = new JSONObject();

try {
    int movieIdx = Integer.parseInt(request.getParameter("movie_idx"));
    BigDecimal score = new BigDecimal(request.getParameter("score"));

    String id = (String)session.getAttribute("id");
    if (id == null) id = "guest";

    MovieRatingDao dao = new MovieRatingDao();
    if (dao.isRating(movieIdx, id)) dao.updateRating(movieIdx, id, score);
    else dao.insertRating(movieIdx, id, score);

    MovieRatingStatDao statDao = new MovieRatingStatDao();
    statDao.refreshStat(movieIdx);

    json.put("status", "OK");

} catch(Exception e) {
    e.printStackTrace();
    json.put("status", "ERROR");
    json.put("message", "서버 오류");
}

out.print(json.toString());
%>
