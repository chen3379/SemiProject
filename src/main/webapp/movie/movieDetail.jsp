<%@page import="movie.MovieWishDao"%>
<%@page import="member.MemberDao"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="movie.MovieRatingStatDao"%>
<%@page import="movie.MovieRatingDao"%>
<%@page import="movie.MovieReviewDto"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieReviewDao"%>
<%@page import="movie.MovieDto"%>
<%@page import="movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
// 1. 넘어온 영화 고유번호 받기
String movie_idx = request.getParameter("movie_idx");

// 유효성 검사
if (movie_idx == null) {
	response.sendRedirect("movieList.jsp");
	return;
}

MovieDao dao = new MovieDao();

// 2. 조회수 1 증가
dao.updateReadCount(movie_idx);

// 3. 영화 정보 가져오기
MovieDto dto = dao.getMovie(movie_idx);

String dbPosterPath = dto.getPosterPath();
String fullPosterPath = "";

// 포스터 처리
if (dbPosterPath == null || dbPosterPath.isEmpty()) {
	fullPosterPath = "../save/no_image.jpg";
} else if (dbPosterPath.startsWith("http")) {
	fullPosterPath = dbPosterPath;
} else {
	fullPosterPath = "../save/" + dbPosterPath;
}

// 한줄평 갯수 체크
int movieIdx = Integer.parseInt(movie_idx);
MovieReviewDao reviewDao = new MovieReviewDao();
int reviewCount = reviewDao.totalReview(movieIdx);

// 리뷰 목록 가져오기
List<MovieReviewDto> rlist = reviewDao.getAllReviewsWithScore(movieIdx);

//평균별점
MovieRatingStatDao statDao = new MovieRatingStatDao();
BigDecimal avgScore = statDao.getAvgScore(movieIdx);
int ratingCount = statDao.getRatingCount(movieIdx);

//로그인 정보 조회
String id = (String)session.getAttribute("id");
boolean isLogin = (id != null);

//위시
MovieWishDao wishDao = new MovieWishDao();
boolean isWished = false;

if (isLogin) {
    isWished = wishDao.isWished(movieIdx, id);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=dto.getTitle()%> - 상세정보</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
/* [1] 전역 테마 및 배경 설정 */
:root {
	--primary-red: #E50914;
	--bg-main: #141414;
	--bg-card: #1f1f1f;
	--text-white: #FFFFFF;
	--text-gray: #B3B3B3;
	--glass-border: rgba(255, 255, 255, 0.1);
}

body {
	background-color: var(--bg-main) !important;
	color: var(--text-white) !important;
	font-family: 'Pretendard', sans-serif;
}

.container {
	max-width: 1200px;
	margin-top: 100px;
	margin-bottom: 100px;
}

/* [2] 포스터 및 상단 제목 */
.poster-area img {
	width: 100%;
	border-radius: 12px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
	border: 1px solid var(--glass-border);
}

.badge.bg-secondary {
	background-color: var(--primary-red) !important;
	font-size: 0.8rem;
	padding: 5px 10px;
}

h1.fw-bold {
	font-size: 2.5rem;
	color: var(--text-white) !important;
}

h1.fw-bold small {
	color: var(--text-gray) !important;
}

/* [3] 사진에서 문제가 된 정보 테이블 (완벽 수정) */
.info-table {
	border: none !important;
	margin-top: 20px;
}

.info-table th {
	background-color: rgba(255, 255, 255, 0.05) !important;
	color: var(--text-gray) !important;
	border: 1px solid var(--glass-border) !important;
	width: 130px;
	font-weight: 500;
}

.info-table td {
	background-color: transparent !important;
	color: var(--text-white) !important;
	border: 1px solid var(--glass-border) !important;
}

/* [4] 줄거리 텍스트 가시성 */
.text-secondary {
	color: var(--text-gray) !important;
	line-height: 1.8 !important;
}

/* [5] 사진에서 하얗게 뜨는 한줄평 영역 수정 */
.comment-section {
	background-color: var(--bg-card) !important;
	padding: 40px !important;
	border-radius: 20px !important;
	margin-top: 60px;
	border: 1px solid var(--glass-border) !important;
}

/* 리뷰 작성/안내 박스 하얀색 제거 */
#reviewBox, #reviewSecondBox, .list-group-item {
	background-color: rgba(255, 255, 255, 0.03) !important;
	border: 1px solid var(--glass-border) !important;
	color: var(--text-white) !important;
}

