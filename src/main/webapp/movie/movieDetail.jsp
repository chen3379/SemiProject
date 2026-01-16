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

String dbPosterPath= dto.getPosterPath();
String fullPosterPath="";

// 포스터 처리
if(dbPosterPath==null||dbPosterPath.isEmpty()){
    fullPosterPath="../save/no_image.jpg";
}
else if(dbPosterPath.startsWith("http")){
    fullPosterPath=dbPosterPath;
}
else{
    fullPosterPath="../save/"+dbPosterPath;
}

//한줄평 갯수
int movieIdx=Integer.parseInt(movie_idx);
MovieReviewDao reviewDao=new MovieReviewDao();
int reviewCount=reviewDao.totalReview(movieIdx);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=dto.getTitle()%> - 상세정보</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
.container { max-width: 1200px; margin-top: 50px; margin-bottom: 100px; }
.poster-area img { width: 100%; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
.info-table th { width: 120px; background-color: #f8f9fa; color: #555; font-weight: 600; }
.info-table td { vertical-align: middle; }
.rating-badge { font-size: 1.2rem; color: #ffc107; font-weight: bold; }
.comment-section { background-color: #f8f9fa; padding: 30px; border-radius: 15px; margin-top: 50px; }
</style>
</head>

<body>
	<input type="hidden" id="movieIdx" value="<%= movie_idx %>">

	<div class="container">
		<div class="mb-4 border-bottom pb-3">
			<span class="badge bg-secondary mb-2"><%=dto.getGenre()%></span>
			<h1 class="fw-bold"><%=dto.getTitle()%>
				<small class="text-muted fs-5">(<%=dto.getReleaseDay().substring(0, 4)%>)</small>
			</h1>
		</div>

		<div class="row">
			<div class="col-md-4 mb-4 poster-area">
				<img src="<%=fullPosterPath%>" onerror="this.src='../save/no_image.jpg'" alt="<%=dto.getTitle()%> 포스터">
			</div>

			<div class="col-md-8">
				<div class="d-flex align-items-center mb-3">
					<i class="bi bi-star-fill text-warning fs-3 me-2"></i>
					<span class="fs-3 fw-bold me-2">0.0</span>
					<span class="text-muted">(참여 0명)</span>
				</div>

				<table class="table table-bordered info-table">
					<tr><th>감독</th><td><%=dto.getDirector()%></td></tr>
					<tr><th>출연진</th><td><%=dto.getCast()%></td></tr>
					<tr><th>국가</th><td><%=dto.getCountry()%></td></tr>
					<tr><th>개봉일</th><td><%=dto.getReleaseDay()%></td></tr>
				</table>

				<div class="mt-4">
					<h5 class="fw-bold">줄거리</h5>
					<p class="text-secondary" style="white-space: pre-line; line-height: 1.6;"><%=dto.getSummary().equals("")?"등록된 내용이 없습니다":dto.getSummary()%></p>
				</div>

				<% if (dto.getTrailerUrl() != null && !dto.getTrailerUrl().isEmpty()) { %>
				<div class="mt-4">
					<h5 class="fw-bold mb-3"><i class="bi bi-youtube text-danger"></i> 공식 트레일러</h5>
					
					<div class="ratio ratio-16x9 rounded overflow-hidden shadow-sm">
						<iframe id="youtubePlayer" src="" title="YouTube video player" frameborder="0" allowfullscreen></iframe>
					</div>
					<input type="hidden" id="rawVideoUrl" value="<%=dto.getTrailerUrl()%>">
				</div>
				<% } %>

				<div class="d-flex justify-content-end mt-5 gap-2">
					<button type="button" class="btn btn-secondary px-4" onclick="location.href='movieList.jsp'">목록</button>
					<button type="button" class="btn btn-outline-primary px-4" onclick="location.href='movieUpdateForm.jsp?movie_idx=<%=movie_idx%>'">수정</button>
					<button type="button" class="btn btn-danger px-4" onclick="delMovie('<%=movie_idx%>')">삭제</button>
				</div>
			</div>
		</div>

		<div class="comment-section">
			<h4 class="fw-bold mb-4"><i class="bi bi-chat-dots-fill"></i> 관람객 한줄평</h4>

			<div id="reviewForm" class="mb-3"></div>
			
			<% if(reviewCount==0){%>
			<div class="card p-5 text-center bg-white border-0 shadow-sm" id="reviewBox">
				<h5 class="text-muted">아직 등록된 한줄평이 없습니다.</h5>
				<p class="text-muted small">첫 번째로 별점과 코멘트를 남겨보세요!</p>
				<button class="btn btn-warning text-white fw-bold mt-2"
					id="btnReviewWrite" data-movie-idx="<%=movie_idx%>">한줄평 작성하기</button>
			</div>
			<%} %>
			
			<div class="mt-3" id="reviewList"></div>
		</div>
	</div>

<script type="text/javascript">
	// 삭제
	function delMovie(idx) {
		if (confirm("정말 이 영화 정보를 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.")) {
			location.href = "movieDeleteAction.jsp?movie_idx=" + idx;
		}
	}

	// 유튜브 URL -> Embed
	$(document).ready(function() {
		var rawUrl = $("#rawVideoUrl").val();
		if (rawUrl) {
			var videoId = getYoutubeId(rawUrl);
			if (videoId) {
				$("#youtubePlayer").attr("src", "https://www.youtube.com/embed/" + videoId);
			} else {
				$("#youtubePlayer").parent().hide();
			}
		}

		function getYoutubeId(url) {
			var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
			var match = url.match(regExp);
			return (match && match[2].length === 11) ? match[2] : null;
		}
	});

	// 목록은 무조건 뜨게: 성공/실패/빈목록 모두 화면에 표시
	function loadReviewListAlways() {
		var movieIdx = $("#movieIdx").val();

		$("#reviewList").load("movieReviewList.jsp?movie_idx=" + movieIdx, function (response, status, xhr) {
			if (status === "error") {
				console.log("리스트 로드 실패:", xhr.status, xhr.responseText);
				$("#reviewList").html("<div class='text-muted'>리뷰 목록을 불러오지 못했습니다.</div>");
				return;
			}

			if ($.trim(response) === "") {
				$("#reviewList").html("<div class='text-muted'>아직 등록된 한줄평이 없습니다.</div>");
			}
		});
	}

	// 페이지 진입 시 무조건 목록 로드
	$(function(){
		loadReviewListAlways();
	});

	// 한줄평 작성하기 클릭 -> 폼 로드(박스 숨김)
	$(document).on("click", "#btnReviewWrite", function () {
		var movieIdx = $("#movieIdx").val();

		$.ajax({
			type: "get",
			url: "movieReviewForm.jsp",
			data: { movie_idx: movieIdx },
			success: function (html) {
				$("#reviewForm").html(html);
				$("#reviewBox").hide();
			},
			error: function () {
				alert("폼을 불러오지 못했습니다.");
			}
		});
	});

	// 취소 -> 폼 비우고 박스 다시 보여줌
	$(document).on("click", "#btnReviewCancel", function () {
		$("#reviewForm").empty();
		$("#reviewBox").show();
	});

	
	// 한줄평 삭제
	function deleteReview(reviewIdx) {
		
		var movieIdx = $("#movieIdx").val();
		
		if (!confirm("정말 삭제할까요?")) return;

		$.ajax({
			type: "post",
			url: "movieReviewDeleteAction.jsp",
			data: { movie_idx: movieIdx, review_idx: reviewIdx },
			dataType: "json",
			success: function(res) {
				console.log("delete 응답 =", res);
				if (res.status === "OK") {
					loadReviewListAlways();
					alert("삭제 완료");
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

	// 한줄평 수정
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
					loadReviewListAlways();
					alert("수정 완료");
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
</script>
</body>
</html>
