<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String movieIdx = request.getParameter("movie_idx");
  if(movieIdx == null) movieIdx = "";
%>

<style type="text/css">
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
</style>

<div class="text-start" id="reviewFormRoot">
  
  <input type="hidden" id="movieIdxHidden" value="<%=movieIdx%>">
  
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

  <!-- 등록 버튼만 (취소 제거 원하면 버튼 줄 자체 삭제) -->
  <div class="d-flex gap-2 justify-content-end">
    <button type="button" class="btn btn-warning text-white fw-bold" id="btnReviewSubmit">
      등록
    </button>
  </div>

</div>

<script>
$(function(){

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

  // 한줄평 등록
  $(document).off("click", "#btnReviewSubmit").on("click", "#btnReviewSubmit", function () {

	  var movieIdx = $("#movieIdxHidden").val();
	  var score = $("#reviewScore").val();      // 0.5~5.0
	  var content = $("#reviewContent").val();

	  if (score === "0.0") {
	    alert("별점을 선택해 주세요.");
	    return;
	  }
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

	      // 2) 별점 저장 (movieRatingInsert.jsp)
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

	          // 3) 목록 갱신 (별점까지 같이 보이게)
	          loadReviewListAlways();
	          $("#reviewForm").empty();

	          // 입력 초기화(원하면)
	          $("#reviewContent").val("");
	          $("#reviewLen").text("0");

	          alert("등록 완료");
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


});
</script>
