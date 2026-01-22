<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
String loginId = (String) session.getAttribute("loginid");
String roleType = (String) session.getAttribute("roleType");

boolean isLogin = (loginId != null);
boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

if (!isLogin || isAdmin) {
    response.sendRedirect("list.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<!-- Toast UI Editor -->
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>

<title>글쓰기-왓플릭스</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
</head>
<body>



<div style="padding: 50px;">

	<form method="post"
	      action="writeAction.jsp"
	      enctype="multipart/form-data">
	
	
	  <!-- 분류 -->
	  <select name="category" class="form-select mb-3" required>
		<option value="">카테고리 선택</option>
		<option value="FREE">자유수다</option>
		<option value="QNA">질문 / 추천</option>
	  </select>
	
	  <!-- 제목 -->
	  <input type="text" name="title" class="form-control mb-3" placeholder="제목">
	
	  <!-- 에디터 -->
	  <div id="editor"></div>
	
	  <!-- 에디터 값 저장용 -->
	  <input type="hidden" name="content" id="content">
	  <!-- 파일 업로드 -->
	  <input type="file" name="uploadFile" class="form-control mt-3">
	
	  <!-- 태그 -->
	  <input type="text" name="tags" class="form-control mt-3"
	         placeholder="태그 입력 후 Enter">
	
	  <div class="mt-4 text-end">
	    <button type="submit" class="btn btn-primary">등록</button>
	  </div>
	
	</form>
</div>

<!-- 카테고리 미선택 모달 -->
<div class="modal fade" id="categoryModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">알림</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        카테고리를 선택해주세요.
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">
          확인
        </button>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
<script>
const editor = new toastui.Editor({
	  el: document.querySelector('#editor'),
	  height: '500px',
	  initialEditType: 'wysiwyg',
	  previewStyle: 'vertical',
	  language: 'ko-KR',
	  placeholder: '이곳에 글을 작성하세요.',

	  hooks: {
	    addImageBlobHook: (blob, callback) => {
	      const formData = new FormData();
	      formData.append('image', blob);

	      fetch('imageUpload.jsp', {
	        method: 'POST',
	        body: formData
	      })
	      .then(res => res.json())
	      .then(data => {
	        callback(data.url, 'image');
	      });
	    }
	  }
	});


  const form = document.querySelector('form');
  const categorySelect = document.querySelector('select[name="category"]');
  const modal = new bootstrap.Modal(
    document.getElementById('categoryModal')
  );

  form.addEventListener('submit', function (e) {
    // 카테고리 선택 안 했을 때
    if (!categorySelect.value) {
      e.preventDefault();     // submit 중단
      modal.show();           // 모달 표시
      return;
    }

    // 정상일 때만 에디터 내용 세팅
    document.getElementById('content').value = editor.getHTML();
  });
</script>


</body>
</html>