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

response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

String category = request.getParameter("category");
if (category == null) category = "all";

String pageParam = request.getParameter("page");

int pageSize = 5;
int currentPage = (pageParam == null) ? 1 : Integer.parseInt(pageParam);
int start = (currentPage - 1) * pageSize;

String loginId = (String) session.getAttribute("loginid");
boolean isLogin = (loginId != null);
String roleType=(String)session.getAttribute("roleType");
boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));


FreeBoardDao dao = new FreeBoardDao();
List<FreeBoardDto> list;

if (isAdmin) {
    list = dao.getAdminBoardList(category, start, pageSize);
} else {
    list = dao.getBoardList(category, start, pageSize);
}

int totalCount = dao.getTotalCount(category);
if (isAdmin) {
    totalCount = dao.getAdminTotalCount(category);
} else {
    totalCount = dao.getTotalCount(category);
}

int totalPage = (int)Math.ceil((double)totalCount / pageSize);

int pageBlock = 5; // 한 번에 보여줄 페이지 수

int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
int endPage = startPage + pageBlock - 1;

if (endPage > totalPage) {
 endPage = totalPage;
}

SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
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
	padding: 12px;
}

/* 메뉴 버튼 */
.category a {
	display: inline-block;
	padding: 6px 14px;
	border-radius: 999px;
	background: #2a2a2a;
	color: #d0d0d0;
	font-size: 14px;
	font-weight: 500;
	text-decoration: none;
	flex-shrink: 0;
}

/* 활성화 상태 */
.category a.active {
	background: #e50914;
	color: #ffffff;
	box-shadow: 0 0 10px rgba(229, 9, 20, 0.6);
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
	margin-top: 5px;
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
}

