<%@page import="movie.MovieDao"%>
<%@page import="movie.MovieDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    // 1. 수정할 영화 데이터 가져오기
    String movieIdx = request.getParameter("movie_idx");
    MovieDao dao = new MovieDao();
    MovieDto dto = dao.getMovie(movieIdx);

    // ★★★ [수정 핵심] 포스터 경로 판별 로직 추가 ★★★
    String dbPosterPath = dto.getPosterPath(); // DB 원본 값
    String fullPosterPath = "";                // 화면 출력용 전체 경로
    
    // null 처리 및 경로 판별
    if(dbPosterPath == null || dbPosterPath.isEmpty()) {
        dbPosterPath = "no_image.jpg";
        fullPosterPath = "../save/no_image.jpg";
    } else if(dbPosterPath.startsWith("http")) {
        // API 데이터인 경우 (http로 시작) -> 경로 그대로 사용
        fullPosterPath = dbPosterPath;
    } else {
        // 직접 업로드한 경우 -> save 폴더 경로 붙임
        fullPosterPath = "../save/" + dbPosterPath;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
/* 전체 컨테이너 여백 조정 */
.container-fluid {
	max-width: 1400px;
	margin-top: 30px;
	margin-bottom: 50px;
}

/* 왼쪽 미리보기 영역 스타일 */
.preview-container {
	position: sticky;
	top: 30px; /* 스크롤 내려도 따라오게 */
	border: 1px solid #ddd;
	padding: 10px;
	border-radius: 8px;
	background-color: #f9f9f9;
	text-align: center;
	min-height: 600px; /* 최소 높이 확보 */
	display: flex;
	align-items: center;
	justify-content: center;
}

/* 미리보기 이미지 스타일 */
#posterPreview {
	max-width: 100%;
	max-height: 700px;
	object-fit: contain; /* 비율 유지 */
}

