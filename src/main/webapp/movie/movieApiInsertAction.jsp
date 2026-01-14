<%@page import="movie.MovieDao"%>
<%@page import="movie.MovieDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // movieApiInsertAction.jsp
    // API에서 넘어온 데이터를 DB에 저장하는 역할 (파일 업로드 X, 텍스트만 처리)
    
    request.setCharacterEncoding("utf-8");

    MovieDto dto = new MovieDto();
    
    // hidden 태그로 넘어온 값들을 다 받습니다.
    dto.setMovieId(request.getParameter("movie_id"));
    dto.setTitle(request.getParameter("title"));
    dto.setGenre(request.getParameter("genre"));
    dto.setCountry(request.getParameter("country"));
    dto.setDirector(request.getParameter("director"));
    dto.setCast(request.getParameter("cast"));
    dto.setReleaseDay(request.getParameter("release_day"));
    dto.setSummary(request.getParameter("summary"));
    
    // ★ 중요: 여기서는 파일명 대신 "이미지 URL 전체"가 들어옵니다.
    // 예: https://image.tmdb.org/t/p/w500/abcd.jpg
    dto.setPosterPath(request.getParameter("poster_path"));
    
    dto.setTrailerUrl(request.getParameter("trailer_url"));
    dto.setCreateId(request.getParameter("create_id")); // admin

    // DB 저장
    MovieDao dao = new MovieDao();
    dao.insertMovie(dto);
    
    // 저장이 끝나면 메인 목록으로 이동 -> db 빠른 입력용으로 편하게 임시 변경상태
    response.sendRedirect("movieApi.jsp");
%>