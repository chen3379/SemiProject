<%@page import="board.review.ReviewBoardDao"%>
<%@page import="board.review.ReviewBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

ReviewBoardDao dao = new ReviewBoardDao();
ReviewBoardDto dto = dao.getBoard(board_idx);
%>

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

<title>리뷰 수정</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
</head>

<body>

<div class="container" style="max-width: 900px; padding: 50px;">

    <h3 class="mb-4">🎬 영화 리뷰 수정</h3>

    <form method="post"
          action="updateAction.jsp"
          enctype="multipart/form-data">

        <!-- 🔥 수정 대상 -->
        <input type="hidden" name="board_idx" value="<%= board_idx %>">

        <!-- 리뷰 카테고리 고정 -->
        <input type="hidden" name="category" value="REVIEW">

        <!-- 장르 (필요하면 유지) -->
        <input type="hidden" name="genre" value="<%= dto.getGenre_type() %>">
		<!-- 스포 여부 -->
		<div class="mb-3">
		   <select name="is_spoiler" class="form-select">
			    <option value="0" <%= !dto.isIs_spoiler_type() ? "selected" : "" %>>
			        스포 없음
			    </option>
			    <option value="1" <%= dto.isIs_spoiler_type() ? "selected" : "" %>>
			        🚨 스포 있음
			    </option>
			</select>
		</div>
        <!-- 제목 -->
        <input type="text"
               name="title"
               class="form-control mb-3"
               value="<%= dto.getTitle() %>"
               required>

        <!-- 에디터 -->
        <div id="editor"></div>

        <!-- 에디터 값 저장 -->
        <input type="hidden" name="content" id="content">

        <!-- 기존 첨부파일 표시 -->
        <% if (dto.getFilename() != null && !dto.getFilename().isEmpty()) { %>
            <div class="mt-3">
                <i class="bi bi-paperclip"></i>
                <span><%= dto.getFilename() %></span>
            </div>
        <% } %>

        <!-- 파일 재업로드 -->
        <input type="file" name="uploadFile" class="form-control mt-3">

        <div class="mt-4 text-end">
            <button type="submit" class="btn btn-primary">
                수정 완료
            </button>
        </div>

    </form>
</div>

<script>
const editor = new toastui.Editor({
    el: document.querySelector('#editor'),
    height: '500px',
    initialEditType: 'wysiwyg',
    previewStyle: 'vertical',
    language: 'ko-KR',
    placeholder: '리뷰 내용을 수정하세요.'
});

// ✅ 기존 내용 세팅 (이미지 포함)
editor.setHTML(`<%= dto.getContent().replace("`", "\\`") %>`);

const form = document.querySelector('form');
form.addEventListener('submit', function () {
    document.getElementById('content').value = editor.getHTML();
});
</script>

</body>
</html>