/* 별점 UI */
.star-wrap {
	font-size: 36px;
	cursor: pointer;
	display: inline-block;
	position: relative;
}

.star-bg {
	color: #444;
}

.star-fill {
	position: absolute;
	left: 0;
	top: 0;
	width: 0%;
	overflow: hidden;
	color: #ffc107;
	pointer-events: none;
}

/* 버튼 스타일 */
.btn-warning {
	background-color: var(--primary-red) !important;
	border: none !important;
	color: white !important;
}

.btn-secondary {
	background-color: #333 !important;
	border: none !important;
}

/* 위시 버튼 */
#wishBtn {
	border: 1px solid var(--glass-border);
	border-radius: 20px;
	padding: 5px 15px;
}

#wishIcon.active {
	color: var(--primary-red) !important;
}
/* [1] 별점 참여수 및 위시 텍스트 가독성 개선 */
.text-muted {
	color: #e5e5e5 !important; /* 안 보이던 회색을 밝은 연회색으로 변경 */
	font-size: 0.9rem;
	font-weight: 500;
}

#wishText {
	color: #e5e5e5 !important;
	font-weight: 600;
	margin-left: 5px;
	transition: color 0.3s;
}

/* [2] 위시 버튼 커스텀 (고급스러운 유리 질감) */
#wishBtn {
	background: rgba(255, 255, 255, 0.1) !important;
	border: 1px solid rgba(255, 255, 255, 0.2) !important;
	padding: 8px 18px !important;
	border-radius: 30px !important;
	backdrop-filter: blur(5px);
	transition: all 0.3s ease;
}

#wishBtn:hover {
	background: rgba(255, 255, 255, 0.2) !important;
	border-color: var(--primary-red) !important;
	transform: translateY(-2px);
}

#wishIcon.active {
	color: var(--primary-red) !important;
	filter: drop-shadow(0 0 5px var(--primary-red));
}

/* [3] 시네마틱 액션 버튼 (부트스트랩 기본 디자인 탈피) */
.btn-secondary, .btn-primary, .btn-danger {
	border-radius: 4px !important;
	font-weight: 700 !important;
	padding: 10px 24px !important;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94) !important;
	border: none !important;
}

.btn-outline-primary {
	border-radius: 4px !important;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94) !important;
	border: none !important;
}

.btn-outline-danger {
	border-radius: 4px !important;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94) !important;
}

/* 목록 버튼: 다크 그레이 */
.btn-secondary {
	background-color: #333 !important;
	color: white !important;
}

.btn-secondary:hover {
	background-color: #444 !important;
}

/* 수정 버튼: 화이트 (넷플릭스 스타일) */
.btn-primary {
	background-color: #fff !important;
	color: #000 !important;
}

.btn-outline-primary {
	background-color: #fff !important;
	color: #000 !important;
}

.btn-primary:hover {
	background-color: rgba(255, 255, 255, 0.8) !important;
}

.btn-outline-primary:hover {
	background-color: rgba(255, 255, 255, 0.8) !important;
}

/* 삭제 버튼: 넷플릭스 레드 */
.btn-danger {
	background-color: var(--primary-red) !important;
}

.btn-danger:hover {
	background-color: #c40812 !important;
}

/* [4] 버튼 그룹 간격 조정 */
.d-flex.gap-2 {
	gap: 12px !important;
}

.adminDiv {
	transition: opacity 0.3s ease;
}
</style>
</head>

