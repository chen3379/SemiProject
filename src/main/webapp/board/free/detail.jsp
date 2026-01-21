<%@page import="board.like.FreeLikeDao"%>
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

/* ===== 좋아요 ===== */
FreeLikeDao likeDao = new FreeLikeDao();
int likeCount = likeDao.getLikeCount(board_idx);

/* ===== 댓글 ===== */
FreeCommentDao cdao = new FreeCommentDao();
List<FreeCommentDto> clist = cdao.getCommentList(board_idx);
int commentCount = cdao.getCommentCount(board_idx);
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
    top: 36px;
    right: 0;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 10px;
    box-shadow: 0 6px 16px rgba(0,0,0,0.12);
    display: none;
    z-index: 1000;
    min-width: 120px;
}

.post-menu a {
    display: block;
    padding: 12px 16px;
    font-size: 14px;
    color: #222;
    text-decoration: none;
}

.post-menu a:hover {
    background: #f5f5f5;
}

@media (max-width: 576px) {

    .post-menu {
        position: fixed;
        bottom: 0;
        left: 0;
        right: 0;
        top: auto;
        border-radius: 16px 16px 0 0;
        padding: 12px 0;
        box-shadow: 0 -6px 16px rgba(0,0,0,0.2);
        animation: slideUp 0.25s ease;
    }

    .post-menu a {
        text-align: center;
        font-size: 16px;
        padding: 14px;
    }

    @keyframes slideUp {
        from {
            transform: translateY(100%);
        }
        to {
            transform: translateY(0);
        }
    }
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

				<%-- 작성자 관리자만 보이게 수정 삭제  --%>
				<%
				String loginId = (String) session.getAttribute("loginid");
				
				boolean isOwner = loginId != null && loginId.equals(dto.getId());
				boolean isAdmin = "ADMIN".equals(session.getAttribute("roleType"));
				
				// 🔧 테스트용 스위치
				boolean isTestMode = false;   // 테스트 끝나면 false
				boolean canEdit = isTestMode || isOwner || isAdmin;
				%>


				<%
				if (canEdit) {
				%>
				<span class="more" id="postMenuBtn">⋮</span>
				<%
				}
				%>

				<%
				if (canEdit) {
				%>
				<div class="post-menu" id="postMenu">
					<a href="update.jsp?board_idx=<%=board_idx%>">수정</a> <a
						href="delete.jsp?board_idx=<%=board_idx%>"
						onclick="return confirm('정말 삭제하시겠습니까?')">삭제</a>
				</div>
				<%
				}
				%>
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
		<%
		FreeLikeDao frLikeDao = new FreeLikeDao();
		
		String frLoginId = (String) session.getAttribute("loginid");
		
		// 좋아요 개수
		int frLikeCount = likeDao.getLikeCount(board_idx);
		
		// 내가 좋아요 눌렀는지
		boolean isLiked = false;
		if (loginId != null) {
		    isLiked = likeDao.isLiked(board_idx, loginId);
		}
		%>

		<!-- 좋아요 -->
		<div class="like-area">
		    <div class="like-wrapper <%=isLiked ? "active" : "" %>"
		         id="likeBtn"
		         data-board="<%= board_idx %>">
		        <i class="bi bi-hand-thumbs-up"></i>
		        <span class="like-count" id="likeCount"><%= likeCount %></span>
		    </div>
		</div>


		<!-- 하단 액션 -->
		<div class="post-footer">
			<span>💬 <%=commentCount %></span> <span id="copyUrlBtn" style="cursor: pointer;">🔗
				URL</span> <span>🔗 공유</span>
		</div>

		<!-- 댓글 영역 -->
		<div class="comment-list mt-5">
			<% for (FreeCommentDto c : clist) { %>
			    <%-- ================= 삭제된 댓글 ================= --%>
			    <% if (c.getIs_deleted() == 1) { %>
			
			        <div class="comment-item <%= c.getParent_comment_idx() != 0 ? "reply" : "" %>">
			            <div class="comment-avatar">👤</div>
			            <div class="comment-body">
			                <div class="comment-content text-muted fst-italic">
			                    삭제된 댓글입니다.
			                </div>
			            </div>
			        </div>
			
			    <% } else { %>
			
			        <%-- ================= 정상 댓글 ================= --%>
			
			        <% if (c.getParent_comment_idx() == 0) { %>
			        <!-- ===== 원댓글 ===== -->
			        <div class="comment-item">
			
			            <div class="comment-avatar">👤</div>
			
			            <div class="comment-body">
			                <div class="comment-top">
			                    <span class="comment-writer"><%= c.getWriter_id() %></span>
			                    <span class="comment-date"><%= c.getCreate_day() %></span>
			                </div>
			
			                <div class="comment-content">
			                    <%= c.getContent() %>
			                </div>
			
			                <div class="comment-actions">
			                    <span class="reply-btn" data-id="<%= c.getComment_idx() %>">답글</span>
			                    <span class="action-divider">·</span>
			                    <span>신고</span>
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
			
			        <!-- ===== 답글 ===== -->
			        <div class="comment-item reply">
			
			            <div class="comment-avatar">👤</div>
			
			            <div class="comment-body">
			                <div class="comment-top">
			                    <span class="comment-writer"><%= c.getWriter_id() %></span>
			                    <span class="comment-date"><%= c.getCreate_day() %></span>
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
			
			<% } %>
		</div>
	</div>
	<script>
	document.addEventListener('DOMContentLoaded', function () {
	
	    /* URL 복사 */
	    const copyBtn = document.getElementById('copyUrlBtn');
	    if (copyBtn) {
	        const originalText = copyBtn.innerHTML;
	        let timer = null;
	
	        copyBtn.addEventListener('click', function () {
	            navigator.clipboard.writeText(location.href).then(() => {
	                if (timer) return;
	                copyBtn.innerHTML = '🔗 URL 복사됨';
	                timer = setTimeout(() => {
	                    copyBtn.innerHTML = originalText;
	                    timer = null;
	                }, 2000);
	            });
	        });
	    }
	
	    /* 답글 토글 */
	    document.querySelectorAll('.reply-btn').forEach(btn => {
	        btn.addEventListener('click', () => {
	            const form = document.getElementById('reply-form-' + btn.dataset.id);
	            if (!form) return;
	            form.style.display = form.style.display === 'block' ? 'none' : 'block';
	        });
	    });
	
	    /* 게시글 메뉴 */
	    const menuBtn = document.getElementById('postMenuBtn');
	    const menu = document.getElementById('postMenu');
	    if (menuBtn && menu) {
	        menuBtn.addEventListener('click', e => {
	            e.stopPropagation();
	            menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
	        });
	        document.addEventListener('click', () => menu.style.display = 'none');
	    }
	
	    /* 좋아요 */
	    document.getElementById('likeBtn')?.addEventListener('click', function () {
	        $.post('likeAction.jsp', { board_idx: this.dataset.board }, function (res) {
	            if (res.status === 'LOGIN_REQUIRED') {
	                alert('로그인이 필요합니다.');
	                return;
	            }
	            $('#likeCount').text(res.count);
	            $('#likeBtn').toggleClass('active', res.liked);
	        }, 'json');
	    });
	
	});
</script>
</body>
</html>