<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="movie.MovieRatingDao"%>

<%
response.setContentType("application/json");
request.setCharacterEncoding("UTF-8");

JSONObject json = new JSONObject();

try {
    // 로그인 체크
    String id = (String)session.getAttribute("id");   // 필요시 "idok"로 변경
    if (id == null || id.trim().isEmpty()) {
        json.put("status", "FAIL");
        json.put("message", "로그인이 필요합니다.");
        out.print(json.toString());
        return;
    }

    // 파라미터 받기
    String movieIdxStr = request.getParameter("movie_idx");
    String scoreStr = request.getParameter("score");

    if (movieIdxStr == null || scoreStr == null || movieIdxStr.trim().isEmpty() || scoreStr.trim().isEmpty()) {
        json.put("status", "FAIL");
        json.put("message", "필수 값이 누락되었습니다.");
        out.print(json.toString());
        return;
    }

    int movieIdx = Integer.parseInt(movieIdxStr);

    // 점수 유효성 (0.5~5.0)
    BigDecimal score = new BigDecimal(scoreStr);
    if (score.compareTo(new BigDecimal("0.5")) < 0 || score.compareTo(new BigDecimal("5.0")) > 0) {
        json.put("status", "FAIL");
        json.put("message", "별점 값이 올바르지 않습니다.");
        out.print(json.toString());
        return;
    }

    // 업데이트 실행
    MovieRatingDao dao = new MovieRatingDao();

    // 너 DAO에 updateRating(movieIdx, id, score) 메서드가 있다는 전제로 호출
    boolean ok = dao.updateRating(movieIdx, id, score);

    if (ok) {
        json.put("status", "OK");
    } else {
        json.put("status", "FAIL");
        json.put("message", "별점 수정에 실패했습니다.");
    }

} catch (Exception e) {
    e.printStackTrace();
    json.put("status", "FAIL");
    json.put("message", "서버 오류");
}

out.print(json.toString());
%>
