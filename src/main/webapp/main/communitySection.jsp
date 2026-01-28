<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="board.free.FreeBoardDao"%>
<%@ page import="board.free.FreeBoardDto"%>
<%@ page import="board.review.ReviewBoardDao"%>
<%@ page import="board.review.ReviewBoardDto"%>

<%
FreeBoardDao freeDao = new FreeBoardDao();
ReviewBoardDao reviewDao = new ReviewBoardDao();

List<FreeBoardDto> freeTop10 = freeDao.getTop10ByReadcount();
List<ReviewBoardDto> reviewTop10 = reviewDao.getTop10ByReadcount();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/community.css">
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style type="text/css">
:root {
  --primary-red: #E50914;
  --primary-red-hover: #B20710;
  --bg-main: #141414;
  --bg-surface: #181818;
  --text-white: #FFFFFF;
  --text-gray: #BCBCBC;
  --text-muted: #aaaaaa;
  --border-glass: rgba(255, 255, 255, 0.08);
}

/* 공지사항 스타일 */
.notice-area {
	margin-top: 50px;
}

.notice-list {
	border-top: 2px solid #333;
}

.notice-item {
	border-bottom: 1px solid #222;
}

/* 클릭하는 헤더 부분 */
.notice-header {
	background-color: #141414; /* 배경색 */
	padding: 20px 15px;
	cursor: pointer;
	display: flex;
	align-items: center;
	transition: background-color 0.2s;
	color: #e5e5e5;
}

.notice-header:hover {
	background-color: #1f1f1f; /* 호버 시 약간 밝게 */
}

.notice-title-text {
	flex-grow: 1; /* 제목이 공간 차지 */
	font-size: 1rem;
	font-weight: 500;
}

/* 화살표 아이콘 */
.toggle-icon {
	color: #888;
	transition: transform 0.3s ease;
}

/* 활성화(열림) 상태일 때 화살표 회전 */
.notice-header.active .toggle-icon {
	transform: rotate(180deg);
	color: #E50914; /* 넷플릭스 레드 포인트 */
}

/* 숨겨진 내용 부분 */
.notice-body {
	display: none; /* 기본 숨김 */
	background-color: #1f1f1f; /* 헤더보다 약간 밝은 배경 */
	padding: 25px 20px;
	color: #cccccc;
	font-size: 0.95rem;
	line-height: 1.6;
	border-top: 1px solid #333;
}

.notice-body strong {
	color: white;
}
</style>
</head>

