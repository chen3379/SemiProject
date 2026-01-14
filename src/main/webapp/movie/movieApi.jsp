<%@page import="movie.MovieDto"%>
<%@page import="java.util.List"%>
<%@page import="movie.TmdbApi"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");
    String query = request.getParameter("q");
    String selectedId = request.getParameter("id"); // 상세 조회할 ID
    
    TmdbApi api = new TmdbApi();
    List<MovieDto> searchList = null;
    MovieDto detailDto = null;
    
    // 1. 검색어가 있으면 목록 검색
    if(query != null && !query.isEmpty()){
        searchList = api.searchMovie(query);
    }
    
    // 2. ID가 넘어왔으면 상세 조회 실행
    if(selectedId != null && !selectedId.isEmpty()){
        detailDto = api.getMovieDetail(selectedId);
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <button onclick="location='movieList.jsp'">목록</button>
    <h2>TMDB 영화 데이터 조회</h2>
    <form class="d-flex mb-4 gap-2">
        <input type="text" name="q" class="form-control" placeholder="영화 제목 (예: 기생충)" value="<%=query!=null?query:""%>">
        <button style="min-width: 80px; white-space: nowrap;" type="submit" class="btn btn-primary">검색</button>
    </form>

    <div class="row">
        <div class="col-md-4">
            <% if(searchList != null) { %>
                <div class="list-group">
                <% for(MovieDto m : searchList) { %>
                    <a href="movieApi.jsp?q=<%=query%>&id=<%=m.getMovieId()%>" 
                       class="list-group-item list-group-item-action <%= (detailDto!=null && m.getMovieId().equals(detailDto.getMovieId())) ? "active" : "" %>">
                        <%=m.getTitle()%> (<%=m.getReleaseDay().split("-")[0]%>)
                    </a>
                <% } %>
                </div>
            <% } %>
        </div>

        <div class="col-md-8">
            <% if(detailDto != null) { %>
                <div class="card p-3">
                    <div class="row">
                        <div class="col-4">
                            <img src="<%=detailDto.getPosterPath()%>" class="img-fluid rounded">
                        </div>
                        <div class="col-8">
                            <h3><%=detailDto.getTitle()%></h3>
                            <span class="badge bg-danger"><%=detailDto.getGenre()%></span>
                            <span class="badge bg-secondary"><%=detailDto.getCountry()%></span>
                            <hr>
                            <p><strong>감독:</strong> <%=detailDto.getDirector()%></p>
                            <p><strong>출연:</strong> <%=detailDto.getCast()%></p>
                            <p><strong>개봉:</strong> <%=detailDto.getReleaseDay()%></p>
                            <p><strong>트레일러:</strong> <a href="<%=detailDto.getTrailerUrl()%>" target="_blank"><%=detailDto.getTrailerUrl()%></a></p>
                            <div class="bg-light p-2 rounded"><small><%=detailDto.getSummary()%></small></div>
                            
                            <form action="movieApiInsertAction.jsp" method="post" class="mt-3">
                                <input type="hidden" name="movie_id" value="<%=detailDto.getMovieId()%>">
                                <input type="hidden" name="title" value="<%=detailDto.getTitle()%>">
                                <input type="hidden" name="genre" value="<%=detailDto.getGenre()%>">
                                <input type="hidden" name="country" value="<%=detailDto.getCountry()%>">
                                <input type="hidden" name="director" value="<%=detailDto.getDirector()%>">
                                <input type="hidden" name="cast" value="<%=detailDto.getCast()%>">
                                <input type="hidden" name="release_day" value="<%=detailDto.getReleaseDay()%>">
                                <input type="hidden" name="poster_path" value="<%=detailDto.getPosterPath()%>"> <input type="hidden" name="trailer_url" value="<%=detailDto.getTrailerUrl()%>">
                                <input type="hidden" name="summary" value="<%=detailDto.getSummary()%>">
                                <input type="hidden" name="create_id" value="admin">
                                
                                <button type="submit" class="btn btn-success w-100 fw-bold">이 정보로 DB 등록하기</button>
                            </form>
                        </div>
                    </div>
                </div>
            <% } else if (searchList != null) { %>
                <div class="alert alert-info">왼쪽 목록에서 영화를 선택하면 상세 정보를 불러옵니다.</div>
            <% } %>
        </div>
    </div>
</div>
</body>
</html>