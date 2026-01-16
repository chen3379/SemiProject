<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
    /* 전체 컨테이너 여백 조정 */
    .container-fluid { max-width: 1400px; margin-top: 30px; margin-bottom: 50px; }
    
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
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
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
<!-- Local 영화 등록창/save에 있는 이미지 파일 별도로 공유해야함 -->
<div class="container-fluid">
    <h2 class="mb-4 fw-bold text-center">영화 등록</h2>
    <hr class="mb-5">
    
    <div class="row">
        <div class="col-md-5 mb-4 mb-md-0">
            <div class="preview-container shadow-sm">
                <img id="posterPreview" src="../save/no_image.jpg" alt="포스터 preview" class="img-fluid rounded">
            </div>
            <p class="text-center text-muted mt-2 small">* 5MB 이하의 jpg, png 파일 업로드</p>
        </div>
        
        <div class="col-md-7">
            <div class="form-container bg-white">
                <form id="insertForm" enctype="multipart/form-data">
                    
                    <input type="hidden" name="create_id" value="admin"> 

                    <h5 class="mb-3 fw-bold">기본 정보</h5>
                    <div class="row mb-3 g-2">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">영화 ID (고유코드)</label>
                            <input type="text" name="movie_id" id="movie_id" class="form-control" placeholder="예: avengers_개봉일" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">개봉일</label>
                            <input type="date" name="release_day" class="form-control" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold">영화 제목</label>
                        <input type="text" name="title" class="form-control fw-bold" placeholder="영화 제목을 입력하세요" required>
                    </div>

                    <h5 class="mb-3 mt-4 fw-bold">세부 정보</h5>
                    <div class="row mb-3 g-2">
                        <div class="col-md-4">
                            <label class="form-label small fw-bold">장르</label>
                            <select name="genre" class="form-select">
                                <option selected value="액션">액션</option>
                                <option value="코미디">코미디</option>
                                <option value="SF">SF</option>
                                <option value="공포">공포</option>
                                <option value="스릴러">스릴러</option>
                                <option value="로맨스(멜로)">로맨스(멜로)</option>
                                <option value="드라마">드라마</option>
                                <option value="판타지">판타지</option>
                                <option value="뮤지컬">뮤지컬</option>
                                <option value="전쟁">전쟁</option>
                                <option value="가족">가족</option>
                                <option value="범죄">범죄</option>
                                <option value="애니메이션">애니메이션</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold">국가</label>
                            <input type="text" name="country" class="form-control" placeholder="예: 한국">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold">감독</label>
                            <input type="text" name="director" class="form-control" placeholder="감독 이름">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold">출연진</label>
                        <input type="text" name="cast" class="form-control" placeholder="주요 배우 이름을 콤마(,)로 구분하여 입력">
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold">줄거리</label>
                        <textarea name="summary" class="form-control" rows="5" placeholder="영화의 줄거리를 입력하세요."></textarea>
                    </div>
                    
                    <h5 class="mb-3 mt-4 fw-bold">관련 미디어 업로드</h5>
                    <div class="mb-3 p-3 bg-light rounded border">
                        <label class="form-label small fw-bold text-primary">포스터 이미지 업로드 (왼쪽 preview 확인)</label>
                        <input type="file" name="poster_path" id="posterInput" class="form-control" accept="image/*">
                    </div>
                    
                    <div class="mb-3 p-3 bg-light rounded border">
                        <label class="form-label small fw-bold text-danger">트레일러 YouTube URL (하단 preview 확인)</label>
                        <input type="text" name="trailer_url" id="trailerInput" class="form-control" placeholder="예: https://www.youtube.com/watch?v=xxxxxx">
                        
                        <div class="ratio ratio-16x9 mt-3" id="videoPreviewFrame" style="display: none;">
                             <iframe id="youtubeIframe" src="" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                        </div>
                    </div>

                    <div class="d-grid gap-2 mt-5">
                        <button type="submit" class="btn btn-primary btn-lg fw-bold py-3">영화 정보 등록하기</button>
                        <button type="button" class="btn btn-outline-secondary" onclick="history.back()">뒤로가기</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    
    // 이미지 preview
    $("#posterInput").change(function() {
        // 파일이 선택되었다면
        if (this.files && this.files[0]) {
            var reader = new FileReader();
            
            // 파일 읽기가 완료되면 실행될 콜백 함수
            reader.onload = function(e) {
                // 읽은 데이터(이미지 src)를 왼쪽 미리보기 img 태그에 적용
                $('#posterPreview').attr('src', e.target.result);
            }
            
            // 파일을 읽어 data URL 형식으로 변환
            reader.readAsDataURL(this.files[0]);
        } else {
             // 파일 선택 취소 시 기본 이미지로 복구
             $('#posterPreview').attr('src', '../save/no_image.jpg');
        }
    });


    // 유튜브 URL에서 Video ID 추출하는 함수 - 변환 처리 과정
    // 퍼가기를 통한 embed url을 직접 넣지 않을 시 youtube에서 일반 url로 띄우는 게 막혀있음
    function getYoutubeId(url) {
        // 다양한 유튜브 URL 패턴에 대응하는 정규식
        var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
        var match = url.match(regExp);
        // ID는 보통 11자리
        return (match && match[2].length === 11) ? match[2] : null;
    }

    // 영상 preview
    // 입력창에서 포커스가 벗어나거나 값이 변경될 때 실행
    $("#trailerInput").on('blur change paste input', function() {
        var url = $(this).val();
        var videoId = getYoutubeId(url);
        var $previewFrame = $("#videoPreviewFrame");
        var $iframe = $("#youtubeIframe");

        if (videoId) {
            // 유효한 ID가 추출되면 embed URL을 만들어 iframe에 적용
            var embedUrl = 'https://www.youtube.com/embed/' + videoId;
            $iframe.attr('src', embedUrl);
            $previewFrame.slideDown(); // 부드럽게 보여주기
        } else if (url.trim() === '') {
             // URL이 비어있으면 숨김
             $iframe.attr('src', '');
             $previewFrame.slideUp();
        } else {
            // URL은 있는데 ID 추출 실패 시 (잘못된 URL)
             // 필요하다면 에러 메시지 표시
        }
    });


    // 폼 AJAX 제출
    $("#insertForm").submit(function(e){
        e.preventDefault(); // 새로고침 막기

        // 폼 데이터 (파일 포함) 가져오기
        var form = $(this)[0];
        var formData = new FormData(form);

        $.ajax({
            type: "post",
            url: "movieInsertAction.jsp",
            data: formData,
            processData: false, // 파일 전송 필수 설정
            contentType: false, // 파일 전송 필수 설정
            beforeSend: function() {
                // 전송 시작 전 버튼 비활성화 등 처리 가능
                $("button[type=submit]").prop("disabled", true).text("등록 진행중...");
            },
            success: function(res){
                if(res.trim() === "success"){
                    alert("영화가 정상적으로 등록되었습니다.");
                    
                    // 입력창 텍스트 모두 비우기
                    $("#insertForm")[0].reset();
                    
                    // 이미지 미리보기 초기화 (기본 이미지로 - save 공유 필요)
                    $('#posterPreview').attr('src', '../save/no_image.jpg');
                    
                    // 유튜브 미리보기 숨기고 iframe src 비우기
                    $("#videoPreviewFrame").hide();
                    $("#youtubeIframe").attr('src', '');
                    
                    // 커서 이동
                    $("#movie_id").focus();
                } else {
                    alert("등록 실패! 관리자에게 문의하세요.\n(에러내용: " + res.trim() + ")");
                }
            },
            error: function(){
                alert("서버 통신 에러 발생. 다시 시도해주세요.");
            },
            complete: function() {
                 // 완료 후 버튼 다시 활성화
                 $("button[type=submit]").prop("disabled", false).text("영화 정보 등록하기");
            }
        });
    });
});
</script>
</body>
</html>