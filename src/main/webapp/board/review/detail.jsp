<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.comment.ReviewCommentDto"%>
<%@page import="java.util.List"%>
<%@page import="board.comment.ReviewCommentDao"%>
<%@page import="board.like.ReviewLikeDao"%>
<%@page import="board.review.ReviewBoardDto"%>
<%@page import="board.review.ReviewBoardDao"%>
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
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/detail.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>영화 리뷰 상세</title>
</head>

<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

ReviewBoardDao dao = new ReviewBoardDao();
dao.updateReadCount(board_idx);
ReviewBoardDto dto = dao.getBoard(board_idx);

/* ===== 좋아요 ===== */
ReviewLikeDao likeDao = new ReviewLikeDao();
int likeCount = likeDao.getLikeCount(board_idx);

/* ===== 댓글 ===== */
ReviewCommentDao cdao = new ReviewCommentDao();
List<ReviewCommentDto> clist = cdao.getCommentList(board_idx);
int commentCount = cdao.getCommentCount(board_idx);

/* 로그인 */
String loginId = (String)session.getAttribute("loginid");
boolean isOwner = loginId != null && loginId.equals(dto.getId());
String roleType = (String) session.getAttribute("roleType");
boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));
boolean canEdit = isOwner || isAdmin;

List<ReviewBoardDto> otherList = dao.getOtherBoards(board_idx, 5);
SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
%>
<body>
	<script>
	$(function () {
	
	    /* 댓글 등록 */
	    $('#commentSubmitBtn').on('click', function () {
	
	        const content = $('textarea[name="content"]').val().trim();
	
	        if (!content) {
	            alert('내용을 입력하세요');
	            return;
	        }
	
	        $.post(
	            'commentInsert.jsp',
	            {
	                board_idx: '<%= board_idx %>',
	                content: content
	            },
	            function (res) {
	
	                if (res.status === 'LOGIN_REQUIRED') {
	                    alert('로그인이 필요합니다');
	                    return;
	                }
	
	                if (res.status === 'SUCCESS') {
	                    location.reload(); 
	                } else {
	                    alert('댓글 등록 실패');
	                }
	            },
	            'json'
	        );
	    });
	
	});
	
	$(document).on('click', '.reply-submit-btn', function () {

	    const parentIdx = $(this).data('parent');

	    const content = $(this)
	        .closest('.reply-form')   // ⭐ 이 답글 폼 기준
	        .find('textarea')
	        .val()
	        .trim();

	    if (!content) {
	        alert('답글 내용을 입력하세요');
	        return;
	    }

	    $.post(
	        'commentInsert.jsp',
	        {
	            board_idx: '<%= board_idx %>',
	            parent_comment_idx: parentIdx,
	            content: content
	        },
	        function (res) {
	            if (res.status === 'SUCCESS') {
	                location.reload();
	            }
	        },
	        'json'
	    );
	});

	
	$(document).on('click', '.comment-delete-btn', function () {

	    if (!confirm('댓글을 삭제하시겠습니까?')) return;

	    const commentIdx = $(this).data('id');

	    $.post(
	        'commentDelete.jsp',
	        { comment_idx: commentIdx },
	        function (res) {

	            if (res.status === 'LOGIN_REQUIRED') {
	                alert('로그인이 필요합니다.');
	                return;
	            }

	            if (res.status === 'SUCCESS') {
	                location.reload();
	            }
	        },
	        'json'
	    );
	});
	</script>
	<div class="container">

		<!-- 상단 -->
		<div class="d-flex justify-content-between">
			<div>
				<div>
					<strong><%= dto.getId() %></strong>
				</div>
				<div class="meta">
					<span><%= dto.getCreate_day() %></span> <span>조회 <%= dto.getReadcount() %></span>
				</div>
			</div>
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
			    <a href="update.jsp?board_idx=<%=board_idx%>">수정</a>
			    <a href="javascript:void(0);"
				   id="deletePostBtn"
				   data-board="<%=board_idx%>">
				   삭제
				</a>

			</div>
			<%
		}
		%>
		</div>

		<!-- 제목 -->
		<h2 class="title"><%= dto.getTitle() %></h2>

		<!-- 본문 -->
		<div class="mt-4">
			<%= dto.getContent() %>
		</div>
		<% if (dto.getFilename() != null && !dto.getFilename().isEmpty()) { %>
		<div class="post-attachment mt-4">
			<i class="bi bi-paperclip"></i> <a
				href="<%=request.getContextPath()%>/save/<%=dto.getFilename()%>"
				download> <%= dto.getFilename() %>
			</a>
		</div>
		<% } %>
		<%
		ReviewLikeDao frLikeDao = new ReviewLikeDao();
		
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
			<div class="like-wrapper <%=isLiked ? "active" : "" %>" id="likeBtn"
				data-board="<%= board_idx %>">
				<i class="bi bi-hand-thumbs-up"></i> <span class="like-count"
					id="likeCount"><%= likeCount %></span>
			</div>
		</div>


		<!-- 하단 액션 -->
		<div class="post-footer mb-5">
			<span>💬 <%=commentCount %></span> <span id="copyUrlBtn"
				style="cursor: pointer;">🔗 URL</span> <span>🔗 공유</span>
		</div>


		<!-- 댓글 작성 박스 -->
		<div class="comment-input-box">
			<!-- 입력 영역 -->
			<form id="commentForm">
				<input type="hidden" name="board_idx" value="<%= board_idx %>">

				<div class="comment-writer-name">
					<%= loginId != null ? loginId : "비회원" %>
				</div>

				<% if (loginId == null) { %>
				<textarea disabled placeholder="로그인 후 댓글을 작성할 수 있습니다"></textarea>
				<% } else { %>
				<textarea name="content" placeholder="댓글을 남겨보세요" required></textarea>
				<% } %>

				<div class="comment-input-footer">
					<div class="comment-tools">
						<i class="bi bi-camera"></i> <i class="bi bi-emoji-smile"></i>
					</div>

					<% if (loginId != null) { %>
					<button type="button" id="commentSubmitBtn">등록</button>
					<% } %>
				</div>
			</form>
		</div>

		<!-- 댓글 영역 -->
		<div class="comment-list mt-5">

			<% for (ReviewCommentDto parent : clist) { %>
			<% if (parent.getParent_comment_idx() != 0) continue; %>

			<!-- ================= 원댓글 ================= -->
			<div class="comment-item">

				<div class="comment-avatar">👤</div>

				<div class="comment-body">

					<%-- 🔹 삭제된 원댓글 --%>
					<% if (parent.getIs_deleted() == 1) { %>

					<div class="comment-content text-muted fst-italic">삭제된 댓글입니다.
					</div>

					<% } else { %>

					<div class="comment-top">
						<span class="comment-writer"><%= parent.getWriter_id() %></span> <span
							class="comment-date"><%= parent.getCreate_day() %></span>
					</div>

					<div class="comment-content">
						<%= parent.getContent() %>
					</div>

					<div class="comment-actions">
						<span class="reply-btn" data-id="<%= parent.getComment_idx() %>">답글</span>
						<span class="action-divider">·</span>

						<% if (loginId != null && loginId.equals(parent.getWriter_id())) { %>
						<span class="comment-delete-btn"
							data-id="<%= parent.getComment_idx() %>">삭제</span>
						<% } else { %>
						<span>신고</span>
						<% } %>
					</div>

					<!-- 답글 입력 -->
					<div class="reply-form"
						id="reply-form-<%= parent.getComment_idx() %>">
						<textarea placeholder="답글을 입력하세요"></textarea>
						<button type="button" class="reply-submit-btn"
							data-parent="<%= parent.getComment_idx() %>">등록</button>
					</div>

					<% } %>
				</div>
			</div>

			<!-- ================= 대댓글 ================= -->
			<% for (ReviewCommentDto reply : clist) { %>
			<% if (reply.getParent_comment_idx() == parent.getComment_idx()) { %>

			<div class="comment-item reply">
				<div class="comment-avatar">👤</div>

				<div class="comment-body">

					<% if (reply.getIs_deleted() == 1) { %>

					<div class="comment-content text-muted fst-italic">삭제된 댓글입니다.
					</div>

					<% } else { %>

					<div class="comment-top">
						<span class="comment-writer"><%= reply.getWriter_id() %></span> <span
							class="comment-date"><%= reply.getCreate_day() %></span>
					</div>

					<div class="comment-content">
						<%= reply.getContent() %>
					</div>

					<div class="comment-actions">
						<% if (loginId != null && loginId.equals(reply.getWriter_id())) { %>
						<span class="comment-delete-btn"
							data-id="<%= reply.getComment_idx() %>">삭제</span>
						<% } else { %>
						<span>신고</span>
						<% } %>
					</div>

					<% } %>
				</div>
			</div>
			<% } %>
			<% } %>
			<% } %>
			<!-- ===== 하단 글 목록 ===== -->
			<div class="related-posts">
				<h3 class="related-title">
				    <i class="bi bi-list-ul"></i>
				    다른 글 더보기
				</h3>
				<ul class="related-list">
					<% for (ReviewBoardDto b : otherList ) { %>
					<li class="related-item"><a
						href="detail.jsp?board_idx=<%=b.getBoard_idx()%>"
						class="post-title-more"> <%= b.getTitle() %>
					</a>

						<div class="post-meta">
							<span class="writer"><%= b.getId() %></span> <span class="date">
								<%= new java.text.SimpleDateFormat("yyyy.MM.dd")
		                              .format(b.getCreate_day()) %>
							</span>
						</div></li>
					<% } %>
				</ul>
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
	        console.log('LIKE CLICKED');
	        $.post('likeAction.jsp', { board_idx: this.dataset.board }, function (res) {
	        	   console.log('RESPONSE = ', res);
	            if (res.status === 'LOGIN_REQUIRED') {
	                alert('로그인이 필요합니다.');
	                return;
	            }
	            $('#likeCount').text(res.count);
	            $('#likeBtn').toggleClass('active', res.liked);
	        }, 'json');
	    });
	    
	    console.log('confirmCustomAlert =', typeof confirmCustomAlert);

	    document.getElementById('deletePostBtn')?.addEventListener('click', function () {
	        const boardIdx = this.dataset.board;

	        confirmCustomAlert('정말 삭제하시겠습니까?', function () {
	            location.href = 'delete.jsp?board_idx=' + boardIdx;
	        });
	    });

	
	});
</script>

 <footer>
        <jsp:include page="/main/footer.jsp"/>
 </footer>
</body>
</html>