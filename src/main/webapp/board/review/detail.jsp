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
String boardIdxParam = request.getParameter("board_idx");
if (boardIdxParam == null || boardIdxParam.isEmpty()) {
    out.println("<script>alert('잘못된 접근입니다.'); location.href='list.jsp';</script>");
    return;
}
int board_idx = Integer.parseInt(boardIdxParam);

String loginId = (String) session.getAttribute("loginid");
String roleType = (String) session.getAttribute("roleType");

boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

ReviewBoardDao dao = new ReviewBoardDao();
ReviewBoardDto dto;

if (isAdmin) {
    // 관리자: 숨김 글 포함 조회
    dto = dao.getAdminBoard(board_idx);
} else {
    // 일반 유저: 숨김 제외
    dto = dao.getBoard(board_idx);
}

if (dto == null) {
    out.println("<script>alert('존재하지 않는 게시글입니다.'); location.href='list.jsp';</script>");
    return;
}

boolean isOwner = loginId != null && loginId.equals(dto.getId());
boolean canEdit = isOwner || isAdmin;

if (dto.getIs_deleted() == 1 && !canEdit) {
    out.println("<script>alert('삭제되었거나 숨김 처리된 글입니다.'); history.back();</script>");
    return;
}

dao.updateReadCount(board_idx);

if (isAdmin) {
    dto = dao.getAdminBoard(board_idx);
} else {
    dto = dao.getBoard(board_idx);
}

ReviewLikeDao likeDao = new ReviewLikeDao();
int likeCount = likeDao.getLikeCount(board_idx);
boolean isLiked = loginId != null && likeDao.isLiked(board_idx, loginId);

ReviewCommentDao cdao = new ReviewCommentDao();
List<ReviewCommentDto> clist = cdao.getCommentList(board_idx);
int commentCount = cdao.getCommentCount(board_idx);

