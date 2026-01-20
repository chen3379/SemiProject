<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
<title>커뮤니티 메인</title>


<!-- 커뮤니티 전용 -->
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/css/community.css?v=1">
</head>
<body>

	<jsp:include page="/main/nav.jsp" />

	<div class="container community-main">
		<h2 class="section-title">🔥 커뮤니티 인기 글</h2>
		<div class="row g-4">
			<!-- 자유게시판 TOP10 -->
			<div class="col-md-6">
				<div class="rank-card">
					<h4>💬 자유게시판 TOP 10</h4>
					<ul class="rank-list">
						<% int rank = 1;
                       for(FreeBoardDto dto : freeTop10) { %>
						<li><span class="rank"><%=rank++%></span> <a
							href="<%=request.getContextPath()%>/board/free/detail.jsp?board_idx=<%=dto.getBoard_idx()%>">
								<%=dto.getTitle()%>
						</a> <span class="count"><%=dto.getReadcount()%></span></li>
						<% } %>
					</ul>
				</div>
			</div>

			<!-- 영화리뷰 TOP10 -->
			<div class="col-md-6">
				<div class="rank-card">
					<h4>🎬 영화리뷰 TOP 10</h4>
					<ul class="rank-list">
						<% rank = 1;
                       for(ReviewBoardDto dto : reviewTop10) { %>
						<li><span class="rank"><%=rank++%></span> <a
							href="<%=request.getContextPath()%>/board/review/detail.jsp?review_idx=<%=dto.getBoard_idx()%>">
								<%=dto.getTitle()%>
						</a> <span class="count"><%=dto.getReadcount()%></span></li>
						<% } %>
					</ul>
				</div>
			</div>

		</div>

		<!-- 공지 -->
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