<%@page import="java.net.URLEncoder"%>
<%@page import="movie.MovieDto"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
    /* 전체 컨테이너 여백 */
    .container { margin-top: 30px; margin-bottom: 50px; max-width: 1400px; }
    
    /* 포스터 이미지 스타일 (왓챠 스타일) */
    .movie-card {
        border: none; /* 카드 테두리 제거 */
        transition: transform 0.2s;
        cursor: pointer;
    }
    .movie-card:hover {
        transform: translateY(-5px); /* 호버 시 살짝 위로 */
    }
    .poster-wrapper {
        position: relative;
        width: 100%;
        padding-top: 145%; /* 1:1.45 비율 유지 (포스터 표준 비율) */
        overflow: hidden;
        border-radius: 6px;
        background-color: #f0f0f0;
        border: 1px solid #eaeaea;
    }
    .poster-wrapper img {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    
    /* 텍스트 스타일 */
    .movie-title {
        margin-top: 10px;
        font-weight: 600;
        font-size: 1rem;
        color: #000;
        /* 긴 제목 말줄임표 처리 */
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .movie-info {
        font-size: 0.85rem;
        color: #888;
    }
    
    /* 필터 영역 스타일 */
    .filter-area {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    
    /* 페이지네이션 링크 스타일 */
    .page-link { color: #333; }
    .page-item.active .page-link {
        background-color: #ff2f6e; /* 왓챠 핑크색 포인트 */
        border-color: #ff2f6e;
        color: white;
    }
</style>
</head>
<%
    MovieDao dao = new MovieDao();
    
    // 1. 파라미터 받기 (검색 조건)
    String genre = request.getParameter("genre");
    String sortBy = request.getParameter("sortBy");
    
    // 기본값 설정
    if(genre == null || genre.equals("all") || genre.isEmpty()) genre = "all";
    if(sortBy == null || sortBy.isEmpty()) sortBy = "latest"; // latest, rating, release_day
    
    // 2. 페이징 처리를 위한 변수 선언
    int totalCount = 0; // 조건에 맞는 총 개수
    
    // 장르 선택 여부에 따라 전체 개수 다르게 가져오기
    if(genre.equals("all")) {
        totalCount = dao.getTotalCount();
    } else {
        totalCount = dao.getTotalCountByGenre(genre);
    }
    
    int perPage = 20; // 한 페이지당 보여줄 영화 수 (그리드에 맞춰 조정)
    int perBlock = 5; 
    int currentPage; 
    
    if (request.getParameter("currentPage") == null)
        currentPage = 1;
    else
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
        
    int startNum = (currentPage - 1) * perPage;
    
    int totalPage = totalCount / perPage + (totalCount % perPage == 0 ? 0 : 1);
    int startPage = (currentPage - 1) / perBlock * perBlock + 1;
    int endPage = startPage + perBlock - 1;
    if (endPage > totalPage) endPage = totalPage;
    
    // 3. 조건에 맞는 리스트 가져오기 (핵심 로직)
    List<MovieDto> list = null;
    
    if(genre.equals("all")) {
        // 전체 장르일 때 정렬
        if(sortBy.equals("rating")) {
            list = dao.getRatingList(startNum, perPage);
        } else if(sortBy.equals("release_day")) {
            list = dao.getReleaseDayList(startNum, perPage);
        } else {
            list = dao.getCreateDayList(startNum, perPage); // default: latest
        }
    } else {
        // 특정 장르일 때 정렬
        if(sortBy.equals("rating")) {
            list = dao.getRatingListByGenre(genre, startNum, perPage);
        } else if(sortBy.equals("release_day")) {
            list = dao.getReleaseDayListByGenre(genre, startNum, perPage);
        } else {
            list = dao.getCreateDayListByGenre(genre, startNum, perPage);
        }
    }
    
%>
<body>
<div class="container">
    
    <h3 class="fw-bold mb-4">현재 등록된 영화 (<%=dao.getTotalCount() %>)</h3>
    
    <div class="filter-area">
        <div class="d-flex gap-2">
            <select class="form-select w-auto" id="genreSelect" onchange="applyFilter()">
            <!-- 새로고침시 select 박스 초기화를 막기 위해 selected 속성 부여 -->
                <option value="all" <%=genre.equals("all")?"selected":"" %>>모든 장르</option>
                <option value="액션" <%=genre.equals("액션")?"selected":"" %>>액션</option>
                <option value="코미디" <%=genre.equals("코미디")?"selected":"" %>>코미디</option>
                <option value="SF" <%=genre.equals("SF")?"selected":"" %>>SF</option>
                <option value="공포" <%=genre.equals("공포")?"selected":"" %>>공포</option>
                <option value="스릴러" <%=genre.equals("스릴러")?"selected":"" %>>스릴러</option>
                <option value="로맨스" <%=genre.equals("로맨스")?"selected":"" %>>로맨스</option>
                <option value="드라마" <%=genre.equals("드라마")?"selected":"" %>>드라마</option>
                <option value="판타지" <%=genre.equals("판타지")?"selected":"" %>>판타지</option>
                <option value="뮤지컬" <%=genre.equals("뮤지컬")?"selected":"" %>>뮤지컬</option>
                <option value="전쟁" <%=genre.equals("전쟁")?"selected":"" %>>전쟁</option>
                <option value="가족" <%=genre.equals("가족")?"selected":"" %>>가족</option>
                <option value="범죄" <%=genre.equals("범죄")?"selected":"" %>>범죄</option>
                <option value="애니메이션" <%=genre.equals("애니메이션")?"selected":"" %>>애니메이션</option>
            </select>
            <button onclick="location='movieInsertForm.jsp'">신규 영화 등록(DB)</button>
            <button onclick="location='movieApi.jsp'">신규 영화 등록(API)</button>            
        </div>
        
        <div class="d-flex gap-2">
            <select class="form-select w-auto" id="sortSelect" onchange="applyFilter()">
                <option value="latest" <%=sortBy.equals("latest")?"selected":"" %>>최신등록순</option>
                <option value="rating" <%=sortBy.equals("rating")?"selected":"" %>>평점순</option>
                <option value="release_day" <%=sortBy.equals("release_day")?"selected":"" %>>개봉일순</option>
            </select>
        </div>
    </div>
    
    <div class="row row-cols-2 row-cols-md-4 row-cols-lg-5 g-4">
    <%
        if(list.size() == 0) {
    %>
        <div class="col-12 text-center py-5">
            <p class="text-muted">등록된 영화가 없습니다.</p>
        </div>
    <%
        } else {
            for(MovieDto dto : list) {
                
                String dbPosterPath= dto.getPosterPath();
                String fullPosterPath="";
                //값이 없거나 || 값이 할당되었지만 길이가 0, 포스터가 없을 때
                if(dbPosterPath==null||dbPosterPath.isEmpty()){
                    fullPosterPath="../save/no_image.jpg";
                }
                //포스터가 API 데이터인 경우(http로 시작할 때)
                else if(dbPosterPath.startsWith("http")){
                    fullPosterPath=dbPosterPath;
                }
                //포스터를 직접 업로드한 경우
                else{
                    fullPosterPath="../save/"+dbPosterPath;
                }
    %>
        <div class="col">
            <div class="movie-card" onclick="location.href='movieDetail.jsp?movie_idx=<%=dto.getMovieIdx()%>'">
                <div class="poster-wrapper">
                    <img src="<%=fullPosterPath %>" 
                         onerror="this.src='../save/no_image.jpg'" 
                         alt="<%=dto.getTitle()%>">
                </div>
                <div class="movie-title"><%=dto.getTitle()%></div>
                
                <div class="movie-info d-flex justify-content-between">
                    <span><%=dto.getReleaseDay().length() >= 4 ? dto.getReleaseDay().substring(0, 4) : dto.getReleaseDay() %></span>
                    <span><i class="bi bi-star-fill text-warning"></i> 
                    <%-- 평점 필드가 있다면 표시, 없다면 임의 표시 --%>
                    <%= dto.getReadcount() > 0 ? "인기" : "신규 등록" %>
                    </span>
                </div>
            </div>
        </div>
    <%
            }
        }
    %>
    </div> <div class="mt-5">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                
                <!-- 페이지를 이동하거나 새로고침 했을 때 선택한 카테고리가 풀리면 안 되기 때문에 href에 genre와 sortBy 함께 넘겨줘야 함 -->
                <% if (startPage > 1) { %>
                <li class="page-item">
                    <a class="page-link" href="movieList.jsp?currentPage=<%=startPage - 1%>&genre=<%=genre%>&sortBy=<%=sortBy%>">이전</a>
                </li>
                <% } %>
                
                <% for (int pp = startPage; pp <= endPage; pp++) { %>
                    <li class="page-item <%=pp == currentPage ? "active" : ""%>">
                        <a class="page-link" href="movieList.jsp?currentPage=<%=pp%>&genre=<%=genre%>&sortBy=<%=sortBy%>"><%=pp%></a>
                    </li>
                <% } %>
                
                <% if (endPage < totalPage) { %>
                <li class="page-item">
                    <a class="page-link" href="movieList.jsp?currentPage=<%=endPage + 1%>&genre=<%=genre%>&sortBy=<%=sortBy%>">다음</a>
                </li>
                <% } %>
                
            </ul>
        </nav>
    </div>
    
</div>

<script>
    // 필터 변경 시 실행되는 함수
    function applyFilter() {
        var genre = document.getElementById("genreSelect").value;
        var sortBy = document.getElementById("sortSelect").value;
        
        // 페이지를 새로고침하며 파라미터 전달 (항상 1페이지부터 시작)
        location.href = "movieList.jsp?currentPage=1&genre=" + genre + "&sortBy=" + sortBy;
    }
</script>

</body>
</html>