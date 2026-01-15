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
<title>커뮤니티-왓플릿스</title>
<%
String category = request.getParameter("category");
if (category == null) category = "all";

FreeBoardDao dao = new FreeBoardDao();
List<FreeBoardDto> list = dao.getBoardList(category);
%>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
/* 기본 리셋 */
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI",
                 Roboto, "Noto Sans KR", Arial, sans-serif;
    background-color: #fafafa;
}

/* 전체 감싸는 영역 */
.container {
    max-width: 1200px;     /* 최대만 제한 */
    margin: 0 auto;
    padding: 20px;
}

/* 제목 */
h2 {
    margin-bottom: 16px;
}

/* 카테고리 탭 */
/* 바깥 래퍼: 스크롤 담당 */
.category-wrap {
    overflow-x: auto;
    overflow-y: hidden;
    -webkit-overflow-scrolling: touch; /* 모바일 부드러운 스크롤 */
}

/* 실제 메뉴 */
.category {
    padding: 8px 12px;
  
}

/* 메뉴 버튼 */
.category a {
    display: inline-block;
    padding: 6px 14px;
    border-radius: 999px;
    background: #f5f5f5;
    color: #333;
    font-size: 14px;
    font-weight: 500;
    text-decoration: none;
    flex-shrink: 0;            /* 줄어들지 않게 */
}

/* 활성화 상태 */
.category a.active {
    background: #000;
    color: #fff;
}


/* 테이블 */
table {
    width: 100%;
    border-collapse: collapse;
    background: #fff;
}

th, td {
    padding: 12px 10px;
    border-bottom: 1px solid #e0e0e0;
    text-align: center;
    font-size: 14px;
}

th {
    background-color: #f2f2f2;
    font-weight: 600;
}

td.title {
    text-align: left;
    word-break: break-word;
}

/* 스포일러 */
.spoiler {
    color: #d32f2f;
    font-weight: bold;
    margin-right: 6px;
}

/* 글쓰기 버튼 */
.write-btn {
    margin-top: 16px;
    text-align: right;
}

.write-btn a {
    display: inline-block;
    padding: 8px 14px;
    background: #333;
    color: #fff;
    text-decoration: none;
    border-radius: 4px;
    font-size: 14px;
}

/* =======================
   📱 반응형 (모바일)
   ======================= */
@media (max-width: 768px) {

    /* 테이블 헤더 숨김 */
    thead {
        display: none;
    }

    table, tbody, tr, td {
        display: block;
        width: 100%;
    }

    tr {
        margin-bottom: 12px;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 12px;
        background: #fff;
    }

    td {
        text-align: left;
        border: none;
        padding: 6px 0;
        font-size: 13px;
    }

    td::before {
        font-weight: bold;
        display: inline-block;
        width: 80px;
        color: #666;
    }

    td.num::before { content: "번호"; }
    td.category::before { content: "카테고리"; }
    td.title::before { content: "제목"; }
    td.writer::before { content: "작성자"; }
    td.date::before { content: "작성일"; }
    td.count::before { content: "조회수"; }

    .write-btn {
        text-align: center;
    }
}
</style>
</head>
<body>

<div class="container">
    <h2>자유게시판</h2>

    <!-- 카테고리 -->
   <div class="category-wrap">
	    <div class="category">
	        <a href="list.jsp?category=all"
	           class="<%= "all".equals(category) ? "active" : "" %>">
	           전체
	        </a>
	
	        <a href="list.jsp?category=FREE"
	           class="<%= "FREE".equals(category) ? "active" : "" %>">
	           자유수다
	        </a>
	
	        <a href="list.jsp?category=QNA"
	           class="<%= "QNA".equals(category) ? "active" : "" %>">
	           질문 / 추천
	        </a>
	    </div>
	</div>

    <!-- 게시글 목록 -->
    <table>
        <thead>
            <tr>
                <th>번호</th>
                <th>카테고리</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>
        </thead>
		<tbody>
			<%
			    for (FreeBoardDto dto : list) {
			%>
			    <tr>
			        <td class="num"><%=dto.getBoard_idx()%></td>
			
			        <td class="category">
			            <%="FREE".equals(dto.getCategory_type()) ? "자유수다" : "질문/추천"%>
			        </td>
			
			        <td class="title">
			            <% if (dto.isIs_spoiler_type()) { %>
			                <span class="spoiler">[스포]</span>
			            <% } %>
			            <a href="detail.jsp?board_idx=<%= dto.getBoard_idx()%>">
			                <%= dto.getTitle() %>
			            </a>
			        </td>
			
			        <td class="writer"><%= dto.getId() %></td>
			        <td class="date"><%= dto.getCreate_day() %></td>
			        <td class="count"><%= dto.getReadcount() %></td>
			    </tr>
			<%
			    }
			%>
		</tbody>
			
        
        	
    </table>

    <div class="write-btn">
        <a href="write.jsp"><i class="bi bi-pen"></i>글쓰기</a>
    </div>
</div>

</body>
</html>