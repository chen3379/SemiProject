<%@page import="java.util.ArrayList"%>
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
// [추가] 배너용 리스트 추출 (인기순위 상위 5개만 배너로 사용)
List<MovieDto> bannerList = new ArrayList<MovieDto>();
if (popularList != null && popularList.size() >= 5) {
	bannerList = popularList.subList(0, 5);
} else {
	bannerList = popularList;
}
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
	z-index: 110 !important;
	color: white !important;
	/* background: rgba(0, 0, 0, 0.5); */
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

/* [HERO BANNER] 넷플릭스 스타일 메인 배너 */
.hero-banner {
	width: 100%;
	/* 1. 높이를 강제로 늘리지 않고 이미지 높이만큼만 잡음 */
	/* height: 420px; */
	/* (선택) 반응형을 위해 비율로 설정하고 싶다면 아래 주석을 풀고 height를 지우세요 */
	aspect-ratio: 1920/420;
	position: relative;
	margin-bottom: 30px; /* 배너가 작아졌으니 아래 여백 조정 */
	z-index: 1;
}

.hero-slide {
	/* 이미지가 컨테이너를 꽉 채우게 설정 */
	background-size: cover;
	background-position: center center; /* 정중앙 배치 */
	background-repeat: no-repeat;
	position: relative;
}

/* [수정] 배너 높이가 낮아졌으므로 내부 텍스트 위치와 크기 조정 */
.hero-content {
	position: absolute;
	top: 40%; /* 정중앙 */
	left: 10%; /* 왼쪽 여백 좀 더 줌 */
	transform: translateY(-50%);
	max-width: 50%;
	z-index: 2;
	opacity: 0;
	animation: fadeInUp 1s ease 0.5s forwards;
}

/* 폰트 크기도 배너 높이에 맞춰서 살짝 줄임 (균형 맞추기) */
.hero-title {
	font-size: 2.5rem; /* 기존 3.5rem -> 2.5rem */
	font-weight: 900;
	margin-bottom: 0.8rem;
	text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.8);
	line-height: 1.2;
}

.hero-desc {
	font-size: 1rem;
	color: #e5e5e5;
	text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.8);
	margin-bottom: 1.5rem;
	display: -webkit-box;
	-webkit-line-clamp: 2; /* 3줄 -> 2줄로 줄임 */
	-webkit-box-orient: vertical;
	overflow: hidden;
}

/* 그라데이션 오버레이는 그대로 유지 (가독성용) */
.hero-overlay {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: linear-gradient(to right, #141414 5%, rgba(20, 20, 20, 0.4)
		50%, rgba(20, 20, 20, 0) 100%);
}

.hero-btns {
	display: flex;
	gap: 1rem;
}

.btn-hero-play {
	background-color: white;
	color: black;
	border: none;
	padding: 0.8rem 2rem;
	font-size: 1.1rem;
	font-weight: bold;
	border-radius: 4px;
	display: flex;
	align-items: center;
	gap: 10px;
	transition: all 0.2s;
}

.btn-hero-play:hover {
	background-color: rgba(255, 255, 255, 0.75);
}

.btn-hero-info {
	background-color: rgba(109, 109, 110, 0.7);
	color: white;
	border: none;
	padding: 0.8rem 2rem;
	font-size: 1.1rem;
	font-weight: bold;
	border-radius: 4px;
	display: flex;
	align-items: center;
	gap: 10px;
	transition: all 0.2s;
}

.btn-hero-info:hover {
	background-color: rgba(109, 109, 110, 0.4);
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}

/* Swiper Pagination 커스텀 */
.swiper-pagination-bullet {
	background: #fff;
	opacity: 0.5;
}

.swiper-pagination-bullet-active {
	background: #E50914; /* 왓플릭스 레드 */
	opacity: 1;
}
</style>