/* 기본 상태 */
.write-btn a {
	background: #e50914;
	color: #fff;
	padding: 10px 16px;
	border-radius: 6px;
	font-weight: 600;
	transition: background-color 0.2s ease;
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

/* ===== 페이지네이션 ===== */
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

<%
String msg = request.getParameter("msg");
%>

	<script>
<% if ("hidden".equals(msg)) { %>
    alert("숨김 처리되었습니다.");
<% } else if ("restored".equals(msg)) { %>
    alert("복구되었습니다.");
<% } %>
</script>

	<jsp:include page="/main/nav.jsp" />
	<jsp:include page="/login/loginModal.jsp" />

	<div class="container" style="padding-top: 80px;">
		<div class="review-header">
			<h2>
				🗨️ 자유게시판 <span>왓플릭스 유저들의 일상과 생각을 나누는 공간</span>
			</h2>
		</div>
		<!-- 카테고리 -->
		<div class="category-wrap">
			<div class="category">
				<a href="list.jsp?category=all"
					class="<%= "all".equals(category) ? "active" : "" %>"> 전체 </a> <a
					href="list.jsp?category=FREE"
					class="<%= "FREE".equals(category) ? "active" : "" %>"> 자유수다 </a> <a
					href="list.jsp?category=QNA"
					class="<%= "QNA".equals(category) ? "active" : "" %>"> 질문 / 추천
				</a>
			</div>
		</div>

		<!-- 게시글 목록 -->
		<div class="review-table-wrap">
			<table>
				<thead>
					<tr>
						<th>카테고리</th>
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
					<%
			    for (FreeBoardDto dto : list) {
			%>
					<tr>

						<td class="category"><%="FREE".equals(dto.getCategory_type()) ? "자유수다" : "질문/추천"%>
						</td>
						<td class="title">
							<% if (dto.isIs_spoiler_type()) { %> <span class="spoiler">[스포]</span>
							<% } %> <%-- 관리자 + 숨김 표시 --%> <% if (isAdmin && dto.getIs_deleted() == 1) { %>
							<span class="badge bg-danger">숨김</span> <% } %> <%-- 클릭 가능 여부 분기 --%>
							<% if (dto.getIs_deleted() == 1 && !isAdmin) { %> <span
							style="color: #777; cursor: not-allowed;"> <%= dto.getTitle() %>
						</span> <% } else { %> <a
							href="detail.jsp?board_idx=<%= dto.getBoard_idx() %>"> <%= dto.getTitle() %>
						</a> <% } %>
						</td>
						<td class="writer">
						    <%= isAdmin ? dto.getId() : dto.getNickname() %>
						</td>
						<td class="date"><%= sdf.format(dto.getCreate_day()) %></td>
						<td class="count"><%= dto.getReadcount() %></td>
						<% if (isAdmin) { %>
						<td>
							<% if (dto.getIs_deleted() == 0) { %>
							<form action="adminHideAction.jsp" method="post"
								style="display: inline;">
								<input type="hidden" name="board_idx"
									value="<%=dto.getBoard_idx()%>">
								<button type="submit" class="btn btn-sm btn-danger">숨김</button>
							</form> <% } else { %>
							<form action="adminRestoreAction.jsp" method="post"
								style="display: inline;">
								<input type="hidden" name="board_idx"
									value="<%=dto.getBoard_idx()%>">
								<button type="submit" class="btn btn-sm btn-secondary">복구</button>
							</form> <% } %>
							
							<form action="adminDeleteForeverAction.jsp" method="post"
					          style="display:inline;"
					          onsubmit="return confirm('⚠️ 이 게시글은 완전히 삭제됩니다.\n복구할 수 없습니다.\n정말 삭제하시겠습니까?');">
					        <input type="hidden" name="board_idx" value="<%=dto.getBoard_idx()%>">
					        <button type="submit" class="btn btn-sm btn-dark">완전삭제</button>
					    </form>
						</td>
						
						<% } %>
						
					</tr>
					<%
			    }
			%>
				</tbody>
			</table>
		</div>
		<% if (!isAdmin) { %>
		<div class="write-btn">
			<% if (!isLogin) { %>
			<!-- 비회원 -->
			<a href="javascript:void(0);" onclick="needLoginAlert()"> <i
				class="bi bi-pen"></i>&nbsp;글쓰기
			</a>
			<% } else { %>
			<!-- 로그인 회원 -->
			<a href="write.jsp"> <i class="bi bi-pen"></i>&nbsp;글쓰기
			</a>
			<% } %>
		</div>
		<% } %>
		<div class="page-wrap">
		  <ul class="page-list">
		
		    <%-- ◀ 이전 5페이지 --%>
		    <% if (startPage > 1) { %>
		    <li class="arrow">
		      <a href="list.jsp?category=<%=category%>&page=<%=startPage - 1%>">
		        &lt;
		      </a>
		    </li>
		    <% } %>
		
		    <%-- 페이지 번호 5개씩 --%>
		    <% for (int i = startPage; i <= endPage; i++) { %>
		    <li class="<%= (i == currentPage) ? "active" : "" %>">
		      <a href="list.jsp?category=<%=category%>&page=<%=i%>">
		        <%= i %>
		      </a>
		    </li>
		    <% } %>
		
		    <%-- ▶ 다음 5페이지 --%>
		    <% if (endPage < totalPage) { %>
		    <li class="arrow">
		      <a href="list.jsp?category=<%=category%>&page=<%=endPage + 1%>">
		        &gt;
		      </a>
		    </li>
		    <% } %>
		
		  </ul>
		</div>
		<script>
	function needLoginAlert() {
	    alert("로그인이 필요합니다.", function() {
	    $('#loginModal').modal('show');			
		});
	}
	</script>
		<script>
	window.addEventListener("pageshow", function (event) {
	    if (event.persisted) {
	        // 뒤로가기(bfcache)로 복원된 경우
	        location.reload();
	    }
	});
	</script>
	</div>
</body>
<footer>
<jsp:include page="/main/footer.jsp"/>
</footer>
</html>