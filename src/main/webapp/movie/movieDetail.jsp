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

// 한줄평 갯수 체크
int movieIdx=Integer.parseInt(movie_idx);
MovieReviewDao reviewDao=new MovieReviewDao();
int reviewCount=reviewDao.totalReview(movieIdx);

// 리뷰 목록 가져오기
List<MovieReviewDto> rlist = reviewDao.getAllReviewsWithScore(movieIdx);

//평균별점
MovieRatingStatDao statDao=new MovieRatingStatDao();
BigDecimal avgScore=statDao.getAvgScore(movieIdx);
int ratingCount=statDao.getRatingCount(movieIdx);

//로그인 수정 필요
String id = (String)session.getAttribute("id");
Boolean loginStatus = (Boolean)session.getAttribute("loginStatus");
boolean isLogin = (loginStatus != null && loginStatus == true && id != null);


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
.star-wrap{
    position: relative;
    display: inline-block;
    font-size: 32px;
    line-height: 1;
    cursor: pointer;
    user-select: none;
    white-space: nowrap;
    flex: 0 0 auto;
    width: 5em;
  }
  .star-bg{ color:#ccc; white-space:nowrap; }
  .star-fill{
    position:absolute;
    left:0; top:0;
    width:0%;
    overflow:hidden;
    color:gold;
    pointer-events:none;
    white-space:nowrap;
  }
  .info{ margin-left: 12px; }
  #heartIcon { transition: transform 0.15s ease; }
  #heartIcon.active { transform: scale(1.2); }
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
					<span class="fs-3 fw-bold me-2">
						<%=(ratingCount==0?"0.0":String.format("%.1f", avgScore)) %>
					</span>
					<span class="text-muted">(참여 <%=reviewCount %>명)</span>
					&nbsp;&nbsp;&nbsp;
					<button type="button" id="wishBtn" class="btn p-0 border-0 bg-transparent d-flex align-items-center gap-1" data-wished="false">
					    <span id="wishText" class="text-muted">위시</span>
					    <i id="wishIcon" class="bi bi-heart text-danger fs-4"></i>
					</button>
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

<!-- =================== 한줄평 영역 =================== -->
<div class="comment-section">
  <h4 class="fw-bold mb-4">
    <i class="bi bi-chat-dots-fill"></i> 관람객 한줄평
  </h4>

  <%-- 0개면: reviewBox만 보이게 --%>
  <% if(reviewCount == 0){ %>
    <div class="card p-5 text-center bg-white border-0 shadow-sm" id="reviewBox">
      <h5 class="text-muted">아직 등록된 한줄평이 없습니다.</h5>
      <p class="text-muted small">첫 번째로 별점과 코멘트를 남겨보세요!</p>
      <button class="btn btn-warning text-white fw-bold mt-2" id="btnReviewWrite">
        한줄평 작성하기
      </button>
    </div>
  <% } %>

  <%-- 폼은 항상 존재시키되, 0개면 숨김 / 1개 이상이면 보임 --%>
  <div class="text-start bg-white p-3 rounded shadow-sm mb-3 <%= (reviewCount==0 ? "d-none" : "") %>"
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
      <textarea class="form-control" id="reviewContent" rows="3" maxlength="100"
        placeholder="한줄평을 작성해 주세요 (최대 100자)"></textarea>

      <div class="d-flex justify-content-end">
        <small class="text-muted"><span id="reviewLen">0</span>/100</small>
      </div>
    </div>

    <div class="d-flex justify-content-end">
      <button type="button" class="btn btn-warning text-white fw-bold" id="btnReviewSubmit">등록</button>
    </div>
  </div>

  <%-- 목록도 1개 이상일 때만 보이게 --%>
  <div class="mt-3 <%= (reviewCount==0 ? "d-none" : "") %>" id="reviewList">
    <% if(rlist != null && !rlist.isEmpty()){ %>
      <div class="list-group">
        <% for(MovieReviewDto r : rlist){ %>
        <div class="list-group-item">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <b><%=r.getId()%></b>

              <%
                double score = (r.getScore() == null) ? 0.0 : r.getScore().doubleValue();
                int full = (int)Math.floor(score);
                boolean half = (score - full) >= 0.5;
                int empty = 5 - full - (half ? 1 : 0);
              %>

              <span class="ms-1 align-middle" style="font-size:14px;">
                <% for(int i=0;i<full;i++){ %><i class="bi bi-star-fill text-warning"></i><% } %>
                <% if(half){ %><i class="bi bi-star-half text-warning"></i><% } %>
                <% for(int i=0;i<empty;i++){ %><i class="bi bi-star text-warning"></i><% } %>
              </span>

              <span class="ms-2 text-warning fw-semibold"><%=String.format("%.1f", score)%></span>
            </div>

            <div class="d-flex align-items-center gap-2">
              <span class="text-muted small"><%=r.getCreateDay()%></span>

              <% if(isLogin && id.equals(r.getId())) { %>
                <button type="button" class="btn btn-sm btn-outline-primary"
                  onclick="updateReview(<%=r.getReviewIdx()%>, '<%=r.getContent().replace("'", "\\'")%>')">수정</button>
                <button type="button" class="btn btn-sm btn-outline-danger"
                  onclick="deleteReview(<%=r.getReviewIdx()%>)">삭제</button>
              <% } %>
            </div>
          </div>

          <div class="mt-2"><%=r.getContent()%></div>
        </div>
        <% } %>
      </div>
    <% } %>
  </div>

</div>

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
	 var isLogin = <%= isLogin ? "true" : "false" %>;
	 
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
	
	
	
</script>
</body>
</html>