<%@page import="board.comment.FreeCommentDto"%>
<%@page import="java.util.List"%>
<%@page import="board.comment.FreeCommentDao"%>
<%@page import="board.free.FreeBoardDto"%>
<%@page import="board.free.FreeBoardDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
</head>
<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

FreeBoardDao dao = new FreeBoardDao();
dao.updateReadCount(board_idx);

FreeBoardDto dto = dao.getBoard(board_idx);

FreeCommentDao cdao = new FreeCommentDao();
List<FreeCommentDto> clist = cdao.getCommentList(board_idx);
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
	position: relative; 
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

.post-menu {
    position: absolute;
    top: 0;
    right:0;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    display: none;
    z-index: 100;
}

.post-menu a {
    display: block;
    padding: 10px 16px;
    font-size: 14px;
    color: #333;
    text-decoration: none;
}

.post-menu a:hover {
    background: #f5f5f5;
}


.like-area {
	margin: 40px 0; /* 위아래 여백 */
	display: flex;
	justify-content: center; /* 가로 정중앙 */
}

.like-wrapper {
	display: inline-flex;
	justify-content: center;
	align-items: center;
	gap: 6px;
	padding: 10px 18px;
	border-radius: 999px;
	background-color: #ffecec; /* 기본 연한 핑크 */
	color: #ff5b5b;
	font-size: 14px;
	cursor: pointer;
	transition: all 0.25s ease;
}