<body>

	<input type="hidden" id="movieIdx" value="<%=movie_idx%>">
	<jsp:include page="../main/nav.jsp" />

	<div class="container">
		<div class="mb-4 border-bottom pb-3">
			<span class="badge bg-secondary mb-2"><%=dto.getGenre()%></span>
			<h1 class="fw-bold"><%=dto.getTitle()%>
				<small class="text-muted fs-5">(<%=dto.getReleaseDay().substring(0, 4)%>)
				</small>
			</h1>
		</div>

		<div class="row">
			<div class="col-md-4 mb-4 poster-area">
				<img src="<%=fullPosterPath%>"
					onerror="this.src='../save/no_image.jpg'"
					alt="<%=dto.getTitle()%> 포스터">
			</div>

			<div class="col-md-8">
				<div class="d-flex align-items-center mb-3">
					<i class="bi bi-star-fill text-warning fs-3 me-2"></i> <span
						class="fs-3 fw-bold me-2"> <%=(ratingCount == 0 ? "0.0" : String.format("%.1f", avgScore))%>
					</span> <span class="text-muted">(참여 <%=reviewCount%>명)
					</span> &nbsp;&nbsp;&nbsp;
					<button type="button" id="wishBtn"
						class="btn p-0 border-0 bg-transparent d-flex align-items-center gap-1"
						data-wished="<%=isWished%>">
						<span id="wishText" class="<%=isWished ? "text-danger fw-semibold" : "text-muted"%>">위시</span> 
						<i id="wishIcon" class="bi <%=isWished ? "bi-heart-fill" : "bi-heart"%> text-danger fs-4"></i>
					</button>
				</div>

				<table class="table table-bordered info-table">
					<tr>
						<th>감독</th>
						<td><%=dto.getDirector()%></td>
					</tr>
					<tr>
						<th>출연진</th>
						<td><%=dto.getCast()%></td>
					</tr>
					<tr>
						<th>국가</th>
						<td><%=dto.getCountry()%></td>
					</tr>
					<tr>
						<th>개봉일</th>
						<td><%=dto.getReleaseDay()%></td>
					</tr>
				</table>

				<div class="mt-4">
					<h5 class="fw-bold">줄거리</h5>
					<p class="text-secondary"
						style="white-space: pre-line; line-height: 1.6;"><%=dto.getSummary().equals("") ? "등록된 내용이 없습니다" : dto.getSummary()%></p>
				</div>

				<%
				if (dto.getTrailerUrl() != null && !dto.getTrailerUrl().isEmpty()) {
				%>
				<div class="mt-4">
					<h5 class="fw-bold mb-3">
						<i class="bi bi-youtube text-danger"></i> 공식 트레일러
					</h5>

					<div class="ratio ratio-16x9 rounded overflow-hidden shadow-sm">
						<iframe id="youtubePlayer" src="" title="YouTube video player"
							frameborder="0" allowfullscreen></iframe>
					</div>
					<input type="hidden" id="rawVideoUrl"
						value="<%=dto.getTrailerUrl()%>">
				</div>
				<%
				}
				%>

				<div class="d-flex justify-content-end mt-5 gap-2">
					<div class="d-flex gap-2 adminDiv" style="visibility: hidden;">
						<button type="button" class="btn btn-primary px-4"
							onclick="location.href='movieUpdateForm.jsp?movie_idx=<%=movie_idx%>'">수정</button>
						<button type="button" class="btn btn-danger px-4"
							onclick="delMovie('<%=movie_idx%>')">삭제</button>
					</div>
				</div>
			</div>
		</div>

		<!-- =================== 한줄평 영역 =================== -->
		<div class="comment-section">
			<h4 class="fw-bold mb-4">
				<i class="bi bi-chat-dots-fill"></i> 관람객 한줄평
			</h4>

			<%-- 0개면: reviewBox만 보이게 --%>
			<%
			if (reviewCount == 0) {
			%>
			<div class="card p-5 text-center bg-white border-0 shadow-sm"
				id="reviewBox">
				<h5 class="text-muted">아직 등록된 한줄평이 없습니다.</h5>
				<p class="text-muted small">첫 번째로 별점과 코멘트를 남겨보세요!</p>
				<button class="btn btn-warning text-white fw-bold mt-2"
					id="btnReviewWrite">한줄평 작성하기</button>
			</div>
			<%
			}
			%>

			<%-- 폼은 항상 존재시키되, 0개면 숨김 / 1개 이상이면 보임 --%>
			<div
				class="text-start bg-white p-3 rounded shadow-sm mb-3 <%=(reviewCount == 0 ? "d-none" : "")%>"
				id="reviewSecondBox">

				<input type="hidden" id="movieIdxHidden" value="<%=movie_idx%>">

				<h5 class="fw-bold mb-3">
					<i class="bi bi-pencil-square"></i> 한줄평 작성
				</h5>

				<!-- 별점 UI -->
				<div class="mb-3">
					<label class="form-label fw-semibold d-block">별점</label>

					<div class="d-flex align-items-center">
						<div id="starWrap" class="star-wrap">
							<div class="star-bg">★★★★★</div>
							<div id="starFill" class="star-fill">★★★★★</div>
						</div>
						<span class="info">내 별점: <span id="myScoreText">0.0</span></span>
					</div>

					<input type="hidden" id="reviewScore" value="0.0">
					<div class="form-text">별 위에서 움직이고 클릭하면 0.5 단위로 선택됩니다.</div>
				</div>

				<!-- 한줄평 입력 -->
				<div class="mb-3">
					<label class="form-label fw-semibold">한줄평</label>
					<textarea class="form-control" id="reviewContent" rows="3"
						maxlength="100" placeholder="한줄평을 작성해 주세요 (최대 100자)"></textarea>

					<div class="d-flex justify-content-end">
						<small class="text-muted"><span id="reviewLen">0</span>/100</small>
					</div>
				</div>

				<div class="d-flex justify-content-end">
					<button type="button" class="btn btn-outline-danger text-white fw-bold"
						id="btnReviewSubmit">등록</button>
				</div>
			</div>

			<%-- 목록도 1개 이상일 때만 보이게 --%>
			<div class="mt-3 <%=(reviewCount == 0 ? "d-none" : "")%>"
				id="reviewList">
				<%
				if (rlist != null && !rlist.isEmpty()) {
				%>
				<div class="list-group">
					<%
					for (MovieReviewDto r : rlist) {
					%>
					<div class="list-group-item">
						<div class="d-flex justify-content-between align-items-center">
							<div>
								<b><%=r.getId()%></b>

								<%
								double score = (r.getScore() == null) ? 0.0 : r.getScore().doubleValue();
								int full = (int) Math.floor(score);
								boolean half = (score - full) >= 0.5;
								int empty = 5 - full - (half ? 1 : 0);
								%>

								<span class="ms-1 align-middle" style="font-size: 14px;">
									<%
									for (int i = 0; i < full; i++) {
									%><i class="bi bi-star-fill text-warning"></i> <%
 }
 %> <%
 if (half) {
 %><i class="bi bi-star-half text-warning"></i> <%
 }
 %> <%
 for (int i = 0; i < empty; i++) {
 %><i class="bi bi-star text-warning"></i> <%
 }
 %>
								</span> <span class="ms-2 text-warning fw-semibold"><%=String.format("%.1f", score)%></span>
							</div>

							<div class="d-flex align-items-center gap-2">
								<span class="text-muted small"><%=r.getCreateDay()%></span>

								<%
								if (isLogin && id.equals(r.getId())) {
								%>
								<button type="button" class="btn btn-sm btn-outline-primary"
									onclick="updateReview(<%=r.getReviewIdx()%>, '<%=r.getContent().replace("'", "\\'")%>')">수정</button>
								<button type="button" class="btn btn-outline-danger btn-sm"
									onclick="deleteReview(<%=r.getReviewIdx()%>)">삭제</button>
								<%
								}
								%>
							</div>
						</div>

						<div class="mt-2"><%=r.getContent()%></div>
					</div>
					<%
					}
					%>
				</div>
				<%
				}
				%>
			</div>

		</div>
	</div>
	<jsp:include page="chatWidget.jsp" />
	
	<script type="text/javascript">
	// 영화 삭제
	function delMovie(idx) {
		if (confirm("정말 이 영화 정보를 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.")) {
			location.href = "movieDeleteAction.jsp?movie_idx=" + idx;
		}
	}

	// 유튜브 URL -> Embed
	$(document).ready(function() {
		var rawUrl = $("#rawVideoUrl").val();
		if (!rawUrl) return;

		var videoId = getYoutubeId(rawUrl);
		if (videoId) $("#youtubePlayer").attr("src", "https://www.youtube.com/embed/" + videoId);
		else $("#youtubePlayer").parent().hide();

		function getYoutubeId(url) {
			var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
			var match = url.match(regExp);
			return (match && match[2].length === 11) ? match[2] : null;
		}
	});

	
	 /* ===== (reviewCount==0일 때) 작성하기 버튼 ===== */
	 
	 //임시 주석
	 var isLogin = <%=isLogin ? "true" : "false"%>;
	 
	  $(document).on("click", "#btnReviewWrite", function(){
		
		//임시 주석
		//비회원일때는 로그인창으로 넘어가기
		if(!isLogin){
		    alert("로그인이 필요합니다.");
		    location.href = "../login/loginModal.jsp";
		    return;
		}
		
	    $("#reviewBox").hide();                 // 안내박스 숨김
	    $("#reviewSecondBox").removeClass("d-none"); // 폼 보이기
	  });


	  /* ===== 별점 UI (폼이 있을 때만) ===== */
	  (function initStarUI(){
	    if(!$("#reviewSecondBox").length) return; // 폼 자체가 없으면 종료

	    var currentRating = 0.0;
	    var hoverRating = 0.0;

	    function updateRatingUI(){
	      var percent = (currentRating / 5.0) * 100;
	      $("#starFill").css("width", percent + "%");
	      $("#myScoreText").text(currentRating.toFixed(1));
	      $("#reviewScore").val(currentRating.toFixed(1));
	    }

	    updateRatingUI();

	    $("#starWrap").on("mousemove", function(e){
	      var offset = $(this).offset();
	      var x = e.pageX - offset.left;
	      var w = $(this).width();

	      var raw = (x / w) * 5.0;
	      raw = Math.round(raw * 2) / 2;

	      if (raw < 0.5) raw = 0.5;
	      if (raw > 5.0) raw = 5.0;

	      hoverRating = raw;

	      var percent = (hoverRating / 5.0) * 100;
	      $("#starFill").css("width", percent + "%");
	      $("#myScoreText").text(hoverRating.toFixed(1));
	    });

	    $("#starWrap").on("mouseleave", function(){
	      updateRatingUI();
	    });

	    $("#starWrap").on("click", function(){
	      if (hoverRating < 0.5) hoverRating = 0.5;
	      currentRating = hoverRating;
	      updateRatingUI();
	    });

	    $("#reviewContent").on("input", function(){
	      $("#reviewLen").text($(this).val().length);
	    });
	  })();


	  /* ===== 등록 버튼 (한줄평 + 별점) ===== */
	  $(document).off("click", "#btnReviewSubmit").on("click", "#btnReviewSubmit", function () {
		  
	  	if(!isLogin){
		  alert("로그인이 필요합니다.");
		  location.href = "../login/loginModal.jsp";
		  return;
	  	}
		
	    var movieIdx = $("#movieIdxHidden").val();
	    var score = $("#reviewScore").val();
	    var content = $("#reviewContent").val();

	    if (score === "0.0") { alert("별점을 선택해 주세요."); return; }
	    if (!content || $.trim(content).length === 0) {
	      alert("코멘트를 입력해 주세요.");
	      $("#reviewContent").focus();
	      return;
	    }

	    // 1) 한줄평 저장
	    $.ajax({
	      type: "post",
	      url: "movieReviewInsertAction.jsp",
	      data: { movie_idx: movieIdx, content: content },
	      dataType: "json",
	      success: function (r1) {
	        if (r1.status !== "OK") {
	          alert(r1.message || "한줄평 등록 실패");
	          return;
	        }

	        // 2) 별점 저장
	        $.ajax({
	          type: "post",
	          url: "movieRatingInsertAction.jsp",
	          data: { movie_idx: movieIdx, score: score },
	          dataType: "json",
	          success: function (r2) {
	            if (r2.status !== "OK") {
	              alert(r2.message || "별점 저장 실패");
	              return;
	            }
	            // ✅ 첫 등록 이후/등록 후 상태 동기화
	            location.reload();
	          },
	          error: function (xhr) {
	            console.log(xhr.status, xhr.responseText);
	            alert("별점 저장 서버 오류");
	          }
	        });
	      },
	      error: function (xhr) {
	        console.log(xhr.status, xhr.responseText);
	        alert("한줄평 저장 서버 오류");
	      }
	    });
	  });

	
	/* ===== 리뷰 삭제 ===== */
	function deleteReview(reviewIdx) {
	  var movieIdx = $("#movieIdx").val();
	  if (!confirm("정말 삭제할까요?")) return;

	  $.ajax({
	    type: "post",
	    url: "movieReviewDeleteAction.jsp",
	    data: { movie_idx: movieIdx, review_idx: reviewIdx },
	    dataType: "json",
	    success: function(res) {
	      if (res.status === "OK") {
	        alert("삭제 완료");
	        // ✅ 마지막 리뷰 삭제면 reviewCount==0이 되어 reviewBox만 뜸
	        location.reload();
	      } else {
	        alert(res.message || "삭제 실패");
	      }
	    },
	    error: function(xhr) {
	      console.log(xhr.status, xhr.responseText);
	      alert("서버 오류(삭제)");
	    }
	  });
	}


	/* ===== 리뷰 수정 ===== */
	function updateReview(reviewIdx, oldContent) {
	  var newContent = prompt("한줄평 수정", oldContent);
	  if (newContent == null) return;

	  newContent = $.trim(newContent);
	  if (newContent.length === 0) {
	    alert("내용을 입력해 주세요.");
	    return;
	  }

	  $.ajax({
	    type: "post",
	    url: "movieReviewUpdateAction.jsp",
	    data: { review_idx: reviewIdx, content: newContent },
	    dataType: "json",
	    success: function(res) {
	      if (res.status === "OK") {
	        alert("수정 완료");
	        location.reload();
	      } else {
	        alert(res.message || "수정 실패");
	      }
	    },
	    error: function(xhr) {
	      console.log(xhr.status, xhr.responseText);
	      alert("서버 오류(수정)");
	    }
	  });
	}
	
	/* ===== 위시 추가/삭제 ===== */
	$("#wishBtn").on("click", function(e){	
	e.preventDefault();
	e.stopPropagation();

	if(!isLogin){
	    alert("로그인이 필요합니다.");
	    location.href = "../login/loginModal.jsp";
	    return;
	}

	var movieIdx = $("#movieIdx").val();
    var wished = $(this).data("wished");
    var url = wished ? "movieWishDeleteAction.jsp" : "movieWishInsertAction.jsp";

    $.ajax({
        type: "post",
        url: url,
        data: { movie_idx: movieIdx },
        dataType: "json",
        success: function(res){
          if(res.status === "OK"){

            // 성공했을 때만 UI 변경
            if(!wished){
              $("#wishIcon").removeClass("bi-heart").addClass("bi-heart-fill active");
              $("#wishText").removeClass("text-muted").addClass("text-danger fw-semibold").text("위시 추가");
              $("#wishBtn").data("wished", true);
            }else{
              $("#wishIcon").removeClass("bi-heart-fill active").addClass("bi-heart");
              $("#wishText").removeClass("text-danger fw-semibold").addClass("text-muted").text("위시 삭제");
              $("#wishBtn").data("wished", false);
            }

          }else{
            alert(res.message || "처리 실패");
          }
        },
        error: function(xhr){
          console.log(xhr.status, xhr.responseText);
          alert("서버 오류");
        }
      });
    
    
	});
	 <%MemberDao memberDao = new MemberDao();

if (id != null) {

	String roleType = memberDao.getRoleType(id);
	//roleType.equals("")로 사용하게 되면 roleType이 null일 때 null.equals가 되어
	//nullpointerexception 에러가 발생 가능하기 때문에 확실한 값(상수)를 왼쪽에 두는 것이 좋다 - Null Safety(에러 방어)
	if ("3".equals(roleType) || "9".equals(roleType)) {%>
	        $(".adminDiv").css("visibility","visible");              
	    <%}
}%> 
	
	
</script>
</body>
</html>