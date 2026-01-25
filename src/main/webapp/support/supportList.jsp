<%@page import="member.MemberDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="support.SupportDto"%>
<%@page import="java.util.List"%>
<%@page import="support.FaqDao"%>
<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	SupportDao sDao = new SupportDao();
	FaqDao fDao = new FaqDao();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	String status = request.getParameter("status"); // 관리자만 사용
	String categoryType = request.getParameter("categoryType");
	
	//로그인 확인
	String id = (String)session.getAttribute("id");
    boolean isLogin = (id != null);
    String roleType = isLogin ? new MemberDao().getRoleType(id) : null;
    boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));
	
	// status 필터는 관리자만 가능
	if(!isAdmin){
	    status = null;
	}
	
	// 페이징
    // 전체 글 수
    int totalCount = sDao.getTotalCount(status, categoryType);

    int perPage = 5;      // 질문 5개/페이지
    int perBlock = 5;     // 페이지 번호 5개씩
    int currentPage = 1;

    if(request.getParameter("currentPage") != null){
        currentPage = Integer.parseInt(request.getParameter("currentPage"));
    }

    // 전체 페이지 수
    int totalPage = totalCount / perPage + (totalCount % perPage == 0 ? 0 : 1);

    // 페이지 보정
    if(totalPage == 0) totalPage = 1;
	if(currentPage > totalPage) currentPage = totalPage;
	if(currentPage < 1) currentPage = 1;
    
    // 블럭 시작 / 끝 페이지
	int startPage = (currentPage - 1) / perBlock * perBlock + 1;
	int endPage = startPage + perBlock - 1;
	if(endPage > totalPage) endPage = totalPage;

    // DB limit 시작 번호
    int startNum = (currentPage - 1) * perPage;

    // ⭐ 페이징 리스트
    List<SupportDto> list = sDao.getPagingList(startNum, perPage, status, categoryType);
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<title>WHATFLIX - 고객센터</title>

<style>
/* 기본 */
body {
    background-color: #141414;
    color: #ffffff;
    font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
    margin: 0;
}

a {
    text-decoration: none;
    color: inherit;
}

/* 레이아웃 */
.app-container {
    min-height: 100vh;
    padding-top: 0px;
}

.main-content {
    padding: 0px 50px;
}

/* 섹션 헤더 */
.section-header {
    margin-bottom: 24px;
    padding-bottom: 10px;
    border-bottom: 1px solid rgba(255,255,255,0.08);
}

.section-title {
    font-size: 1.6rem;
    font-weight: 700;
}

/* FAQ */
.text-muted {
    color: #aaaaaa !important;
}

/* 테이블 카드 */
.support-table-wrap {
    background: #1e1e1e;
    border-radius: 12px;
    padding: 16px;
}

.support-table {
    width: 100%;
    border-collapse: collapse;
}

.support-table th,
.support-table td {
    padding: 12px 10px;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    font-size: 14px;
    text-align: center;
}

.support-table th {
    color: #b3b3b3;
    font-weight: 600;
}

.support-table td.title {
    text-align: left;
}