<section class="hero-banner swiper main-banner">
	<div class="swiper-wrapper">

		<div class="swiper-slide hero-slide"
			style="background-image: url('../save/얼음여왕.jpg');" onclick="location='../movie/movieDetail.jsp?movie_idx=178'">
			<div class="hero-overlay"></div>
			<div class="hero-content">
				<h1 class="hero-title">얼음여왕</h1>
				<p class="hero-desc">“사악한 마법을 멈추고 친구를 구하라!” 단짝 친구 ‘카이’와 함께 즐거운
					나날을 보내던 소녀 ‘게르다’. 어느 날, ‘얼음 여왕’이 나타나 카이를 미지의 북극 세계로 데려간다. 카이를 구하기
					위해 북쪽으로 출발한 게르다는 거센 눈보라와 사악한 마법이 도사리는 여행길에서 끊임없이 용기를 시험 받는데… 게르다는
					소중한 친구 카이를 구하고 집으로 돌아갈 수 있을까? 올겨울, 가장 스펙터클한 윈터 어드벤처가 온다!</p>
				<div class="hero-btns">
					<button class="btn-hero-play">
						<i class="bi bi-play-fill" style="font-size: 1.5rem;"></i> 재생
					</button>
					<button class="btn-hero-info" onclick="location='../movie/movieDetail.jsp?movie_idx=178'">
						<i class="bi bi-info-circle"></i> 상세 정보
					</button>
				</div>
			</div>
		</div>

		<div class="swiper-slide hero-slide"
			style="background-image: url('../save/731.jpg');" onclick="location='../movie/movieDetail.jsp?movie_idx=177'">
			<div class="hero-overlay"></div>
			<div class="hero-content">
				<h1 class="hero-title">731</h1>
				<p class="hero-desc">중국 북동부에서 일본 제국군 731부대가 자행한 세균 실험을 배경으로, 평범한
					개인이 겪는 격동의 운명을 통해 감춰진 범죄의 실체를 폭로하는 잔혹 역사 영화</p>
				<div class="hero-btns">
					<button class="btn-hero-play">
						<i class="bi bi-play-fill" style="font-size: 1.5rem;"></i> 재생
					</button>
					<button class="btn-hero-info" onclick="location='../movie/movieDetail.jsp?movie_idx=177'">
						<i class="bi bi-info-circle"></i> 상세 정보
					</button>
				</div>
			</div>
		</div>

		<div class="swiper-slide hero-slide"
			style="background-image: url('../save/송썽블루.png');" onclick="location='../movie/movieDetail.jsp?movie_idx=176'">
			<div class="hero-overlay"></div>
			<div class="hero-content">
				<h1 class="hero-title">송썽블루</h1>
				<p class="hero-desc">꿈과 사랑, 가족의 힘으로 다시 일어선 기적 같은 인생의 앙코르 무대 언제나
					자신만의 무대를 꿈꾸지만 현실은 떠돌이 뮤지션 ‘마이크’(휴 잭맨) 그의 인생에 운명처럼 나타난 싱글맘 ‘클레어’(케이트
					허드슨) 첫눈에 서로의 목소리와 마음을 알아본 두 사람은 사랑과 음악을 함께 꿈꾸며 레전드 가수 닐 다이아몬드의 명곡을
					부르는 커버 밴드 ‘라이트닝 & 썬더’를 결성한다. 타고난 쇼맨십과 폭발적인 가창력으로 단숨에 지역 스타로 떠오른 두
					사람은 당대 최고 인기 밴드 펄잼의 오프닝 무대까지 장식한다. 그러나 가장 찬란한 순간, 예기치 못한 클레어의 사고가
					일어나고 두 사람의 인생과 무대는 한순간에 무너지고 마는데....</p>
				<div class="hero-btns">
					<button class="btn-hero-play" onclick="location='../movie/movieDetail.jsp?movie_idx=176'">
						<i class="bi bi-play-fill" style="font-size: 1.5rem;"></i> 재생
					</button>
					<button class="btn-hero-info">
						<i class="bi bi-info-circle"></i> 상세 정보
					</button>
				</div>
			</div>
		</div>

	</div>
	<div class="swiper-pagination"></div>
</section>
<section class="content-section">
	<div class="section-header">
		<h2 class="section-title">실시간 인기 순위</h2>
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

	$(document).ready(function() {

		// [1] 메인 히어로 배너 슬라이더 설정
		const mainSwiper = new Swiper('.main-banner', {
			slidesPerView : 1, // 화면에 1개만 보임
			effect : 'fade', // 페이드 효과 (부드럽게 겹치며 전환)
			loop : true, // 무한 반복
			speed : 1000, // 전환 속도 (1초)
			autoplay : {
				delay : 5000, // 5초마다 자동 넘김
				disableOnInteraction : false, // 유저가 건드려도 계속 자동재생
			},
			pagination : {
				el : '.swiper-pagination',
				clickable : true,
			},
			allowTouchMove : false, // (선택) 마우스 드래그로 넘기기 방지하고 싶으면 true
		});

		// [2] 기존 영화 리스트 슬라이더 설정 (기존 코드 유지)
		const listSwiper = new Swiper('.movie-swiper', {
			// ... (기존 설정 그대로) ...
			slidesPerView : 'auto',
			spaceBetween : 15,
		// ...
		});
	});
</script>