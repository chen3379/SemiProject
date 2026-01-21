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
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
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
boolean isAdmin = "ADMIN".equals(session.getAttribute("roleType"));
boolean canEdit = isOwner || isAdmin;

/* 좋아요 여부 */
boolean isLiked = false;
if(loginId != null){
    isLiked = likeDao.isLiked(board_idx, loginId);
}
%>

<style>
.container { max-width: 720px; margin: 40px auto; }
.title { font-weight: bold; margin-top: 20px; }
.meta { color:#888; font-size:13px; display:flex; gap:12px; }
.like-btn {
    display:inline-flex;
    gap:6px;
    padding:10px 18px;
    border-radius:999px;
    background:#ffecec;
    color:#ff5b5b;
    cursor:pointer;
}
.like-btn.active {
    background:#ff4d4d;
    color:#fff;
}
.comment-item { margin-top:20px; }
.comment-writer { font-weight:bold; }
</style>

<body>
<div class="container">

    <!-- 상단 -->
    <div class="d-flex justify-content-between">
        <div>
            <div><strong><%= dto.getId() %></strong></div>
            <div class="meta">
                <span><%= dto.getCreate_day() %></span>
                <span>조회 <%= dto.getReadcount() %></span>
            </div>
        </div>

        <% if(canEdit){ %>
        <div>
            <a href="update.jsp?board_idx=<%=board_idx%>">수정</a> |
            <a href="delete.jsp?board_idx=<%=board_idx%>"
               onclick="return confirm('삭제하시겠습니까?')">삭제</a>
        </div>
        <% } %>
    </div>

    <!-- 제목 -->
    <h2 class="title"><%= dto.getTitle() %></h2>

    <!-- 본문 -->
    <div class="mt-4">
        <%= dto.getContent() %>
    </div>

    <!-- 좋아요 -->
    <div class="text-center mt-5">
        <div id="likeBtn"
             class="like-btn <%=isLiked ? "active" : "" %>"
             data-board="<%=board_idx%>">
            <i class="bi bi-hand-thumbs-up"></i>
            <span id="likeCount"><%= likeCount %></span>
        </div>
    </div>

    <!-- 댓글 수 -->
    <div class="mt-4">💬 댓글 <%= commentCount %></div>

    <!-- 댓글 목록 -->
    <% for(ReviewCommentDto c : clist){ %>
    <div class="comment-item">
        <div class="comment-writer"><%= c.getWriter_id() %></div>
        <div><%= c.getContent() %></div>
        <div style="font-size:12px;color:#999;"><%= c.getCreate_day() %></div>
    </div>
    <% } %>

    <!-- 댓글 작성 -->
    <form action="commentInsert.jsp" method="post" class="mt-4">
        <input type="hidden" name="board_idx" value="<%=board_idx%>">
        <textarea name="content" class="form-control" required></textarea>
        <button class="btn btn-dark mt-2">댓글 등록</button>
    </form>

</div>

<script>
$('#likeBtn').click(function(){
    $.post('likeAction.jsp',
        { board_idx: $(this).data('board') },
        function(res){
            if(res.status === 'LOGIN_REQUIRED'){
                alert('로그인이 필요합니다');
                return;
            }
            $('#likeCount').text(res.count);
            $('#likeBtn').toggleClass('active', res.liked);
        }, 'json'
    );
});
</script>

</body>
</html>