List<ReviewBoardDto> otherList = dao.getOtherBoards(board_idx, 5);
SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
%>
<jsp:include page="/main/nav.jsp" />
<body>
    <main class="post-wrapper">
        <div class="post-container">
		<div class="post-header">
		    <div class="profile user-profile"
		         data-user-id="<%=dto.getId()%>"
		         data-nickname="<%=dto.getNickname()%>">
		        <div class="profile-img">👤</div>
		        <div>
		            <div class="writer">
					    <%= ( "3".equals(roleType) || "9".equals(roleType) || dto.getNickname() == null )
					        ? dto.getId()
					        : dto.getNickname() %>
					</div>
		            <div class="time">
		                <%= new SimpleDateFormat("yyyy.MM.dd").format(dto.getCreate_day()) %>
		            </div>
		        </div>
		    </div>
		    <div class="post-meta">
		        <span class="readcount">조회 <%=dto.getReadcount()%></span>
		       		<%
					    boolean isTestMode = false; // 테스트 끝나면 false
					%>
					<% if (canEdit) { %>
					    <span class="more" id="postMenuBtn">⋮</span>
					
					    <div class="post-menu" id="postMenu">
					        <a href="update.jsp?board_idx=<%= board_idx %>">수정</a>
					        <a href="javascript:void(0);"
					           id="deletePostBtn"
					           data-board="<%= board_idx %>">
					            삭제
					        </a>
					    </div>
					<% } %>	
		    </div>
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
		if (loginId != null) {
		    isLiked = likeDao.isLiked(board_idx, loginId);
		}
		%>
		<div class="like-area">
			<div class="like-wrapper <%=isLiked ? "active" : "" %>" id="likeBtn"
				data-board="<%= board_idx %>">
				<i class="bi bi-hand-thumbs-up"></i> <span class="like-count"
					id="likeCount"><%= likeCount %></span>
			</div>
		</div>
		<div class="post-footer mb-5">
			<span>💬 <%=commentCount %></span> <span id="copyUrlBtn"
				style="cursor: pointer;">🔗 URL</span> <span>🔗 공유</span>
		</div>
		<% if (!isAdmin) { %>
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
		<% } %>
		<!-- 댓글 영역 -->
		<div class="comment-list mt-5">

			<% for (ReviewCommentDto parent : clist) { %>
			<% if (parent.getParent_comment_idx() != 0) continue; %>
			<!-- ================= 원댓글 ================= -->
			<div class="comment-item">
				<div class="comment-avatar">👤</div>
				<div class="comment-body">
					<%-- 삭제된 원댓글 --%>
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
							<span class="writer"><%= b.getNickname() %></span>
							<span class="date">
								<%= new java.text.SimpleDateFormat("yyyy.MM.dd")
		                              .format(b.getCreate_day()) %>
							</span>
						</div></li>
					<% } %>
				</ul>
			</div>
		</div>
		</div>
		</main>
		<script>
		function closeUserModal() {
		    $('#userInfoModal').fadeOut(150);
		    $('#userInfoOverlay').fadeOut(150);
		}
		</script>
		<script>
		$(function () {
	    /* =========================
	       댓글 등록
	    ========================= */
	    $('#commentSubmitBtn').on('click', function () {
	        const content = $('textarea[name="content"]').val()?.trim();
	
	        if (!content) {
	            alert('내용을 입력하세요');
	            return;
	        }
	
	        $.post(
	            'commentInsert.jsp',
	            {
	                board_idx: '<%= board_idx %>',
	                content
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
	    /* =========================
	       답글 등록
	    ========================= */
	    $(document).on('click', '.reply-submit-btn', function () {
	        const parentIdx = $(this).data('parent');
	        const content = $(this)
	            .closest('.reply-form')
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
	                content
	            },
	            function (res) {
	                if (res.status === 'SUCCESS') {
	                    location.reload();
	                }
	            },
	            'json'
	        );
	    });
	    /* =========================
	       댓글 삭제
	    ========================= */
	    $(document).on('click', '.comment-delete-btn', function () {
	        const commentIdx = $(this).data('id');
	
	        alert('댓글을 삭제하시겠습니까?', function () {
	            $.post(
	                'commentDelete.jsp',
	                { comment_idx: commentIdx },
	                function (res) {
	                    if (res.status === 'SUCCESS') {
	                        location.reload();
	                    }
	                },
	                'json'
	            );
	        });
	    });
	    /* =========================
	       답글 폼 토글
	    ========================= */
	    $(document).on('click', '.reply-btn', function () {
	        const form = $('#reply-form-' + $(this).data('id'));
	        if (!form.length) return;
	        form.toggle();
	    });
	    /* ========================
	       URL 복사
	    ========================= */
	    const $copyBtn = $('#copyUrlBtn');
	    if ($copyBtn.length) {
	        const originalText = $copyBtn.text();
	        let timer = null;
	
	        $copyBtn.on('click', function () {
	            navigator.clipboard.writeText(location.href).then(() => {
	                if (timer) return;
	                $copyBtn.text('🔗 URL 복사됨');
	                timer = setTimeout(() => {
	                    $copyBtn.text(originalText);
	                    timer = null;
	                }, 2000);
	            });
	        });
	    }
	    /* =========================
	       게시글 메뉴 토글
	    ========================= */
	    $('#postMenuBtn').on('click', function (e) {
	        e.stopPropagation();
	        $('#postMenu').toggle();
	    });
	    /* =========================
	       좋아요
	    ========================= */
	    $('#likeBtn').on('click', function () {
	        const boardIdx = $(this).data('board');
	
	        $.post(
	            'likeAction.jsp',
	            { board_idx: boardIdx },
	            function (res) {
	                if (res.status === 'LOGIN_REQUIRED') {
	                    alert('로그인이 필요합니다.');
	                    return;
	                }
	                $('#likeCount').text(res.count);
	                $('#likeBtn').toggleClass('active', res.liked);
	            },
	            'json'
	        );
	    });

	    $('#deletePostBtn').on('click', function () {
	        const boardIdx = $(this).data('board');
	
	        alert('정말 삭제하시겠습니까?', function () {
	            location.href = 'delete.jsp?board_idx=' + boardIdx;
	        });
	    });
	    /* ===== 유저 정보 모달 ===== */
	    $('#userInfoOverlay, #userInfoModal').hide();
	
	    $(document).on('click', '.user-profile', function () {
	        const userId = $(this).data('user-id');
	        if (!userId) return;
	
	        $.get(
	            '<%=request.getContextPath()%>/profile/memberInfoAction.jsp',
	            { id: userId },
	            function (res) {
	                if (res.status !== 'SUCCESS') {
	                    alert('유저 정보를 불러올 수 없습니다.');
	                    return;
	                }
	                $('#uiNickname').text(res.nickname);
	                $('#uiEmail').text(res.id);
	                $('#uiJoinDate').text(res.createDay);
	
	                $('#userInfoOverlay').fadeIn(150);
	                $('#userInfoModal').fadeIn(150);
	            },
	            'json'
	        );
	    });
	    $('#userInfoOverlay').on('click', closeUserModal);
	
	    $(document).on('keydown', function (e) {
	        if (e.key === 'Escape') closeUserModal();
	    });
	});
	</script>
	<footer class="global-footer">
		<jsp:include page="/main/footer.jsp" />
	</footer>
	<!-- 유저 정보 모달 -->
	<div class="user-info-overlay" id="userInfoOverlay"></div>
	<div class="user-info-modal" id="userInfoModal">
		<div class="user-info-left">
			<div class="avatar">👤</div>
		</div>
		<div class="user-info-right">
			<div class="info-row">
				<span class="label">닉네임</span> <span class="value" id="uiNickname"></span>
			</div>
			<div class="info-row">
				<span class="label">아이디</span> <span class="value" id="uiEmail"></span>
			</div>
			<div class="info-row">
				<span class="label">가입일</span> <span class="value" id="uiJoinDate"></span>
			</div>
		  	<!-- 닫기 버튼 -->
	        <div class="modal-footer">
	           <button class="close-btn" onclick="closeUserModal()">닫기</button>
	        </div>
		</div>
	</div>
</body>
</html>