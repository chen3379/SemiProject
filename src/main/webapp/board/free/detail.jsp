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
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/detail.css">
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
			String category = dto.getCategory_type();
			if ("FREE".equals(category)) {
			%>자유수다<%
			} else if ("QNA".equals(category)) {
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
		<div class="post-footer mb-5">
			<span>💬 <%=commentCount %></span> <span id="copyUrlBtn" style="cursor: pointer;">🔗
				URL</span> <span>🔗 공유</span>
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
			            <i class="bi bi-camera"></i>
			            <i class="bi bi-emoji-smile"></i>
			        </div>
			
			        <% if (loginId != null) { %>
			            <button type="button" id="commentSubmitBtn">등록</button>
			        <% } %>
			    </div>
			</form>
		</div>
	  	
		<!-- 댓글 영역 -->
		<div class="comment-list mt-5">

		<% for (FreeCommentDto parent : clist) { %>
		    <% if (parent.getParent_comment_idx() != 0) continue; %>
		
		    <!-- ================= 원댓글 ================= -->
		    <div class="comment-item">
		
		        <div class="comment-avatar">👤</div>
		
		        <div class="comment-body">
		
		            <%-- 🔹 삭제된 원댓글 --%>
		            <% if (parent.getIs_deleted() == 1) { %>
		
		                <div class="comment-content text-muted fst-italic">
		                    삭제된 댓글입니다.
		                </div>
		
		            <% } else { %>
		
		                <div class="comment-top">
		                    <span class="comment-writer"><%= parent.getWriter_id() %></span>
		                    <span class="comment-date"><%= parent.getCreate_day() %></span>
		                </div>
		
		                <div class="comment-content">
		                    <%= parent.getContent() %>
		                </div>
		
		                <div class="comment-actions">
		                    <span class="reply-btn"
		                          data-id="<%= parent.getComment_idx() %>">답글</span>
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
		                    <button type="button"
		                            class="reply-submit-btn"
		                            data-parent="<%= parent.getComment_idx() %>">
		                        등록
		                    </button>
		                </div>
		
		            <% } %>
		        </div>
		    </div>
		
		    <!-- ================= 대댓글 ================= -->
		    <% for (FreeCommentDto reply : clist) { %>
		        <% if (reply.getParent_comment_idx() == parent.getComment_idx()) { %>
		
		            <div class="comment-item reply">
		                <div class="comment-avatar">👤</div>
		
		                <div class="comment-body">
		
		                    <% if (reply.getIs_deleted() == 1) { %>
		
		                        <div class="comment-content text-muted fst-italic">
		                            삭제된 댓글입니다.
		                        </div>
		
		                    <% } else { %>
		
		                        <div class="comment-top">
		                            <span class="comment-writer"><%= reply.getWriter_id() %></span>
		                            <span class="comment-date"><%= reply.getCreate_day() %></span>
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