.support-table td.title a {
    max-width: 520px;
    display: inline-block;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.support-table tbody tr:hover {
    background-color: rgba(255,255,255,0.07);
    cursor: pointer;
}

/* 삭제된 글 */
.deleted-row {
    color: #f28b82;
    background-color: rgba(229, 9, 20, 0.08);
    cursor: default;
}

.deleted-row:hover {
    background-color: rgba(229, 9, 20, 0.12);
}

/* 모바일 */
@media (max-width: 768px) {

    .main-content {
        padding: 20px;
    }

    .support-table thead {
        display: none;
    }

    .support-table,
    .support-table tbody,
    .support-table tr,
    .support-table td {
        display: block;
        width: 100%;
    }

    .support-table tr {
        margin-bottom: 12px;
        padding: 12px;
        border-radius: 8px;
        background: #1e1e1e;
        border: 1px solid rgba(255,255,255,0.15);
    }

    .support-table td {
        border: none;
        padding: 6px 0;
        text-align: left;
        font-size: 13px;
    }

    .support-table td::before {
        display: inline-block;
        width: 80px;
        font-weight: 600;
        color: #999;
    }

    .support-table td.category::before { content: "문의유형"; }
    .support-table td.title::before { content: "제목"; }
    .support-table td.writer::before { content: "작성자"; }
    .support-table td.date::before { content: "작성일"; }
    .support-table td.count::before { content: "조회수"; }
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

.page-list li a:hover {
    color: #fff;
}

.page-list li.active a {
    background-color: #e50914;
    color: #fff;
    box-shadow: 0 0 14px rgba(229, 9, 20, 0.7);
}

.page-list li.arrow a {
    font-size: 22px;
    color: #9e9e9e;
}

.page-list li.arrow a:hover {
    color: #fff;
}

/* supportList 가로 기준 */
.support-wrap {
    max-width: 1100px;
    margin: 0 auto;
}

/* 답변글 왼쪽 정렬 */
.answer-content {
  text-align: left !important;
  padding-left: 30px;   
}

/* faq 스타일 */
.faq-main {
    margin-top: 100px;
    margin-bottom: 10px;
    max-width: 900px;
    min-width: 550px;
}

.notice-area {
	margin-top: 50px;
}

.notice-list {
	border-top: 2px solid #333;
}

.notice-item {
	border-bottom: 1px solid #222;
}

/* 클릭하는 헤더 부분 */
.notice-header {
	background-color: #141414; /* 배경색 */
	padding: 20px 15px;
	cursor: pointer;
	display: flex;
	align-items: center;
	transition: background-color 0.2s;
	color: #e5e5e5;
}

.notice-header:hover {
	background-color: #1f1f1f; /* 호버 시 약간 밝게 */
}

.notice-title-text {
	flex-grow: 1; /* 제목이 공간 차지 */
	font-size: 1.1rem;
	font-weight: 500;
}

/* 화살표 아이콘 */
.toggle-icon {
	color: #888;
	transition: transform 0.3s ease;
}

/* 활성화(열림) 상태일 때 화살표 회전 */
.notice-header.active .toggle-icon {
	transform: rotate(180deg);
	color: #E50914; /* 넷플릭스 레드 포인트 */
}

/* 숨겨진 내용 부분 */
.notice-body {
	display: none; /* 기본 숨김 */
	background-color: #1f1f1f; /* 헤더보다 약간 밝은 배경 */
	padding: 25px 20px;
	color: #cccccc;
	font-size: 1rem;
	line-height: 1.6;
	border-top: 1px solid #333;
}

</style>


</head>
<body>

<jsp:include page="../main/nav.jsp" />
<jsp:include page="../login/loginModal.jsp" />
<jsp:include page="../profile/profileModal.jsp"/>

<!-- ===== 자주 묻는 질문 ===== -->
<div class="container faq-main">
	<div class="notice-area mt-5 mb-5">
		<h4 class="mb-3 fw-bold">
			<i class="bi bi-megaphone-fill text-danger"></i> 자주 묻는 질문 TOP 3
		</h4>
	
		<div class="notice-list">
			<div class="notice-item">
				<div class="notice-header">
					<span class="notice-title-text">Q1. 비밀글은 누가 볼 수 있나요?</span>
					 <i	class="bi bi-chevron-down toggle-icon"></i>
				</div>
				<div class="notice-body">
					<p>
					A.
					비밀글은 작성자 본인과 관리자만 확인할 수 있습니다.<br>
					다른 사용자는 목록에서는 제목만 확인 가능하며,
					내용을 클릭할 경우 접근 제한 안내가 표시됩니다.
					</p>
				</div>
			</div>
	
			<div class="notice-item">
				<div class="notice-header">
					<span class="notice-title-text"> Q2. 문의글에 답변은 언제 달리나요?</span>
					 <i	class="bi bi-chevron-down toggle-icon"></i>
				</div>
				<div class="notice-body">
					<p>
					A.
					문의글은 접수 순서대로 확인되며,
					보통 영업일 기준 1~2일 이내에 답변이 등록됩니다.<br>
					답변이 등록되면 상태가 **‘답변완료’**로 변경됩니다.
					</p>
				</div>
			</div>
	
			<div class="notice-item">
				<div class="notice-header">
					<span class="notice-title-text">Q3. 문의글 수정이나 삭제는 어떻게 하나요?</span>
					<i class="bi bi-chevron-down toggle-icon"></i>
				</div>
				<div class="notice-body">
					<p>
					A.
					문의글은 답변이 등록되기 전까지 수정 및 삭제가 가능합니다.<br>
					답변이 등록된 이후에는 내용 변경이 제한되며,
					추가 문의가 필요할 경우 새 문의글을 작성해 주세요.
					</p>
				</div>
			</div>
	
		</div>
	</div>
</div>

<div class="app-container full">

    <main class="main-content">

        <section class="content-section support-wrap">

            <!-- 섹션 헤더 -->
            <div class="section-header">
                <h2 class="section-title">고객센터</h2>
            </div>

            <!-- 필터 -->
            <form method="get" id="filterForm" class="d-flex gap-2 mb-4">
            
                <!-- 문의유형 필터 -->
                <select name="categoryType"
                        onchange="this.form.submit()"
                        class="form-select form-select-sm"
                        style="max-width:110px;">
                    <option value="">전체</option>
                    <option value="0" <%= "0".equals(categoryType) ? "selected" : "" %>>회원정보</option>
                    <option value="1" <%= "1".equals(categoryType) ? "selected" : "" %>>신고</option>
                    <option value="2" <%= "2".equals(categoryType) ? "selected" : "" %>>기타</option>
                </select>

                <!-- 관리자 전용 답변상태 필터 -->
                <% if(isAdmin){ %>
                <select name="status"
                        onchange="this.form.submit()"
                        class="form-select form-select-sm"
                        style="max-width:150px;">
                    <option value="">답변상태 전체</option>
                    <option value="0" <%= "0".equals(status) ? "selected" : "" %>>답변대기</option>
                    <option value="1" <%= "1".equals(status) ? "selected" : "" %>>답변완료</option>
                </select>
                <% } %>

            </form>

            <!-- 문의글 목록 -->
            <div class="support-table-wrap"> 
	                <table class="table table-dark table-hover align-middle support-table">
	                    <thead>
	                        <tr>
	                            <th>No</th>
	                            <th class="category">문의유형</th>
	                            <th class="title">제목</th>
	                            <th class="writer">작성자</th>
	                            <th class="date">작성일</th>
	                            <th class="count">조회수</th>
	                            <% if(isAdmin){ %><th>답변상태</th><% } %>
	                        </tr>
	                    </thead>
	
						<tbody>
						<%
						int maxRow = 10;      // 한 페이지에 보여줄 줄 수
						int rowCount = 0;   // 실제 화면에 출력된 줄 수)
						%>
						
						<% for(SupportDto dto : list){ %>
						
						    <%-- 1. 삭제된 문의글 --%>
						    <% if("1".equals(dto.getDeleteType())){ %>
						        <tr class="deleted-row" onclick="event.stopPropagation(); alert('삭제된 글입니다');">
						            <td><%=dto.getSupportIdx()%></td>
						            <td colspan="<%= isAdmin ? 6 : 5 %>">삭제된 문의글입니다</td>
						        </tr>
										
						    <% } else { %>
						
						        <%-- 2. 정상 문의글 --%>
						        <tr style="cursor:pointer;" onclick="
						            if('<%=dto.getSecretType()%>' === '1'
						                && '<%=dto.getId()%>' !== '<%=id%>'
						                && <%=!isAdmin%>){
						                alert('비밀글입니다');
						                return;
						            }
						            location.href='supportDetail.jsp?supportIdx=<%=dto.getSupportIdx()%>&currentPage=<%=currentPage%>';
						        ">
						            <td><%=dto.getSupportIdx()%></td>
						            <td>
						                <%= "0".equals(dto.getCategoryType()) ? "회원정보" :
						                    "1".equals(dto.getCategoryType()) ? "신고" : "기타" %>
						            </td>
						
						            <td class="title">
						                [<%= "0".equals(dto.getStatusType()) ? "답변대기" : "답변완료" %>]
						                <% if("1".equals(dto.getSecretType())){ %> 🔒 <% } %>
						                <span><%=dto.getTitle()%></span>
						
						                <% if("1".equals(dto.getStatusType())){ %>
						                    <div class="answer-content">ㄴ <b>[답변이 등록되었습니다]</b></div>
						                <% } %>
						            </td>
						
						            <td><%= dto.getId().split("@")[0] %></td>
						            <td><%=sdf.format(dto.getCreateDay())%></td>
						            <td><%=dto.getReadcount()%></td>
									
									 <%-- 관리자 답변글 --%>
						            <% if(isAdmin){ %>
						            <td>
						                <span class="badge <%= "1".equals(dto.getStatusType()) ? "bg-success" : "bg-secondary" %>">
						                    <%= "1".equals(dto.getStatusType()) ? "답변완료" : "답변대기" %>
						                </span>
						            </td>
						            <% } %>
						        </tr>
						
						    <% } %>
						<% } %>
						
						</tbody>

						
	                </table>
	                
	                <!-- 글쓰기 -->
		            <div class="mt-4 text-end">
		            <% if(isLogin && !isAdmin){ %>
		                <a href="supportForm.jsp" class="btn btn-danger">문의하기</a>
		            <% } else if (!isLogin) { %>
		                <button class="btn btn-secondary"
		                        onclick="alert('로그인 후 이용해주세요')">
		                    문의하기
		                </button>
		            <% } %>
		            </div>
	               
            </div>
            
            <!-- 페이징 -->
            <div class="page-wrap">
	    <ul class="page-list">
	
	    <%-- 이전 --%>
	    <% if(startPage > 1){ %>
	        <li class="arrow">
	            <a href="supportList.jsp?currentPage=<%=startPage-1%>&status=<%=status==null?"":status%>&categoryType=<%=categoryType==null?"":categoryType%>">&lt;</a>
	        </li>
	    <% } %>
	
	    <%-- 페이지 번호 --%>
	    <% for(int p = startPage; p <= endPage; p++){ %>
	        <% if(p == currentPage){ %>
	            <li class="active"><a href="#"><%=p%></a></li>
	        <% } else { %>
	            <li>
	                <a href="supportList.jsp?currentPage=<%=p%>&status=<%=status==null?"":status%>&categoryType=<%=categoryType==null?"":categoryType%>"><%=p%></a>
	            </li>
	        <% } %>
	    <% } %>
	
	    <%-- 다음 --%>
	    <% if(endPage < totalPage){ %>
	        <li class="arrow">
	            <a href="supportList.jsp?currentPage=<%=endPage+1%>&status=<%=status==null?"":status%>&categoryType=<%=categoryType==null?"":categoryType%>">&gt;</a>
	        </li>
	    <% } %>
	
	    </ul>
	</div>
        </section>

    </main>
    
</div>

	<script>
		$(document).ready(function() {
			// 공지사항 토글 기능
			$(".notice-header").click(function() {
				// 1. 클릭한 헤더의 바로 다음 요소(.notice-body)를 슬라이드 토글
				$(this).next(".notice-body").stop().slideToggle(300);

				// 2. 화살표 회전을 위해 active 클래스 토글
				$(this).toggleClass("active");

				// (선택사항) 다른 공지사항은 자동으로 닫고 싶다면 아래 주석 해제
				//$(".notice-header").not(this).removeClass("active");
				//$(".notice-header").not(this).next(".notice-body").slideUp(300);
				
			});
		});
	</script>

<jsp:include page="../main/footer.jsp" />
<jsp:include page="../common/customAlert.jsp" />

</body>

</html>