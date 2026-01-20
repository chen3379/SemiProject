<%@page import="board.review.ReviewBoardDto"%>
<%@page import="board.free.FreeBoardDto"%>
<%@page import="java.util.List"%>
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
<%
FreeBoardDao freeDao = new FreeBoardDao();
List<FreeBoardDto> freeTopList = freeDao.getTop10List();
%>

</head>

<style>
/* 상단 헤더 */
.community-header {
    height: 450px;
    background-color: #000;
    color: #fff;
    font-size: 48px;
    font-family: 'Dongle', sans-serif;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* 커뮤니티 메뉴 */
.community-menu {
    background-color: #000;
    display: flex;
    justify-content: center;
    gap: 40px;
    padding: 16px 0;
}

.community-menu a {
    color: #fff;
    text-decoration: none;
    font-size: 22px;
    font-family: 'Nanum Myeongjo', serif;
    padding-bottom: 4px;
}

.community-menu a:hover {
    border-bottom: 2px solid #fff;
}
</style>
<body>
  	<div class="community-header">
        COMMUNITY
   	</div>

	  <div class="community-menu">
        <a href="<%=request.getContextPath()%>/board/free/list.jsp">자유게시판</a>
        <a href="<%=request.getContextPath()%>/board/review/list.jsp">리뷰게시판</a>
    </div>
	
	<h3>🔥 자유게시판 TOP 10</h3>
	<ul>
	<%
	for(FreeBoardDto dto : freeTopList){
	%>
	    <li>
	        <a href="<%=request.getContextPath()%>/board/free/detail.jsp?board_idx=<%=dto.getBoard_idx()%>">
	            <%=dto.getTitle()%>
	        </a>
	        <span>(조회 <%=dto.getReadcount()%>)</span>
	    </li>
	<%
	}
	%>
	</ul>
	<h3>🔥 영화게시판 TOP 10</h3>
	<ul>
	<%
	for(FreeBoardDto dto : freeTopList){
	%>
	    <li>
	        <a href="<%=request.getContextPath()%>/board/free/detail.jsp?board_idx=<%=dto.getBoard_idx()%>">
	            <%=dto.getTitle()%>
	        </a>
	        <span>(조회 <%=dto.getReadcount()%>)</span>
	    </li>
	<%
	}
	%>
	</ul>
	
</body>
</html>