/* hover 시 */
.like-wrapper:hover {
	background-color: #ff4d4d; /* 진한 레드 */
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

.btn-upload {
	background: #000;
	color: #fff;
	border: none;
	padding: 6px 12px;
	border-radius: 6px;
	font-size: 13px;
}

.right-actions button {
	margin-left: 8px;
}

.btn-like {
	background: #ffecec;
	color: #ff5b5b;
	border: none;
	padding: 6px 12px;
	border-radius: 20px;
}

.btn-submit {
	background: #f2f2f2;
	border: none;
	padding: 6px 14px;
	border-radius: 20px;
}

/* =======================
   댓글 영역 전체
   ======================= */
.comment-section {
	margin-top: 50px;
	padding-top: 24px;
	border-top: 1px solid #eee;
}

.comment-header h5 {
	font-size: 16px;
	font-weight: bold;
	margin-bottom: 20px;
}

/* =======================
   댓글 리스트
   ======================= */
.comment-list {
	display: flex;
	flex-direction: column;
	gap: 18px;
}

/* =======================
   댓글 아이템 (공통)
   ======================= */
.comment-item {
	display: flex;
	gap: 12px;
}

/* 프로필 */
.comment-avatar {
	width: 36px;
	height: 36px;
	background: #eee;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 14px;
	flex-shrink: 0;
}

/* 본문 */
.comment-body {
	flex: 1;
}

/* 상단 정보 */
.comment-top {
	display: flex;
	gap: 8px;
	align-items: center;
	font-size: 13px;
}

.comment-writer {
	font-weight: bold;
	color: #222;
}

.comment-date {
	color: #999;
	font-size: 12px;
}

/* 내용 */
.comment-content {
	margin-top: 4px;
	font-size: 14px;
	line-height: 1.6;
	color: #333;
	word-break: break-word;
}

/* 액션 */
.comment-actions {
	margin-top: 6px;
	font-size: 13px;
	color: #999;
	display: flex;
	gap: 6px;
}

.comment-actions span {
	cursor: pointer;
}

.comment-actions span:hover {
	color: #333;
}

.action-divider {
	cursor: default;
}

/* =======================
   답글 전용 스타일
   ======================= */
.comment-item.reply {
	margin-left: 48px;
	padding-left: 12px;
	border-left: 2px solid #f0f0f0;
}

/* =======================
   답글 입력폼
   ======================= */
.reply-form {
	margin-top: 10px;
	display: none;
}

.reply-form textarea {
	width: 100%;
	height: 70px;
	border: 1px solid #ddd;
	border-radius: 6px;
	padding: 10px;
	resize: none;
	font-size: 14px;
}

.reply-form button {
	margin-top: 6px;
	padding: 6px 12px;
	background: #000;
	color: #fff;
	border: none;
	border-radius: 6px;
	font-size: 13px;
}

/* =======================
   댓글 작성
   ======================= */
.comment-write {
	margin-top: 24px;
}

.comment-write textarea {
	width: 100%;
	height: 90px;
	border: 1px solid #ddd;
	border-radius: 8px;
	padding: 12px;
	resize: none;
	font-size: 14px;
}

.comment-write button {
	margin-top: 8px;
	padding: 8px 16px;
	border-radius: 20px;
	background: #000;
	color: #fff;
	border: none;
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
				<span class="readcount">조회 <%=dto.getReadcount()%></span>

				<%-- 작성자만 보이게 --%>
				<%
				String loginId = (String) session.getAttribute("loginid");
				boolean isOwner = loginId != null && loginId.equals(dto.getId());
				%>

				<%
				if (!isOwner) {
				%>
				<span class="more" id="postMenuBtn">⋮</span>
				<%
				}
				%>
			</div>
			<% if (!isOwner) { %>
			<div class="post-menu" id="postMenu">
				<a href="updateForm.jsp?board_idx=<%=board_idx%>">수정</a> <a
					href="delete.jsp?board_idx=<%=board_idx%>"
					onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
			</div>
			<% } %>
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
				<i class="bi bi-hand-thumbs-up"></i> <span class="like-count">1</span>
			</div>
		</div>

		<!-- 하단 액션 -->
		<div class="post-footer">
			<span>💬 0</span> <span id="copyUrlBtn" style="cursor: pointer;">🔗
				URL</span> <span>🔗 공유</span>
		</div>

		<!-- 댓글 영역 -->
		<div class="comment-list">

			<% for (FreeCommentDto c : clist) { %>

			<% if (c.getParent_comment_idx() == 0) { %>

			<!-- ================= 댓글 ================= -->
			<div class="comment-item">

				<div class="comment-avatar">👤</div>

				<div class="comment-body">

					<div class="comment-top">
						<span class="comment-writer"><%= c.getWriter_id() %></span> <span
							class="comment-date"><%= c.getCreate_day() %></span>
					</div>

					<div class="comment-content">
						<%= c.getContent() %>
					</div>

					<div class="comment-actions">
						<span class="reply-btn" data-id="<%= c.getComment_idx() %>">답글</span>
						<span class="action-divider">·</span> <span>신고</span>
					</div>

					<!-- 답글 입력 -->
					<div class="reply-form" id="reply-form-<%= c.getComment_idx() %>">
						<form action="commentInsert.jsp" method="post">
							<input type="hidden" name="board_idx" value="<%= board_idx %>">
							<input type="hidden" name="parent_comment_idx"
								value="<%= c.getComment_idx() %>">
							<textarea name="content" placeholder="답글을 입력하세요" required></textarea>
							<button type="submit">등록</button>
						</form>
					</div>

				</div>
			</div>

			<% } else { %>

			<!-- ================= 답글 ================= -->
			<div class="comment-item reply">

				<div class="comment-avatar">👤</div>

				<div class="comment-body">

					<div class="comment-top">
						<span class="comment-writer"><%= c.getWriter_id() %></span> <span
							class="comment-date"><%= c.getCreate_day() %></span>
					</div>

					<div class="comment-content">
						<%= c.getContent() %>
					</div>

					<div class="comment-actions">
						<span>신고</span>
					</div>

				</div>
			</div>

			<% } %>

			<% } %>

		</div>

	</div>
	<script>
	document.addEventListener('DOMContentLoaded', function () {
	
	    /* ======================
	       URL 복사 버튼
	       ====================== */
	    const copyBtn = document.getElementById('copyUrlBtn');
	
	    if (copyBtn) {
	        const originalText = copyBtn.innerHTML;
	        let timer = null;
	
	        copyBtn.addEventListener('click', function () {
	            const url = window.location.href;
	
	            navigator.clipboard.writeText(url).then(() => {
	
	                if (timer) return;
	
	                copyBtn.innerHTML = '🔗 URL 복사됨';
	                copyBtn.style.color = '#db1f12';
	
	                timer = setTimeout(() => {
	                    copyBtn.innerHTML = originalText;
	                    copyBtn.style.color = '';
	                    timer = null;
	                }, 2000);
	
	            }).catch(() => {
	                alert('URL 복사에 실패했습니다.');
	            });
	        });
	    }
	
	    /* ======================
	       답글 토글 버튼
	       ====================== */
	    const replyButtons = document.querySelectorAll('.reply-btn');
	
	    replyButtons.forEach(function (btn) {
	        btn.addEventListener('click', function () {
	            const id = btn.dataset.id;
	            const form = document.getElementById('reply-form-' + id);
	
	            if (!form) return;
	
	            if (form.style.maxHeight) {
	                form.style.maxHeight = null;
	                form.style.opacity = '0';
	            } else {
	                form.style.display = 'block';
	                form.style.maxHeight = form.scrollHeight + 'px';
	                form.style.opacity = '1';
	            }
	        });
	    });
	
	});
	
	document.addEventListener('DOMContentLoaded', function () {
	    const btn = document.getElementById('postMenuBtn');
	    const menu = document.getElementById('postMenu');

	    if (!btn || !menu) return;

	    btn.addEventListener('click', function (e) {
	        e.stopPropagation();
	        menu.style.display =
	            menu.style.display === 'block' ? 'none' : 'block';
	    });

	    document.addEventListener('click', function () {
	        menu.style.display = 'none';
	    });
	});
</script>
</body>
</html>