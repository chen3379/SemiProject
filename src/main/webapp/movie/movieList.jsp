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
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<style>
    /* [1] Expert Level: CSS Variables & Reset */
    :root {
        --primary-red: #E50914;
        --primary-red-hover: #B20710;
        --bg-main: #141414;
        --bg-surface: #181818;
        --text-white: #FFFFFF;
        --text-gray: #BCBCBC;
        --glass-bg: rgba(22, 22, 22, 0.6);
        --glass-border: rgba(255, 255, 255, 0.08);
        --shadow-elevation: 0 10px 40px -10px rgba(0,0,0,0.7);
        --transition-spring: cubic-bezier(0.175, 0.885, 0.32, 1.275); /* 쫀득한 느낌 */
        --transition-smooth: cubic-bezier(0.25, 0.46, 0.45, 0.94); /* 부드러운 느낌 */
    }

    /* 스크롤바 커스텀 (Webkit) */
    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: var(--bg-main); }
    ::-webkit-scrollbar-thumb { background: #333; border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: #555; }

    body {
        background-color: var(--bg-main);
        color: var(--text-white);
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
        overflow-x: hidden;
        -webkit-font-smoothing: antialiased; /* 폰트 렌더링 부드럽게 */
    }

    /* [2] Layout & Header */
    .container { 
        margin-top: 60px; 
        margin-bottom: 100px; 
        max-width: 1600px; /* 대화면 대응 */
        width: 94%;
        padding: 0 20px;
    }

    .logo {
        width: 180px;
        max-width: 100%;
        margin-bottom: 30px;
        filter: drop-shadow(0 0 15px rgba(229, 9, 20, 0.4)); /* 로고 발광 효과 */
        transition: transform 0.3s var(--transition-spring);
    }
    
    .logo:hover {
        transform: scale(1.05);
        cursor: pointer;
    }

    /* [3] Premium Glassmorphism Filter Bar */
    .filter-area {
        background: var(--glass-bg);
        backdrop-filter: blur(16px) saturate(180%); /* 배경을 흐리고 채도를 높여 생동감 부여 */
        -webkit-backdrop-filter: blur(16px) saturate(180%);
        padding: 16px 24px;
        border-radius: 12px;
        border: 1px solid var(--glass-border);
        box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
        margin-bottom: 50px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap; /* 모바일 대응 */
        gap: 15px;
    }

    /* Custom Select Box */
    .form-select {
        background-color: rgba(255, 255, 255, 0.08);
        color: var(--text-white);
        border: 1px solid var(--glass-border);
        border-radius: 6px;
        font-size: 0.95rem;
        font-weight: 500;
        padding: 10px 36px 10px 16px;
        cursor: pointer;
        transition: all 0.2s ease;
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23ffffff' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3e%3c/svg%3e");
    }

    .form-select:hover {
        background-color: rgba(255, 255, 255, 0.15);
    }

    .form-select:focus {
        background-color: #222;
        border-color: var(--primary-red);
        box-shadow: 0 0 0 4px rgba(229, 9, 20, 0.15);
        outline: none;
    }

    /* [4] Cinematic Movie Card */
    .movie-card {
        background: transparent;
        border: none;
        position: relative;
        cursor: pointer;
        /* 하드웨어 가속을 이용해 렌더링 최적화 */
        will-change: transform; 
        transition: transform 0.3s var(--transition-smooth);
    }

    .poster-wrapper {
        position: relative;
        width: 100%;
        padding-top: 145%; /* 비율 미세 조정 */
        overflow: hidden;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.3);
        background-color: #222; /* 로딩 전 배경색 */
        transition: box-shadow 0.3s ease;
    }

    .poster-wrapper img {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: transform 0.4s var(--transition-smooth);
    }
    
    /* Hover Effects: 전문가의 손길 */
    .movie-card:hover {
        transform: translateY(-8px);
        z-index: 2;
    }

    .movie-card:hover .poster-wrapper {
        box-shadow: var(--shadow-elevation);
    }
    
    .movie-card:hover img {
        transform: scale(1.08); /* 이미지만 살짝 확대 */
    }

    .movie-title {
        margin-top: 14px;
        font-size: 1.05rem;
        font-weight: 600;
        color: var(--text-white);
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis; /* 긴 제목 말줄임표 */
        transition: color 0.2s;
    }
    
    .movie-card:hover .movie-title {
        color: var(--primary-red);
    }

    .movie-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 6px;
        font-size: 0.85rem;
        color: var(--text-gray);
        font-weight: 500;
    }
    
    .movie-info i.bi-star-fill {
        font-size: 0.8rem;
        margin-right: 4px;
        position: relative;
        top: -1px;
    }

    /* [5] UI Components: Buttons & Pagination */
    .btn-netflix {
        background-color: var(--primary-red);
        color: white;
        font-weight: 600;
        border: none;
        padding: 8px 16px;
        border-radius: 4px;
        letter-spacing: 0.5px;
        transition: all 0.2s ease;
    }

    .btn-netflix:hover {
        background-color: var(--primary-red-hover);
        transform: scale(1.02);
    }
    
    .btn-outline-light {
        border-color: rgba(255,255,255,0.4);
        color: rgba(255,255,255,0.9);
    }
    
    .btn-outline-light:hover {
        background-color: rgba(255,255,255,0.1);
        border-color: #fff;
    }

    /* Pagination */
    .pagination { 
        gap: 6px; 
        margin-top: 80px;
    }
    
    .page-link {
        background-color: transparent;
        border: none;
        color: var(--text-gray);
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50% !important; /* 완전 원형 */
        font-weight: 600;
        transition: all 0.2s ease;
    }

    .page-link:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: white;
    }

    .page-item.active .page-link {
        background-color: var(--primary-red);
        color: white;
        box-shadow: 0 4px 12px rgba(229, 9, 20, 0.5); /* 붉은색 빛 */
    }
    
    /* Loading Spinner */
    .spinner-border {
        border-width: 3px;
    }
    
    /* Admin Area Visibility Control (JS에서 제어하지만 기본 스타일 정의) */
    .adminDiv {
        transition: opacity 0.3s ease;
    }
</style>
</head>
<body>
    <jsp:include page="../main/nav.jsp" />
    <jsp:include page="../login/loginModal.jsp" />
    <jsp:include page="../profile/profileModal.jsp"/>

<div class="container">
<br>
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
                <option value="latest">등록순</option>
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
            <p class="mt-3 text-gray">콘텐츠를 불러오는 중입니다...</p>
        </div>
    </div>
</div>

<jsp:include page="chatWidget.jsp" />
<jsp:include page="../main/footer.jsp" />

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
    String roleType=(String)session.getAttribute("roleType");

    if(id!=null){
        
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