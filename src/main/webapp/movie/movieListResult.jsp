<%@page import="java.math.BigDecimal"%>
<%@page import="movie.MovieRatingStatDao"%>
<%@page import="movie.MovieDto"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
// 파라미터 수신 (없으면 기본값)
String genre = request.getParameter("genre");
String sortBy = request.getParameter("sortBy");
String currentPageStr = request.getParameter("currentPage");

if (genre == null || genre.isEmpty())
    genre = "all";
if (sortBy == null || sortBy.isEmpty())
    sortBy = "latest";

int currentPage = 1;
if (currentPageStr != null && !currentPageStr.isEmpty()) {
    currentPage = Integer.parseInt(currentPageStr);
}

// DB 연결 및 데이터 조회
MovieDao dao = new MovieDao();
int perPage = 20; // 한 페이지당 영화 수
int perBlock = 5; // 페이지 번호 묶음 (1~5, 6~10)
int startNum = (currentPage - 1) * perPage;

// 전체 개수 구하기 / 장르별 개수
int totalCount = 0;
if (genre.equals("all")) {
    totalCount = dao.getTotalCount();
} else {
    totalCount = dao.getTotalCountByGenre(genre);
}

// 페이지 계산 (데이터가 없으면 1페이지로 처리해 에러 방지)
int totalPage = totalCount / perPage + (totalCount % perPage == 0 ? 0 : 1);
if (totalPage == 0)
    totalPage = 1;

int startPage = (currentPage - 1) / perBlock * perBlock + 1;
int endPage = startPage + perBlock - 1;
if (endPage > totalPage)
    endPage = totalPage;

// 리스트 가져오기
List<MovieDto> list = null;
if (genre.equals("all")) {
    if (sortBy.equals("rating"))
        list = dao.getRatingList(startNum, perPage);
    else if (sortBy.equals("release_day"))
        list = dao.getReleaseDayList(startNum, perPage);
    else
        list = dao.getCreateDayList(startNum, perPage);
} else {
    if (sortBy.equals("rating"))
        list = dao.getRatingListByGenre(genre, startNum, perPage);
    else if (sortBy.equals("release_day"))
        list = dao.getReleaseDayListByGenre(genre, startNum, perPage);
    else
        list = dao.getCreateDayListByGenre(genre, startNum, perPage);
}

// 평균 별점 가져오기
MovieRatingStatDao statDao = new MovieRatingStatDao();
%>
<div class="row row-cols-2 row-cols-md-4 row-cols-lg-5 g-4">
	<%
	if (list == null || list.size() == 0) {
	%>
	<div class="col-12 text-center py-5">
		<i class="bi bi-film" style="font-size: 3rem; color: #ccc;"></i>
		<p class="text-muted mt-3">해당 조건의 영화가 없습니다.</p>
	</div>
	<%
	} else {
	for (MovieDto dto : list) {
	    String fullPosterPath = "../save/no_image.jpg";
	    String dbPoster = dto.getPosterPath();

	    if (dbPoster != null && !dbPoster.isEmpty()) {
	        if (dbPoster.startsWith("http"))
	    fullPosterPath = dbPoster;
	        else
	    fullPosterPath = "../save/" + dbPoster;
	    }

	    //평균별점 조회
	%>
	<div class="col">
		<div class="movie-card"
			onclick="location.href='movieDetail.jsp?movie_idx=<%=dto.getMovieIdx()%>'">
			<div class="poster-wrapper">
				<img src="<%=fullPosterPath%>"
					onerror="this.src='../save/no_image.jpg'" alt="<%=dto.getTitle()%>">
			</div>
			<div class="movie-title"><%=dto.getTitle()%></div>
			<div class="movie-info d-flex justify-content-between">
				<span> <%=(dto.getReleaseDay() != null && dto.getReleaseDay().length() >= 4) ? dto.getReleaseDay().substring(0, 4) : ""%>
				</span> <span><i class="bi bi-star-fill text-warning"></i><%=String.format("%.1f", dto.getAvgScore())%>
				</span>
			</div>
		</div>
	</div>
	<%
	}
	}
	%>
</div>

<!-- 페이징 처리 -->
<%
if (totalCount > 0) {
%>
<div class="mt-5">
	<nav aria-label="Page navigation">
		<ul class="pagination justify-content-center">

			<%
			if (startPage > 1) {
			%>
			<li class="page-item">
				<button type="button" class="page-link"
					onclick="loadMovieList(<%=startPage - 1%>)">
					<i class="bi bi-chevron-left"></i>
				</button>
			</li>
			<%
			}
			%>

			<%
			for (int pp = startPage; pp <= endPage; pp++) {
			%>
			<li class="page-item <%=pp == currentPage ? "active" : ""%>">
				<button type="button" class="page-link"
					onclick="loadMovieList(<%=pp%>)"><%=pp%></button>
			</li>
			<%
			}
			%>

			<%
			if (endPage < totalPage) {
			%>
			<li class="page-item">
				<button type="button" class="page-link"
					onclick="loadMovieList(<%=endPage + 1%>)">
					<i class="bi bi-chevron-right"></i>
				</button>
			</li>
			<%
			}
			%>

		</ul>
	</nav>
</div>
<%
}
%>