<body>
	<jsp:include page="../main/nav.jsp" />
	<jsp:include page="../login/loginModal.jsp" />
	<jsp:include page="../profile/profileModal.jsp" />

	<div class="container community-main" style="padding-top: 40px;">

		<!-- ===== 게시판 바로가기 ===== -->
		<div class="row g-4 mb-5">
			<div class="col-md-6">
				<a href="<%=request.getContextPath()%>/board/free/list.jsp"
					style="text-decoration: none">
					<div class="rank-card">
						<h4>💬 자유게시판</h4>
						<p style="font-size: 14px; color: #bbb;">일상 · 잡담 · 질문을 자유롭게</p>
					</div>
				</a>
			</div>

			<div class="col-md-6">
				<a href="<%=request.getContextPath()%>/board/review/list.jsp"
					style="text-decoration: none">
					<div class="rank-card">
						<h4>🎬 영화 리뷰</h4>
						<p style="font-size: 14px; color: #bbb;">영화 감상 후기와 추천</p>
					</div>
				</a>
			</div>
		</div>

		<!-- ===== 커뮤니티 인기 글 ===== -->
		<h2 class="section-title">🔥 커뮤니티 인기 글</h2>

		<div class="row g-4">
			<!-- 자유게시판 TOP10 -->
			<div class="col-md-6">
				<div class="rank-card">
					<h4>💬 자유게시판 TOP 10</h4>
					<ul class="rank-list">
						<%
						int rank = 1;
						for (FreeBoardDto dto : freeTop10) {
						%>
						<li><span class="rank"><%=rank++%></span> <a
							href="<%=request.getContextPath()%>/board/free/detail.jsp?board_idx=<%=dto.getBoard_idx()%>">
								<%=dto.getTitle()%>
						</a> <span class="count"><%=dto.getReadcount()%></span></li>
						<%
						}
						%>
					</ul>
				</div>
			</div>

			<!-- 영화리뷰 TOP10 -->
			<div class="col-md-6">
				<div class="rank-card">
					<h4>🎬 영화리뷰 TOP 10</h4>
					<ul class="rank-list">
						<%
						rank = 1;
						for (ReviewBoardDto dto : reviewTop10) {
						%>
						<li><span class="rank"><%=rank++%></span> <a
							href="<%=request.getContextPath()%>/board/review/detail.jsp?board_idx=<%=dto.getBoard_idx()%>">
								<%=dto.getTitle()%>
						</a> <span class="count"><%=dto.getReadcount()%></span></li>
						<%
						}
						%>
					</ul>
				</div>
			</div>
		</div>

		<!-- ===== 공지사항 ===== -->
		<div class="notice-area mt-5 mb-5">
			<h4 class="mb-3 fw-bold">
				<i class="bi bi-megaphone-fill text-danger"></i> WHATFLIX 공지사항
			</h4>

			<div class="notice-list">
				<div class="notice-item">
					<div class="notice-header">
						<span class="badge bg-danger me-2">필독</span> <span
							class="notice-title-text">[공지] 왓플릭스 커뮤니티 이용 규칙 안내</span> <i
							class="bi bi-chevron-down toggle-icon"></i>
					</div>
					<div class="notice-body">
						<p>안녕하세요, 왓플릭스입니다.</p>
						<p>건전하고 즐거운 영화 커뮤니티를 위해 아래 수칙을 준수해 주시기 바랍니다.</p>
						<br> <strong>1. 상호 존중</strong><br> - 타인의 취향을 비난하거나,
						인신공격, 욕설, 혐오 표현은 절대 금지됩니다.<br> - 영화에 대한 비판은 가능하지만, 유저에 대한 비난은
						삼가주세요.<br> <br> <strong>2. 도배 및 홍보 금지</strong><br>
						- 의미 없는 반복 게시글이나 상업적 홍보 링크는 예고 없이 삭제될 수 있습니다.<br> <br> <strong>3.
							저작권 준수</strong><br> - 불법 다운로드 링크 공유나 자막 파일 업로드는 금지됩니다.<br> <br>
						<span style="color: #bbb; font-size: 0.9rem;">※ 위 규칙을 위반할
							경우 게시물 삭제 및 계정 이용이 제한될 수 있습니다.</span>
					</div>
				</div>

				<div class="notice-item">
					<div class="notice-header">
						<span class="badge bg-secondary me-2">안내</span> <span
							class="notice-title-text">[공지] 매너있는 관람을 위한 스포일러 작성 가이드</span> <i
							class="bi bi-chevron-down toggle-icon"></i>
					</div>
					<div class="notice-body">
						<p>아직 영화를 보지 않은 회원님들의 감동을 지켜주세요! 🤫</p>
						<br> <strong>1. 제목에 스포일러 포함 금지</strong><br> - 제목에 결말이나
						핵심 반전을 직접적으로 언급하지 말아주세요.<br> - 예) "주인공 죽을 때 너무 슬펐음" (X) ->
						"엔딩 장면 감상평 (스포주의)" (O)<br> <br> <strong>2. 말머리
							활용</strong><br> - 게시글 작성 시 제목 앞부분에 <strong>[스포일러]</strong>를
						표시해 주세요.<br> <br> <strong>3. 스포일러 방지 기능 사용</strong><br>
						- 핵심 내용은 글의 앞부분보다는 엔터키를 활용해 하단에 작성하는 센스를 발휘해 주세요.<br>
					</div>
				</div>

				<div class="notice-item">
					<div class="notice-header">
						<span class="badge bg-primary me-2">업데이트</span> <span
							class="notice-title-text">[안내] 2026년 상반기 서버 점검 및 기능 추가 예정</span>
						<i class="bi bi-chevron-down toggle-icon"></i>
					</div>
					<div class="notice-body">
						<p>더 나은 서비스 제공을 위해 서버 점검이 진행될 예정입니다.</p>
						<p>- 일시: 2026년 2월 1일 (일) 02:00 ~ 06:00 (4시간)</p>
						<p>- 내용: DB 서버 증설 및 '나만의 영화 캘린더' 기능 업데이트</p>
						<br>
						<p>점검 시간 동안은 서비스 이용이 제한되오니 양해 부탁드립니다.</p>
					</div>
				</div>

			</div>
		</div>

	</div>
	<script>
		$(document).ready(function() {
			// 공지사항 토글 기능
			$(".notice-header").click(function() {
				// 1. 클릭한 헤더의 바로 다음 요소(.notice-body)를 슬라이드 토글
				$(this).next(".notice-body").stop().slideToggle(300);

				// 2. 화살표 회전을 위해 active 클래스 토글
				$(this).toggleClass("active");

				// (선택사항) 다른 공지사항은 자동으로 닫고 싶다면 아래 주석 해제
				/*
				$(".notice-header").not(this).removeClass("active");
				$(".notice-header").not(this).next(".notice-body").slideUp(300);
				 */
			});
		});
	</script>
</body>
<%-- <footer>
	<jsp:include page="/main/footer.jsp"/>
</footer> --%>
</html>
