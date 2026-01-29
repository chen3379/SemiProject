<%@page import="org.json.simple.JSONObject"%>
<%@page import="movie.MovieReviewDto"%>
<%@page import="movie.MovieReviewDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
JSONObject json = new JSONObject();

try {
    int movieIdx = Integer.parseInt(request.getParameter("movie_idx"));
    String content = request.getParameter("content");

    if (content == null || content.trim().isEmpty()) {
        json.put("status", "FAIL");
        json.put("message", "내용을 입력해주세요.");
        out.print(json.toString());
        return;
    }

    String id = (String)session.getAttribute("id");

    if (id == null) {
        json.put("status", "FAIL");
        json.put("message", "로그인이 필요합니다.");
        out.print(json.toString());
        return;
    }
    MovieReviewDto dto = new MovieReviewDto();
    dto.setMovieIdx(movieIdx);
    dto.setId(id);
    dto.setContent(content);

    MovieReviewDao dao = new MovieReviewDao();
    boolean ok = dao.insertReview(dto);

    json.put("status", ok ? "OK" : "FAIL");
    if (!ok) json.put("message", "이미 이 영화에 한줄평을 작성했어요.");

} catch (Exception e) {
    e.printStackTrace();
    json.put("status", "ERROR");
    json.put("message", "서버 오류");
}

out.print(json.toString());
%>
