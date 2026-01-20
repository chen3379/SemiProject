<%@page import="movie.MovieDto"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
MovieDao dao = new MovieDao();
int limit = 15; // 섹션당 노출 개수

// 1. 지금 뜨는 콘텐츠 (개봉일순 정렬 - DAO에 관련 메서드가 있다고 가정)
List<MovieDto> newList = dao.getNewList(limit);
// 2. 새로 올라온 작품 (등록일순 정렬)
List<MovieDto> newUpdateList = dao.getNewUpdateList(limit);
// 3. 실시간 인기 순위 (조회수순 정렬)
List<MovieDto> popularList = dao.getPopularList(limit);
// 4. 회원님이 담은 영화 (세션의 ID를 활용해 가져옴)
// String userId = (String)session.getAttribute("myid");
// List<MovieDto> wishlist = dao.getWishlist(userId);
%>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

<style>
.content-section {
	margin-bottom: 3vw;
	padding: 0 4%;
	position: relative;
	overflow: hidden;
}

.section-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	margin-bottom: 15px;
}

.section-title {
	font-size: 1.4vw;
	font-weight: bold;
	color: #e5e5e5;
	margin: 0;
}

.more-link {
	font-size: 0.9vw;
	color: #54b9c5;
	text-decoration: none;
	font-weight: bold;
}

/* 슬라이더 영역 커스텀 */
.movie-swiper {
	overflow: clip;
} /* 카드가 커질 때 잘리지 않게 설정 */
.swiper-slide {
	width: 18%; /* 한 화면에 약 5~6개 노출 */
	transition: transform 0.3s ease;
	cursor: pointer;
}

.swiper-slide:hover {
	transform: scale(1.1);
	z-index: 100;
}

.poster-img {
	width: 100%;
	border-radius: 4px;
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.5);
	aspect-ratio: 2/3;
	object-fit: cover;
	margin-right: 10px;
}

/* 네비게이션 버튼 (넷플릭스 스타일) */
.swiper-button-next, .swiper-button-prev {
	z-index: 110 !important; color : white !important;
	background: rgba(0, 0, 0, 0.5);
	width: 50px;
	height: 100%;
	top: 0;
	margin-top: 0;
	color: white !important;
}

.swiper-button-next {
	right: 0;
}

.swiper-button-prev {
	left: 0;
}

/* 인기 순위 전용 스타일 */
.popular-swiper .swiper-slide {
	width: 25% !important; /* 숫자가 들어갈 공간 확보를 위해 조금 더 넓게 설정 */
	padding-left: 5vw; /* 숫자가 들어갈 왼쪽 여백 */
	overflow: visible;
	/* 	display: flex;
	align-items: flex-end; /* 숫자가 아래쪽에 위치하도록 */
	position: relative;
	*/
}

.rank-number {
	position: absolute;
	left: -5px;
	bottom: -10px;
	font-size: 10vw; /* 매우 크게 설정 */
	font-weight: 900;
	line-height: 1;
	color: #141414; /* 배경색과 동일하게 */
	-webkit-text-stroke: 2px #555; /* 외곽선만 보이게 설정 */
	z-index: 1;
	letter-spacing: -10px;
	/* user-select: none; */
}

.popular-swiper .poster-img {
	position: relative;
	z-index: 2; /* 숫자가 포스터 뒤로 가게 설정 */
	width: 100%;
}

.popular-swiper .swiper-slide:hover .rank-number {
	-webkit-text-stroke: 2px #E50914; /* 호버 시 숫자 테두리 빨간색으로 */
}
</style>

<section class="content-section">
	<div class="section-header">
		<h2 class="section-title">🏆 실시간 인기 순위</h2>
		<a href="../movie/movieList.jsp" class="more-link">더보기 <i
			class="bi bi-chevron-right"></i></a>
	</div>
	<div class="swiper movie-swiper popular-swiper">
		<div class="swiper-wrapper">
			<%
			int rank = 1;
			for (MovieDto dto : popularList) {
			%>
			<div class="swiper-slide"
				onclick="location.href='../movie/movieDetail.jsp?movie_idx=<%=dto.getMovieIdx()%>'">
				<span class="rank-number"><%=rank++%></span> <img
					src="<%=dto.getPosterPath()%>" alt="<%=dto.getTitle()%>"
					class="poster-img">
			</div>
			<%
			}
			%>
		</div>
		<div class="swiper-button-next"></div>
		<div class="swiper-button-prev"></div>
	</div>
</section>

<section class="content-section">
	<div class="section-header">
		<h2 class="section-title">지금 뜨는 작품</h2>
		<a href="../movie/movieList.jsp" class="more-link">더보기 <i
			class="bi bi-chevron-right"></i></a>
	</div>
	<div class="swiper movie-swiper trending-swiper">
		<div class="swiper-wrapper">
			<%
			for (MovieDto dto : newList) {
			%>
			<div class="swiper-slide"
				onclick="location.href='../movie/movieDetail.jsp?movie_idx=<%=dto.getMovieIdx()%>'">
				<img src="<%=dto.getPosterPath()%>" alt="<%=dto.getTitle()%>"
					class="poster-img">
			</div>
			<%
			}
			%>
		</div>
		<div class="swiper-button-next"></div>
		<div class="swiper-button-prev"></div>
	</div>
</section>

<section class="content-section">
	<div class="section-header">
		<h2 class="section-title">새로 올라온 작품</h2>
		<a href="../movie/movieList.jsp" class="more-link">전체보기 <i
			class="bi bi-chevron-right"></i></a>
	</div>
	<div class="swiper movie-swiper new-swiper">
		<div class="swiper-wrapper">
			<%
			for (MovieDto dto : newUpdateList) {
			%>
			<div class="swiper-slide"
				onclick="location.href='../movie/movieDetail.jsp?movie_idx=<%=dto.getMovieIdx()%>'">
				<img src="<%=dto.getPosterPath()%>" alt="<%=dto.getTitle()%>"
					class="poster-img">
			</div>
			<%
			}
			%>
		</div>
		<div class="swiper-button-next"></div>
		<div class="swiper-button-prev"></div>
	</div>
</section>

<script
	src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
	$(document).ready(function() {
		// 모든 movie-swiper 클래스에 대해 슬라이더 적용
		const swiper = new Swiper('.movie-swiper', {
			slidesPerView : 'auto',
			spaceBetween : 15,
			watchSlidesProgress : true,
			loop : false,
			navigation : {
				nextEl : '.swiper-button-next',
				prevEl : '.swiper-button-prev',
			},
			mousewheel : {
				forceToAxis : true, // 세로 스크롤 방해 금지
			},
			freeMode : true, // 마우스 휠이나 터치로 자유롭게 밀기
			on : {
				init : function() {
					this.update();
				}
			}
		});
	});
</script>