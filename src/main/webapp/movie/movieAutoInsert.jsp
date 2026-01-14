<%@page import="movie.MovieDao"%>
<%@page import="movie.MovieDto"%>
<%@page import="java.util.List"%>
<%@page import="movie.TmdbApi"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <h2>최근 인기 영화 자동 등록</h2>
    <hr>
    
    <div class="alert alert-info">
        TMDB 인기 영화 목록을 기반으로 데이터를 수집하고 DB에 저장합니다.<br>
        (이미 등록된 영화 ID는 자동으로 건너뜁니다.)
    </div>

    <ul class="list-group">
    <%
        TmdbApi api = new TmdbApi();
        MovieDao dao = new MovieDao();
        
        int successCount = 0;
        int failCount = 0; // 중복 포함
        
        // 1페이지당 20개씩 옴. (필요하면 for문 돌려서 page 1, 2, 3... 늘리면 됩니다)
        // 현재는 1페이지(상위 20개)만 가져옴
        List<MovieDto> list = api.getPopularMovies(1); 
        
        for(MovieDto dto : list) {
            
            // ★ [개선된 로직] 먼저 DB에 있는지 물어본다.
            if (dao.isMovieExist(dto.getMovieId())) {
                // 1. 이미 있으면 -> 중복 카운트 증가하고 건너뜀 (continue)
                failCount++;
    %>
                <li class="list-group-item list-group-item-warning">
                    <b>[중복]</b> <%=dto.getTitle() %> (ID: <%=dto.getMovieId()%>) - 이미 등록된 영화입니다.
                </li>
    <%
                continue; // 다음 영화로 넘어감
            }

            // 2. 없으면 -> 그제서야 저장 시도
            try {
                dto.setCreateId("admin");
                dao.insertMovie(dto);
                successCount++;
    %>
                <li class="list-group-item list-group-item-success">
                    <b>[성공]</b> <%=dto.getTitle() %> 저장 완료!
                </li>
    <%
            } catch (Exception e) {
                // 여기서 잡히는 에러는 '중복'이 아니라 '진짜 DB 에러'입니다.
    %>
                <li class="list-group-item list-group-item-danger">
                    <b>[에러]</b> <%=dto.getTitle() %> 저장 실패 (마스터관리자 문의 필요)
                    <br><small><%=e.getMessage()%></small>
                </li>
    <%
            }
        }
    %>
    </ul>
    
    <div class="mt-4 p-3 bg-light border rounded text-center">
        <h4>최근 인기 영화 자동 업데이트 결과</h4>
        <p class="text-success fw-bold">성공: <%=successCount%>건</p>
        <p class="text-danger fw-bold">중복(건너뜀): <%=failCount%>건</p>
        <button class="btn btn-primary mt-2" onclick="location.href='movieList.jsp'">영화 목록</button>
    </div>
</div>
</body>
</html>