<%@page import="board.review.ReviewBoardDao"%>
<%@page import="board.review.ReviewBoardDto"%>
<%@page import="board.free.FreeBoardDto"%>
<%@page import="java.util.List"%>
<%@page import="board.free.FreeBoardDao"%>
<%@page import="java.text.SimpleDateFormat"%>
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
<title>커뮤니티-왓플릿스</title>
<%
ReviewBoardDao dao = new ReviewBoardDao();
String pageParam = request.getParameter("page");

int pageSize = 5;
int currentPage = (pageParam == null) ? 1 : Integer.parseInt(pageParam);
int start = (currentPage - 1) * pageSize;

String loginId = (String) session.getAttribute("loginid");
boolean isLogin = (loginId != null);
String roleType=(String)session.getAttribute("roleType");
boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));
List<ReviewBoardDto> list = dao.getReviewList(start, pageSize);
int totalCount = dao.getTotalCount();

if (isAdmin) {
    // 관리자: 숨김 포함
    list = dao.getAdminReviewList(start, pageSize);
    totalCount = dao.getAdminTotalCount();
} else {
    // 일반 유저: 숨김 제외
    list = dao.getReviewList(start, pageSize);
    totalCount = dao.getTotalCount();
}
int totalPage = (int)Math.ceil((double)totalCount / pageSize);

int pageBlock = 5;
int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
int endPage = startPage + pageBlock - 1;
if (endPage > totalPage) endPage = totalPage;
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
/* ===== 전체 ===== */
body {
	background: #141414;
	color: #fff;
	padding-top: 30px;
}

.review-container {
	padding-top: 40px;
	padding-bottom: 60px;
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
	flex-shrink: 0; /* 줄어들지 않게 */
}

/* 활성화 상태 */
.category a.active {
	background: #000;
	color: #fff;
}

/* ===== 헤더 ===== */
.review-header {
	margin-bottom: 28px;
}

.review-header h2 {
	font-weight: 700;
	margin-bottom: 6px;
}

.review-header h2 span {
	display: block;
	margin-top: 6px;
	font-size: 14px;
	color: #aaa;
}

/* ===== 테이블 카드 ===== */
.review-table-wrap {
	background: #1e1e1e;
	border-radius: 12px;
	padding: 16px 16px 8px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.6);
	min-height: 420px;
}

/* 테이블 */
table {
	width: 100%;
	border-collapse: collapse;
	background: transparent;
}

th, td {
	padding: 12px 10px;
	border-bottom: 1px solid rgba(255, 255, 255, 0.06);
	text-align: center;
	font-size: 14px;
}

th {
	font-weight: 600;
}

td.title {
	text-align: left;
	word-break: break-word;
}
/* 제목 줄 너무 길면 말줄임 */
td.title a {
	display: inline-block;
	max-width: 520px;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	color: #fff;
	text-decoration: none;
}
/* 스포일러 */
.spoiler {
	color: #d32f2f;
	font-weight: bold;
	margin-right: 6px;
}

/* ===== 글쓰기 버튼 ===== */
.write-btn {
	margin-top: 24px;
	text-align: right;
	text-decoration: none;
}

/* 기본 상태 */
.write-btn a {
	background: #e50914;
	color: #fff;
	padding: 10px 16px;
	border-radius: 6px;
	font-weight: 600;
	transition: background-color 0.2s ease;
	text-decoration: none;
}

/* 마우스 오버 */
.write-btn a:hover {
	background: #b20710;
	color: #fff;
}
/* =======================
   📱 반응형 (모바일)
   ======================= */
@media ( max-width : 768px) {
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
	td.category::before {
		content: "카테고리";
	}
	td.title::before {
		content: "제목";
	}
	td.writer::before {
		content: "작성자";
	}
	td.date::before {
		content: "작성일";
	}
	td.count::before {
		content: "조회수";
	}
	.write-btn {
		text-align: center;
	}
}

.page-wrap {
	display: flex;
	justify-content: center;
	margin: 40px 0 60px;
}

.page-list {
	display: flex;
	align-items: center;
	gap: 18px;
	list-style: none;
	padding: 0;
	margin: 0;
}

/* 기본 숫자 */
.page-list li a {
	width: 42px;
	height: 42px;
	display: flex;
	justify-content: center;
	align-items: center;
	border-radius: 50%;
	text-decoration: none;
	font-size: 16px;
	font-weight: 600;
	color: #9e9e9e;
	transition: all 0.2s ease;
}

/* hover */
.page-list li a:hover {
	color: #fff;
}

/* 현재 페이지 (빨간 원) */
.page-list li.active a {
	background-color: #e50914;
	color: #fff;
	box-shadow: 0 0 14px rgba(229, 9, 20, 0.7);
}

/* 화살표 */
.page-list li.arrow a {
	font-size: 22px;
	color: #9e9e9e;
}

