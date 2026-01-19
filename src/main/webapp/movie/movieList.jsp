<%@page import="member.MemberDao"%>
<%@page import="movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix - Premium Movie Community</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    /* 1. 전역 스타일 및 변수 정의 */
    :root {
        --primary-color: #E50914; /* 넷플릭스 레드 */
        --background-dark: #141414; /* 깊은 배경색 */
        --background-card: #1f1f1f;
        --text-white: #ffffff;
        --text-gray: #b3b3b3;
    }

    body {
        background-color: var(--background-dark);
        color: var(--text-white);
        font-family: 'Pretendard', sans-serif;
        overflow-x: hidden;
    }

    /* 2. 네비게이션 및 헤더 */
    .container { 
        margin-top: 50px; 
        margin-bottom: 80px; 
        max-width: 92%; 
    }
    
    .main-title {
        font-size: 2.2rem;
        font-weight: 800;
        letter-spacing: -1px;
        margin-bottom: 30px;
        background: linear-gradient(to right, #fff 20%, var(--primary-color) 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
    }

    /* 3. 필터 영역 (유리 질감 Glassmorphism) */
    .filter-area {
        background: rgba(255, 255, 255, 0.05);
        backdrop-filter: blur(10px);
        padding: 20px;
        border-radius: 12px;
        border: 1px solid rgba(255, 255, 255, 0.1);
        margin-bottom: 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .form-select {
        background-color: #222;
        color: white;
        border: 1px solid #444;
        transition: 0.3s;
    }

    .form-select:focus {
        background-color: #333;
        border-color: var(--primary-color);
        box-shadow: 0 0 0 0.25rem rgba(229, 9, 20, 0.25);
        color: white;
    }

    /* 4. 영화 카드 (호버 시 확대 및 그림자 효과) */
    .movie-card {
        background: none;
        border: none;
        transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
    }

    .poster-wrapper {
        position: relative;
        width: 100%;
        padding-top: 150%; /* 2:3 포스터 비율 */
        overflow: hidden;
        border-radius: 8px;
        box-shadow: 0 10px 20px rgba(0,0,0,0.5);
    }

    .poster-wrapper img {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.5s ease;
    }

    .movie-card:hover {
        transform: translateY(-10px) scale(1.03);
        z-index: 10;
    }

    .movie-card:hover img {
        transform: scale(1.1);
    }
    
    .logo{
    	width: 17%;
        letter-spacing: -1px;
        margin-bottom: 20px; 
    }
    
    .logo:hover {
        transform: translateY(-10px) scale(1.03);
        z-index: 10;
    }

    .logo:hover img {
        transform: scale(1.1);
    }
    

    /* 5. 페이지네이션 커스텀 */
    .pagination { justify-content: center; margin-top: 50px; }
    .page-link {
        background-color: #222;
        border: 1px solid #333;
        color: var(--text-gray);
        padding: 10px 18px;
        border-radius: 8px !important;
        margin: 0 5px;
        transition: 0.3s;
    }

    .page-link:hover {
        background-color: #333;
        color: white;
        border-color: var(--primary-color);
    }

    .page-item.active .page-link {
        background-color: var(--primary-color);
        border-color: var(--primary-color);
        color: white;
        box-shadow: 0 4px 15px rgba(229, 9, 20, 0.4);
    }

    /* 버튼 스타일링 */
    .btn-netflix {
        background-color: var(--primary-color);
        color: white;
        font-weight: bold;
        border: none;
        padding: 8px 20px;
        border-radius: 4px;
        transition: 0.3s;
    }

    .btn-netflix:hover {
        background-color: #c40812;
        color: white;
    }

    /* 로딩 스피너 강조 */
    .spinner-border {
        width: 3rem;
        height: 3rem;
    }
</style>
</head>
<body>

<div class="container">
<img class="logo" alt="" src="../save/whatflix-grunge-transparent2.PNG">
    <!-- <h3 class="main-title">WhatFlix Originals</h3> -->
    
    <div class="filter-area">
        <div class="d-flex gap-3 align-items-center">
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
            <div class="d-flex gap-2 adminDiv" style="visibility: hidden;">
                <button type="button" class="btn btn-netflix btn-sm" onclick="location='movieInsertForm.jsp'">
                    <i class="bi bi-plus-lg"></i> DB 등록
                </button>
                <button type="button" class="btn btn-outline-light btn-sm" onclick="location='movieApi.jsp'">
                    <i class="bi bi-cloud-download"></i> API 연동
                </button>
                <button type="button" class="btn btn-outline-light btn-sm" onclick="location='movieAutoInsert.jsp'">
                    <i class="bi bi-cloud-download"></i> 최근 인기 영화 등록
                </button>
            </div>
        </div>
        
        <div class="d-flex gap-2">
            <select class="form-select w-auto" id="sortSelect" onchange="loadMovieList(1)">
                <option value="latest">최신 등록순</option>
                <option value="rating">평점 높은순</option>
                <option value="release_day">개봉일순</option>
            </select>
        </div>
    </div>

    <div id="movie-list-container">
        <div class="text-center py-5">
            <div class="spinner-border text-danger" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-3 text-gray">콘텐츠를 불러오는 중입니다...</p>
        </div>
    </div>
</div>

<jsp:include page="chatWidget.jsp" />

<script>
    $(document).ready(function() {
        loadMovieList(1);
    });

    function loadMovieList(page) {
        var genreVal = $("#genreSelect").val();
        var sortVal = $("#sortSelect").val();
        
        $.ajax({
            type : "post",
            url : "movieListResult.jsp",
            data : {
                "currentPage" : page,
                "genre" : genreVal,
                "sortBy" : sortVal
            },
            dataType : "html",
            success : function(res) {
                // 부드러운 전환 효과를 위해 살짝 페이드인 처리 가능
                $("#movie-list-container").hide().html(res).fadeIn(400);
                window.scrollTo({ top: 0, behavior: 'smooth' });
            },
            error : function() {
                alert("데이터 로드 실패!");
            }
        });
    }
    
   <%
    String id=(String)session.getAttribute("id");
    
    MemberDao memberDao=new MemberDao();

    if(id!=null){
        
    String roleType=memberDao.getRoleType(id);
    //roleType.equals("")로 사용하게 되면 roleType이 null일 때 null.equals가 되어
    //nullpointerexception 에러가 발생 가능하기 때문에 확실한 값(상수)를 왼쪽에 두는 것이 좋다 - Null Safety(에러 방어)
    if("3".equals(roleType)||"9".equals(roleType)){
        %>
        $(".adminDiv").css("visibility","visible");              
    <%}
    }
    %> 
</script>

</body>
</html>