/* 오른쪽 폼 영역 스타일 */
.form-container {
	padding: 20px;
	border: 1px solid #eee;
	border-radius: 8px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

/* 유튜브 미리보기 영역 */
#videoPreviewFrame {
	border-radius: 8px;
	overflow: hidden;
	background-color: #000;
}
</style>
</head>
<body>
	<div class="container-fluid">
		<h2 class="mb-4 fw-bold text-center">영화 수정</h2>
		<hr class="mb-5">

		<div class="row">
			<div class="col-md-5 mb-4 mb-md-0">
				<div class="preview-container shadow-sm">
					<img id="posterPreview" src="<%=fullPosterPath%>"
						onerror="this.src='../save/no_image.jpg'" alt="포스터 preview"
						class="img-fluid rounded">
				</div>
				<p class="text-center text-muted mt-2 small">* 이미지 변경 시에만 파일을 선택하세요</p>
			</div>

			<div class="col-md-7">
				<div class="form-container bg-white">
					<form id="updateForm" enctype="multipart/form-data">

						<input type="hidden" name="movie_idx" value="<%=movieIdx%>">
                        <input type="hidden" name="existing_poster" value="<%=dbPosterPath%>"> 
                        <input type="hidden" name="update_id" value="admin">

						<h5 class="mb-3 fw-bold">기본 정보</h5>
						<div class="row mb-3 g-2">
							<div class="col-md-6">
								<label class="form-label small fw-bold">영화 ID (고유코드)</label> 
                                <input type="text" name="movie_id" id="movie_id" value="<%=dto.getMovieId()%>" class="form-control" readonly>
							</div>
							<div class="col-md-6">
								<label class="form-label small fw-bold">개봉일</label> 
                                <input type="date" name="release_day" value="<%=dto.getReleaseDay()%>" class="form-control" required>
							</div>
						</div>

						<div class="mb-3">
							<label class="form-label small fw-bold">영화 제목</label> 
                            <input type="text" name="title" value="<%=dto.getTitle()%>" class="form-control fw-bold" placeholder="영화 제목을 입력하세요" required>
						</div>

						<h5 class="mb-3 mt-4 fw-bold">세부 정보</h5>
						<div class="row mb-3 g-2">
							<div class="col-md-4">
								<label class="form-label small fw-bold">장르</label> 
                                <select name="genre" class="form-select">
									<option value="액션" <%=dto.getGenre().equals("액션") ? "selected" : ""%>>액션</option>
									<option value="코미디" <%=dto.getGenre().equals("코미디") ? "selected" : ""%>>코미디</option>
									<option value="SF" <%=dto.getGenre().equals("SF") ? "selected" : ""%>>SF</option>
									<option value="공포" <%=dto.getGenre().equals("공포") ? "selected" : ""%>>공포</option>
									<option value="스릴러" <%=dto.getGenre().equals("스릴러") ? "selected" : ""%>>스릴러</option>
									<option value="로맨스" <%=dto.getGenre().equals("로맨스") ? "selected" : ""%>>로맨스(멜로)</option>
                                    <option value="로맨스(멜로)" <%=dto.getGenre().equals("로맨스(멜로)") ? "selected" : ""%>>로맨스(멜로)</option>
									<option value="드라마" <%=dto.getGenre().equals("드라마") ? "selected" : ""%>>드라마</option>
									<option value="판타지" <%=dto.getGenre().equals("판타지") ? "selected" : ""%>>판타지</option>
									<option value="뮤지컬" <%=dto.getGenre().equals("뮤지컬") ? "selected" : ""%>>뮤지컬</option>
									<option value="전쟁" <%=dto.getGenre().equals("전쟁") ? "selected" : ""%>>전쟁</option>
									<option value="가족" <%=dto.getGenre().equals("가족") ? "selected" : ""%>>가족</option>
									<option value="범죄" <%=dto.getGenre().equals("범죄") ? "selected" : ""%>>범죄</option>
									<option value="애니메이션" <%=dto.getGenre().equals("애니메이션") ? "selected" : ""%>>애니메이션</option>
								</select>
							</div>
							<div class="col-md-4">
								<label class="form-label small fw-bold">국가</label> 
                                <input type="text" name="country" value="<%=dto.getCountry()%>" class="form-control">
							</div>
							<div class="col-md-4">
								<label class="form-label small fw-bold">감독</label> 
                                <input type="text" name="director" value="<%=dto.getDirector()%>" class="form-control">
							</div>
						</div>

						<div class="mb-3">
							<label class="form-label small fw-bold">출연진</label> 
                            <input type="text" name="cast" value="<%=dto.getCast()%>" class="form-control">
						</div>

						<div class="mb-3">
							<label class="form-label small fw-bold">줄거리</label>
							<textarea name="summary" class="form-control" rows="5"><%=dto.getSummary()%></textarea>
						</div>

						<h5 class="mb-3 mt-4 fw-bold">관련 미디어 수정</h5>
						<div class="mb-3 p-3 bg-light rounded border">
							<label class="form-label small fw-bold text-primary">포스터 이미지 (변경할 때만 선택)</label> 
                            <input type="file" name="poster_path" id="posterInput" class="form-control" accept="image/*">
						</div>

						<div class="mb-3 p-3 bg-light rounded border">
							<label class="form-label small fw-bold text-danger">트레일러 YouTube URL (하단 preview 확인)</label> 
                            <input type="text" name="trailer_url" id="trailerInput" value="<%=dto.getTrailerUrl()%>" class="form-control">

							<div class="ratio ratio-16x9 mt-3" id="videoPreviewFrame" style="display: none;">
								<iframe id="youtubeIframe" src="" title="YouTube video player" frameborder="0" allowfullscreen></iframe>
							</div>
						</div>

						<div class="d-grid gap-2 mt-5">
							<button type="submit" class="btn btn-warning btn-lg fw-bold py-3 text-white">영화 정보 수정하기</button>
							<button type="button" class="btn btn-outline-secondary" onclick="history.back()">뒤로가기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
	$(document).ready(function() {

        // ================= [1] 이미지 미리보기 기능 =================
        $("#posterInput").change(function() {
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#posterPreview').attr('src', e.target.result);
                }
                reader.readAsDataURL(this.files[0]);
            } else {
                // ★ [수정] 파일 선택 취소 시 원래 경로(URL or 파일)로 복구
                var originalSrc = "<%=fullPosterPath%>";
                $('#posterPreview').attr('src', originalSrc);
            }
        });

        // ================= [2] 유튜브 URL에서 Video ID 추출하는 함수 =================
        function getYoutubeId(url) {
            if(!url) return null;
            var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
            var match = url.match(regExp);
            // ID는 보통 11자리입니다.
            return (match && match[2].length === 11) ? match[2] : null;
        }

        // ================= [3] 유튜브 미리보기 기능 =================
        function updateVideoPreview() {
            var url = $("#trailerInput").val();
            var videoId = getYoutubeId(url);
            var $previewFrame = $("#videoPreviewFrame");
            var $iframe = $("#youtubeIframe");

            if (videoId) {
                var embedUrl = 'https://www.youtube.com/embed/' + videoId;
                $iframe.attr('src', embedUrl);
                $previewFrame.show();
            } else {
                $iframe.attr('src', '');
                $previewFrame.hide();
            }
        }

        // [초기 실행] 페이지 열리자마자 기존 URL로 미리보기 실행
        updateVideoPreview();

        // [이벤트] 입력값 변경 시 실행
        $("#trailerInput").on('blur change paste input', function() {
            updateVideoPreview();
        });

        // ================= [4] 폼 AJAX 수정 제출 기능 =================
        $("#updateForm").submit(function(e) {
            e.preventDefault(); // 새로고침 막기

            // 폼 데이터 (파일 포함) 가져오기
            var form = $(this)[0];
            var formData = new FormData(form);

            $.ajax({
                type : "post",
                url : "movieUpdateAction.jsp",
                data : formData,
                processData : false, // 파일 전송 필수 설정
                contentType : false, // 파일 전송 필수 설정
                beforeSend : function() {
                    $("button[type=submit]").prop("disabled", true).text("수정 진행중...");
                },
                success : function(res) {
                    if (res.trim() === "success") {
                        alert("✅ 영화 정보가 정상적으로 수정되었습니다.");

                        // [수정완료] reset()을 제거하고 상세 페이지로 이동하게 변경!
                        location.href = "movieDetail.jsp?movie_idx=<%=movieIdx%>";
                        
                    } else {
                        alert("수정 실패! 관리자에게 문의하세요.\n(에러내용: " + res.trim() + ")");
                    }
                },
                error : function() {
                    alert("서버 통신 에러 발생. 다시 시도해주세요.");
                },
                complete : function() {
                    $("button[type=submit]").prop("disabled", false).text("영화 정보 수정하기");
                }
            });
        });
    });
	</script>
</body>
</html>