.page-list li.arrow a:hover {
	color: #fff;
}
</style>
</head>
<body>
	<jsp:include page="/main/nav.jsp" />
	<jsp:include page="/login/loginModal.jsp" />
	<jsp:include page="/common/customAlert.jsp" />

	<div class="container" style="padding-top: 80px;">
		<div class="review-header">
			<h2>
				🎬 영화 리뷰 <span>왓플릭스 유저들의 솔직한 감상</span>
			</h2>
		</div>

		<!-- 게시글 목록 -->
		<div class="review-table-wrap">
			<table>
				<thead>
					<tr>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>조회수</th>
						<% if (isAdmin) { %>
						<th>관리</th>
						<% } %>

					</tr>
				</thead>

				<tbody>
					<% for (ReviewBoardDto dto : list) { 
		       boolean isSpoiler = dto.isIs_spoiler_type();
		%>
					<tr>
						<td class="title">
							<% if (isSpoiler) { %> <span class="badge bg-danger me-1">스포</span>
							<% } %> <a href="javascript:void(0);" class="review-link"
							data-url="detail.jsp?board_idx=<%=dto.getBoard_idx()%>"
							data-spoiler="<%= isSpoiler ? 1 : 0 %>"> <%= dto.getTitle() %>
						</a>
						</td>

						<td class="writer"><%= dto.getId() %></td>

						<td class="date"><%= sdf.format(dto.getCreate_day()) %></td>

						<td class="count"><%= dto.getReadcount() %></td>
						<%-- ⭐ 관리자 전용 관리 컬럼 --%>
						<% if (isAdmin) { %>
						<td>
							<% if (dto.getIs_deleted() == 0) { %> <!-- 숨김 -->
							<form action="adminHideAction.jsp" method="post"
								style="display: inline;">
								<input type="hidden" name="board_idx"
									value="<%=dto.getBoard_idx()%>">
								<button type="submit" class="btn btn-sm btn-danger">숨김</button>
							</form> <% } else { %> <!-- 복구 -->
							<form action="adminRestoreAction.jsp" method="post"
								style="display: inline;">
								<input type="hidden" name="board_idx"
									value="<%=dto.getBoard_idx()%>">
								<button type="submit" class="btn btn-sm btn-secondary">복구</button>
							</form> <% } %> <!-- 🔥 완전 삭제 -->
							<form
								action="<%=request.getContextPath()%>/board/review/adminDeleteForeverAction.jsp"
								method="post" style="display: inline;"
								onsubmit="return confirm('⚠️ 이 게시글은 완전히 삭제됩니다.\n복구할 수 없습니다.\n정말 삭제하시겠습니까?');">
								<input type="hidden" name="board_idx"
									value="<%=dto.getBoard_idx()%>">
								<button type="submit" class="btn btn-sm btn-dark">완전삭제</button>
							</form>
						</td>
						<% } %>
					</tr>
					<% } %>
				</tbody>
			</table>
		</div>
		<% if (!isAdmin) { %>
		<div class="write-btn">
			<% if (!isLogin) { %>
			<a href="javascript:void(0);" onclick="needLoginAlert()"> <i
				class="bi bi-pen"></i>&nbsp;리뷰 작성
			</a>
			<% } else { %>
			<a href="write.jsp"> <i class="bi bi-pen"></i>&nbsp;리뷰 작성
			</a>
			<% } %>
		</div>
		<% } %>
		<div class="page-wrap">
		  <ul class="page-list">
		
		    <%-- ◀ 이전 5페이지 --%>
		    <% if (startPage > 1) { %>
		    <li class="arrow">
		      <a href="list.jsp?page=<%=startPage - 1%>">&lt;</a>
		    </li>
		    <% } %>
		
		    <%-- 페이지 번호 5개씩 --%>
		    <% for (int i = startPage; i <= endPage; i++) { %>
		    <li class="<%= (i == currentPage) ? "active" : "" %>">
		      <a href="list.jsp?page=<%=i%>"><%= i %></a>
		    </li>
		    <% } %>
		
		    <%-- ▶ 다음 5페이지 --%>
		    <% if (endPage < totalPage) { %>
		    <li class="arrow">
		      <a href="list.jsp?page=<%=endPage + 1%>">&gt;</a>
		    </li>
		    <% } %>
		
		  </ul>
		</div>
	<script>
function needLoginAlert() {
    alert("로그인이 필요합니다.");
    $('#loginModal').modal('show');
}
</script>
	<script>
document.querySelectorAll('.review-link').forEach(link => {
    link.addEventListener('click', function (e) {
        e.preventDefault();

        const isSpoiler = this.dataset.spoiler === '1';
        const url = this.dataset.url;

        <% if (isAdmin) { %>
            location.href = url;
            return;
        <% } %>

        if (!isSpoiler) {
            location.href = url;
            return;
        }

        alertMove(
            '스포일러가 포함된 게시글입니다.\n그래도 열람하시겠습니까?',
            url
        );
    });
});
</script>

</body>
</html>