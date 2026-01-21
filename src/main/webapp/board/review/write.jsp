<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

<!-- Toast UI Editor -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<title>영화 리뷰 작성</title>
</head>


<body>
	<div class="container" style="max-width: 900px; padding: 60px 20px;">
		<div class="review-write-wrap">

			<div class="review-title mb-4">
				<h2>🎬 영화 리뷰</h2>
				<span>보고 느낀 그대로, 당신의 한 줄 평</span>
			</div>
			<form method="post" action="writeAction.jsp"
				enctype="multipart/form-data">

				<!-- ⭐ 영화 카테고리 (리뷰는 보통 단일 카테고리) -->
				<input type="hidden" name="category" value="REVIEW">

				<!-- 제목 -->
				<input type="text" name="title" class="form-control mb-3"
					placeholder="영화 리뷰 제목을 입력하세요" required>

				<!-- 에디터 -->
				<div id="editor"></div>

				<!-- 에디터 내용 저장 -->
				<input type="hidden" name="content" id="content">

				<!-- 첨부 이미지 -->
				<input type="file" name="uploadFile" class="form-control mt-3">

				<div class="mt-4 text-end">
					<button type="submit" class="btn submit-btn">
					    <i class="bi bi-pencil-square"></i> 등록
					</button>
				</div>
			</form>
		</div>
	</div>
	<script>
		const editor = new toastui.Editor({
			el : document.querySelector('#editor'),
			height : '500px',
			initialEditType : 'wysiwyg',
			previewStyle : 'vertical',
			language : 'ko-KR',
			placeholder : '영화에 대한 리뷰를 작성해주세요.'
		});

		const form = document.querySelector('form');

		form.addEventListener('submit', function(e) {
			document.getElementById('content').value = editor.getHTML();
		});
	</script>

</body>
</html>
