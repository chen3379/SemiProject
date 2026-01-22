<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="board.free.FreeBoardDao"%>
<%@ page import="board.free.FreeBoardDto"%>
<%@ page import="board.review.ReviewBoardDao"%>
<%@ page import="board.review.ReviewBoardDto"%>

<%
    FreeBoardDao freeDao = new FreeBoardDao();
    ReviewBoardDao reviewDao = new ReviewBoardDao();

    List<FreeBoardDto> freeTop10 = freeDao.getTop10ByReadcount();
    List<ReviewBoardDto> reviewTop10 = reviewDao.getTop10ByReadcount();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/community.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>

<body>
<jsp:include page="../main/nav.jsp" />
<jsp:include page="../login/loginModal.jsp" />
<jsp:include page="../profile/profileModal.jsp"/>

<div class="container community-main" style="padding-top: 40px;">

    <!-- ===== 게시판 바로가기 ===== -->
    <div class="row g-4 mb-5">
        <div class="col-md-6">
            <a href="<%=request.getContextPath()%>/board/free/list.jsp" style="text-decoration:none">
                <div class="rank-card">
                    <h4>💬 자유게시판</h4>
                    <p style="font-size:14px;color:#bbb;">일상 · 잡담 · 질문을 자유롭게</p>
                </div>
            </a>
        </div>

        <div class="col-md-6">
            <a href="<%=request.getContextPath()%>/board/review/list.jsp" style="text-decoration:none">
                <div class="rank-card">
                    <h4>🎬 영화 리뷰</h4>
                    <p style="font-size:14px;color:#bbb;">영화 감상 후기와 추천</p>
                </div>
            </a>
        </div>
    </div>

    <!-- ===== 커뮤니티 인기 글 ===== -->
    <h2 class="section-title">🔥 커뮤니티 인기 글</h2>

    <div class="row g-4">
        <!-- 자유게시판 TOP10 -->
        <div class="col-md-6">
            <div class="rank-card">
                <h4>💬 자유게시판 TOP 10</h4>
                <ul class="rank-list">
                    <%
                        int rank = 1;
                        for (FreeBoardDto dto : freeTop10) {
                    %>
                    <li>
                        <span class="rank"><%=rank++%></span>
                        <a href="<%=request.getContextPath()%>/board/free/detail.jsp?board_idx=<%=dto.getBoard_idx()%>">
                            <%=dto.getTitle()%>
                        </a>
                        <span class="count"><%=dto.getReadcount()%></span>
                    </li>
                    <% } %>
                </ul>
            </div>
        </div>

        <!-- 영화리뷰 TOP10 -->
        <div class="col-md-6">
            <div class="rank-card">
                <h4>🎬 영화리뷰 TOP 10</h4>
                <ul class="rank-list">
                    <%
                        rank = 1;
                        for (ReviewBoardDto dto : reviewTop10) {
                    %>
                    <li>
                        <span class="rank"><%=rank++%></span>
                        <a href="<%=request.getContextPath()%>/board/review/detail.jsp?board_idx=<%=dto.getBoard_idx()%>">
                            <%=dto.getTitle()%>
                        </a>
                        <span class="count"><%=dto.getReadcount()%></span>
                    </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </div>

    <!-- ===== 공지사항 ===== -->
    <div class="notice-area">
        <h4>📢 공지사항</h4>
        <ul>
            <li>[공지] 커뮤니티 이용 규칙 안내</li>
            <li>[공지] 스포일러 글 작성 가이드</li>
        </ul>
    </div>

</div>

</body>
</html>
