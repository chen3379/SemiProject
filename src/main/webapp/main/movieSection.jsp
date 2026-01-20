<%@page import="movie.MovieDto"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
int startNum = 0;
int perPage = 15;

MovieDao dao = new MovieDao();

List<MovieDto> list = null;
list = dao.getAllList(startNum, perPage);
%>
<section class="content-section">
    <div class="section-header">
        <h2 class="section-title">🔥 지금 뜨는 콘텐츠</h2>
        <a href="movieDetail.jsp" class="more-link">더보기 <i class="bi bi-chevron-right"></i></a>
    </div>
    <div class="movie-slider-placeholder" style="height: 200px; background: rgba(255,255,255,0.02); border-radius: 8px;"></div>
</section>

<section class="content-section" style="animation-delay: 0.1s;">
    <div class="section-header">
        <h2 class="section-title">✨ 새로 올라온 작품</h2>
        <a href="movieDetail.jsp" class="more-link">전체보기 <i class="bi bi-chevron-right"></i></a>
    </div>
    <div class="movie-slider-placeholder" style="height: 200px; background: rgba(255,255,255,0.02); border-radius: 8px;"></div>
</section>

<section class="content-section" style="animation-delay: 0.2s;">
    <div class="section-header">
        <h2 class="section-title">🏆 실시간 인기 순위</h2>
        <a href="movieDetail.jsp" class="more-link">순위보기 <i class="bi bi-chevron-right"></i></a>
    </div>
    <div class="movie-slider-placeholder" style="height: 200px; background: rgba(255,255,255,0.02); border-radius: 8px;"></div>
</section>

<section class="content-section" style="animation-delay: 0.3s;">
    <div class="section-header">
        <h2 class="section-title">❤️ 회원님이 담은 영화</h2>
        <a href="movieDetail.jsp" class="more-link">보관함 이동 <i class="bi bi-chevron-right"></i></a>
    </div>
    <div class="movie-slider-placeholder" style="height: 200px; background: rgba(255,255,255,0.02); border-radius: 8px;"></div>
</section>