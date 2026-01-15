<%@page import="board.free.FreeBoardDto"%>
<%@page import="board.free.FreeBoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
</head>
<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

FreeBoardDao dao = new FreeBoardDao();
dao.updateReadCount(board_idx);

FreeBoardDto dto = dao.getBoard(board_idx);
%>


<style>
.post-container {
  max-width: 720px;
  margin: 40px auto;
  padding: 20px;
}

.post-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.profile {
  display: flex;
  align-items: center;
  gap: 10px;
}

.profile-img {
  width: 40px;
  height: 40px;
  background: #eee;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.writer {
  font-weight: bold;
}

.post-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #888;
  font-size: 13px;
}

.readcount {
  white-space: nowrap;
}

.more {
  cursor: pointer;
  font-size: 18px;
}

.time {
  font-size: 12px;
  color: #888;
}

.post-title {
  margin-top: 20px;
  font-weight: bold;
}

.post-category {
  margin-top: 8px;
  color: #4a6cf7;
  font-size: 14px;
}

.post-content {
  margin-top: 20px;
  line-height: 1.7;
}

.like-area {
  margin: 40px 0;              /* 위아래 여백 */
  display: flex;
  justify-content: center;     /* 가로 정중앙 */
}


.like-wrapper {
  display: inline-flex;
  justify-content:center;
  align-items: center;
  gap: 6px;
  padding: 10px 18px;
  border-radius: 999px;
  background-color: #ffecec;   /* 기본 연한 핑크 */
  color: #ff5b5b;

  font-size: 14px;
  cursor: pointer;

  transition: all 0.25s ease;
}

/* hover 시 */
.like-wrapper:hover {
  background-color: #ff4d4d;   /* 진한 레드 */
  color: #ffffff;
  box-shadow: 0 6px 14px rgba(255, 77, 77, 0.35);
}

/* 아이콘 크기 */
.like-wrapper i {
  font-size: 16px;
}


.post-footer {
  display: flex;
  justify-content: center;
  gap: 30px;
  color: #666;
  font-size: 14px;
}
</style>
<body>
<div class="post-container">

  <!-- 작성자 영역 -->
  <div class="post-header">
    <div class="profile">
      <div class="profile-img">👤</div>
      <div>
        <div class="writer"><%= dto.getId() %></div>
        <div class="time">8분 전</div>
      </div>
    </div>

	 <div class="post-meta">
	    <span class="readcount">조회 <%= dto.getReadcount() %></span>
	    <span class="more">⋮</span> <!-- 여기다 인쇄만 넣을꺼야?메뉴 뭐 넣을꺼??? -->
	  </div>
  </div>

  <!-- 제목 -->
  <h2 class="post-title"><%= dto.getTitle() %></h2>

  <!-- 카테고리 -->
  <div class="post-category">
   <%
   	String category= dto.getCategory_type();
   	if("FREE".equals(category)){
   		%>자유수다<%
   	}else if ("QNA".equals(category)) {
   		%>질문 / 추천<%
   	}
   %>
  </div>

  <!-- 본문 -->
  <div class="post-content">
    <%= dto.getContent() %>
  </div>

  <!-- 좋아요 -->
	<div class="like-area">
	  <div class="like-wrapper">
	    <i class="bi bi-hand-thumbs-up"></i>
	    <span class="like-count">1</span>
	  </div>
	</div>

  <!-- 하단 액션 -->
  <div class="post-footer">
    <span>💬 0</span>
    <span id="copyUrlBtn" style="cursor:pointer;">🔗 URL</span>
    <span>🔗 공유</span>
  </div>

</div>
<script>
  const copyBtn = document.getElementById('copyUrlBtn');
  const originalText = copyBtn.innerHTML;
  let timer = null;

  copyBtn.addEventListener('click', function () {
    const url = window.location.href;

    navigator.clipboard.writeText(url).then(() => {
      // 이미 바뀐 상태면 중복 실행 방지
      if (timer) return;

      // 텍스트 변경
      copyBtn.innerHTML = '🔗 URL 복사됨';
      copyBtn.style.color = '#db1f12'; 

      // 5초 후 원래대로
      timer = setTimeout(() => {
        copyBtn.innerHTML = originalText;
        copyBtn.style.color = '';
        timer = null;
      }, 20000);

    }).catch(() => {
      alert('URL 복사에 실패했습니다.');
    });
  });
</script>
</body>
</html>