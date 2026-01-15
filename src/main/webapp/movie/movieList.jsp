<%@page import="movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
    /* 기존 CSS 유지 */
    .container { margin-top: 30px; margin-bottom: 50px; max-width: 1400px; }
    .movie-card { border: none; transition: transform 0.2s; cursor: pointer; }
    .movie-card:hover { transform: translateY(-5px); }
    .poster-wrapper { position: relative; width: 100%; padding-top: 145%; overflow: hidden; border-radius: 6px; background-color: #f0f0f0; border: 1px solid #eaeaea; }
    .poster-wrapper img { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; }
    .movie-title { margin-top: 10px; font-weight: 600; font-size: 1rem; color: #000; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .movie-info { font-size: 0.85rem; color: #888; }
    .filter-area { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    
    /* 페이지네이션 버튼 스타일 */
    .page-link { color: #333; cursor: pointer; border: none; margin: 0 2px; border-radius: 5px; }
    .page-item.active .page-link { background-color: #ff2f6e; color: white; }
    .page-link:hover { color: #ff2f6e; background-color: #f8f9fa; }
    .page-item.active .page-link:hover { color: white; background-color: #ff2f6e; }
</style>
</head>
<body>

<div class="container">
    <h3 class="fw-bold mb-4">WhatFlix 영화</h3>
    
    <div class="filter-area">
        <div class="d-flex gap-2">
            <select class="form-select w-auto" id="genreSelect" onchange="loadMovieList(1)">
                <option value="all">모든 장르</option>
                <option value="액션">액션</option>
                <option value="코미디">코미디</option>
                <option value="SF">SF</option>
                <option value="공포">공포</option>
                <option value="스릴러">스릴러</option>
                <option value="로맨스">로맨스</option>
                <option value="드라마">드라마</option>
                <option value="판타지">판타지</option>
                <option value="뮤지컬">뮤지컬</option>
                <option value="전쟁">전쟁</option>
                <option value="가족">가족</option>
                <option value="범죄">범죄</option>
                <option value="애니메이션">애니메이션</option>
            </select>
            <button type="button" class="btn btn-dark" onclick="location='movieInsertForm.jsp'">DB 등록</button>
            <button type="button" class="btn btn-outline-danger" onclick="location='movieApi.jsp'">API 등록</button>            
        </div>
        
        <div class="d-flex gap-2">
            <select class="form-select w-auto" id="sortSelect" onchange="loadMovieList(1)">
                <option value="latest">최신등록순</option>
                <option value="rating">평점순</option>
                <option value="release_day">개봉일순</option>
            </select>
        </div>
    </div>
    
    <div id="movie-list-container">
        <div class="text-center py-5">
            <div class="spinner-border text-danger" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>
    </div>
    
</div>

<jsp:include page="chatWidget.jsp"/>

<script>
    // 1. 페이지 로드 시 자동으로 1페이지 불러오기
    $(document).ready(function(){
        loadMovieList(1);
    });

    // 2. 목록 불러오기 함수 (AJAX)
    // - page: 이동할 페이지 번호
    function loadMovieList(page) {
        
        // 현재 사용자가 선택해놓은 필터값들을 읽어옵니다.
        var genreVal = $("#genreSelect").val();
        var sortVal = $("#sortSelect").val();
        
        // 알맹이 파일(Result.jsp)에게 조건과 페이지를 보냅니다.
        $.ajax({
            type: "post",
            url: "movieListResult.jsp",
            data: {
                "currentPage": page,
                "genre": genreVal,
                "sortBy": sortVal
            },
            dataType: "html",
            success: function(res) {
                // 받아온 영화 목록 HTML을 갈아끼웁니다.
                $("#movie-list-container").html(res);
                
                // (선택사항) 페이지 이동 시 스크롤 살짝 위로
                window.scrollTo(0, 0); 
            },
            error: function() {
                alert("서버 통신 실패! 다시 시도해주세요.");
            }
        });
    }
</script>
</body>
</html>