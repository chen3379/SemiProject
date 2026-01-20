<%@page import="board.free.FreeBoardDao"%>
<%@page import="board.free.FreeBoardDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));
FreeBoardDao dao = new FreeBoardDao();
FreeBoardDto dto = dao.getBoard(board_idx);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

<!-- Toast UI Editor -->
<link rel="stylesheet"
	href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script
	src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<title>글 수정</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
</head>

<body>

	<div style="padding: 50px;">

		<form method="post" action="updateAction.jsp"
			enctype="multipart/form-data">

			<!-- 🔥 수정 대상 글 번호 -->
			<input type="hidden" name="board_idx" value="<%= board_idx %>">

			<!-- 분류 -->
			<select name="category" class="form-select mb-3" required>
				<option value="">카테고리 선택</option>
				<option value="FREE"
					<%= "FREE".equals(dto.getCategory_type()) ? "selected" : "" %>>
					자유수다</option>
				<option value="QNA"
					<%= "QNA".equals(dto.getCategory_type()) ? "selected" : "" %>>
					질문 / 추천</option>
			</select>

			<!-- 제목 -->
			<input type="text" name="title" class="form-control mb-3"
				placeholder="제목" value="<%= dto.getTitle() %>" required>

			<!-- 에디터 -->
			<div id="editor"></div>

			<!-- 에디터 값 저장용 -->
			<input type="hidden" name="content" id="content">

			<!-- 파일 업로드 -->
			<input type="file" name="uploadFile" class="form-control mt-3">

			<div class="mt-4 text-end">
				<button type="submit" class="btn btn-primary">수정 완료</button>
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
    placeholder: '이곳에 글을 작성하세요.'
  });

  // ✅ 기존 글 내용 세팅
  editor.setHTML(`<%= dto.getContent().replace("`", "\\`") %>`);
  editor.setMarkdown(`<%= dto.getContent().replace("`", "\\`") %>`);


  const form = document.querySelector('form');

  form.addEventListener('submit', function () {
    document.getElementById('content').value = editor.getHTML();
  });
</script>

</body>
</html>
