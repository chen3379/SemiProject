<%@page import="member.MemberDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="support.SupportDto"%>
<%@page import="support.FaqDto"%>
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
	String order = request.getParameter("order");   // 최신/오래된순
	String categoryType = request.getParameter("categoryType");
	
	//List<FaqDto> faqList = fDao.getActiveFaq();
	
	//로그인 확인
	String id = (String)session.getAttribute("id");
	
    boolean isLogin = (id != null);
    String roleType = isLogin ? new MemberDao().getRoleType(id) : null;

    System.out.println("SESSION roleType=" + roleType);

    boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));
    
	// 문의유형 필터 변수
	String categoryParam = request.getParameter("categoryType");
	
	// 페이징
    // 전체 글 수
    int totalCount = sDao.getTotalCount(status, categoryType);

    int perPage = 5;      // ⭐ 한 페이지 5개
    int perBlock = 5;     // ⭐ 페이지 번호 5개씩
    int currentPage;

    if(request.getParameter("currentPage") == null)
        currentPage = 1;
    else
        currentPage = Integer.parseInt(request.getParameter("currentPage"));

    // 전체 페이지 수
    int totalPage = totalCount / perPage
            + (totalCount % perPage == 0 ? 0 : 1);

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
<title>WHATFLIX - Support</title>

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
    padding-top: 70px;
}

.main-content {
    padding: 40px 50px;
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

/* ===== 페이지네이션 ===== */
.page-wrap {
    display: flex;
    justify-content: center;
    margin: 40px 0;
}

.page-list {
    display: flex;
    align-items: center;
    gap: 14px;
    list-style: none;
    padding: 0;
    margin: 0;
}

.page-list li a {
    width: 36px;
    height: 36px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 50%;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
    color: #aaa;
}

.page-list li.active a {
    background: #e50914;
    color: #fff;
}

.page-list li.arrow a {
    font-size: 20px;
}

</style>


</head>
<body>

<jsp:include page="../main/nav.jsp" />
    <jsp:include page="../login/loginModal.jsp" />
    <jsp:include page="../profile/profileModal.jsp"/>

<div class="app-container full">

    <main class="main-content">

        <section class="content-section">

            <!-- 섹션 헤더 -->
            <div class="section-header">
                <h2 class="section-title">고객지원</h2>
            </div>

            <!-- FAQ 영역 -->
<%--             <div class="mb-4">
                <h5 class="mb-3">자주 묻는 질문</h5>
                <ul>
                <% for(FaqDto f : faqList){ %>
                    <li class="mb-2">
                        <strong><%=f.getTitle()%></strong><br>
                        <span class="text-muted"><%=f.getContent()%></span>
                    </li>
                <% } %>
                </ul>
            </div> --%>

            <!-- 필터 -->
            <form method="get" id="filterForm" class="d-flex gap-2 mb-4">
            
                <!-- 문의유형 필터 -->
                <select name="categoryType"
                        onchange="this.form.submit()"
                        class="form-select form-select-sm"
                        style="max-width:180px;">
                    <option value="">전체</option>
                    <option value="0" <%= "0".equals(categoryParam) ? "selected" : "" %>>회원정보</option>
                    <option value="1" <%= "1".equals(categoryParam) ? "selected" : "" %>>신고</option>
                    <option value="2" <%= "2".equals(categoryParam) ? "selected" : "" %>>기타</option>
                </select>

                <!-- 관리자 전용 답변상태 필터 -->
                <% if(isAdmin){ %>
                <select name="status"
                        onchange="this.form.submit()"
                        class="form-select form-select-sm"
                        style="max-width:160px;">
                    <option value="">답변상태 전체</option>
                    <option value="0" <%= "0".equals(status) ? "selected" : "" %>>답변대기</option>
                    <option value="1" <%= "1".equals(status) ? "selected" : "" %>>답변완료</option>
                </select>
                <% } %>

            </form>

            <!-- 문의글 목록 -->
            <div class="table-responsive support-table-wrap">
                <table class="table table-dark table-hover align-middle support-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>문의유형</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                            <th>조회수</th>
                            <% if(isAdmin){ %><th>답변상태</th><% } %>
                        </tr>
                    </thead>

					<tbody>
					
					<%
					int visibleCount = 0;   // 화면에 보여줄 "문의글" 수
					%>
					
					<% for(SupportDto dto : list){ %>
					
						<%-- 문의글 5개까지만 출력 --%>
					    <% if(visibleCount >= 5) break; %>
					
					    <%-- 삭제된 문의글 클릭 시 alert만 상세페이지 이동X --%>
					    <% if("1".equals(dto.getDeleteType())){ %>
					    
					    	<% visibleCount++; %>
					
					        <tr class="deleted-row"
					            onclick="event.stopPropagation(); alert('삭제된 글입니다');">
					            <td><%=dto.getSupportIdx()%></td>
					            <td colspan="<%= isAdmin ? 6 : 5 %>">
					                삭제된 문의글입니다
					            </td>
					        </tr>
					
					    <% } else { %>
					    
					    	<% visibleCount++; %>
					
					    <%-- 정상 문의글 --%>
					    <tr style="cursor:pointer;"
					        onclick="location.href='supportDetail.jsp?supportIdx=<%=dto.getSupportIdx()%>'">
					
					        <td><%=dto.getSupportIdx()%></td>
					
					        <td>
					            <%= "0".equals(dto.getCategoryType()) ? "회원정보" :
					                "1".equals(dto.getCategoryType()) ? "신고" : "기타" %>
					        </td>
					
					        <td class="title">
					            [<%= "0".equals(dto.getStatusType()) ? "답변대기" : "답변완료" %>]
					            <% if("1".equals(dto.getSecretType())){ %> 🔒 <% } %>
					            <span><%=dto.getTitle()%></span>
					        </td>
					
					        <td><%= dto.getId().split("@")[0] %></td>
					        <td><%=sdf.format(dto.getCreateDay())%></td>
					        <td><%=dto.getReadcount()%></td>
					
					        <% if(isAdmin){ %>
					        <td>
					            <span class="badge <%= "1".equals(dto.getStatusType()) ? "bg-success" : "bg-secondary" %>">
					                <%= "1".equals(dto.getStatusType()) ? "답변완료" : "답변대기" %>
					            </span>
					        </td>
					        <% } %>
					    </tr>
					
					    <% } %>
					
					    <%-- 관리자 답변 표시(답변완료 상태일 때만) --%>
					    <% if("0".equals(dto.getDeleteType()) && "1".equals(dto.getStatusType()) && visibleCount < 5 ){ %>
					
					        <tr class="bg-light"
					            style="cursor:pointer;"
					            onclick="
					                event.stopPropagation();
					                handleAnswerClick(
					                    '<%=dto.getSecretType()%>',
					                    '<%=dto.getId()%>',
					                    '<%=dto.getSupportIdx()%>'
					                );
					            ">
					
					            <td></td>
					            <td colspan="<%= isAdmin ? 6 : 5 %>" style="padding-left:30px;">
					                ㄴ <b>[답변완료] <%=dto.getTitle()%></b>
					            </td>
					        </tr>
					
					    <% } %>
					
					<% } %>
					
					</tbody>

                </table>
            </div>

            <!-- 글쓰기 -->
            <div class="mt-4 text-end">
            <% if(isLogin){ %>
                <a href="supportForm.jsp" class="btn btn-danger">문의하기</a>
            <% } else { %>
                <button class="btn btn-secondary"
                        onclick="alert('로그인 후 이용해주세요')">
                    문의하기
                </button>
            <% } %>
            </div>
            
            <!-- 페이징 -->
            <div class="page-wrap">
	    <ul class="page-list">
	
	    <%-- 이전 --%>
	    <% if(startPage > 1){ %>
	        <li class="arrow">
	            <a href="supportList.jsp?currentPage=<%=startPage-1%>
	            &status=<%=status==null?"":status%>
	            &categoryType=<%=categoryType==null?"":categoryType%>">
	                &lt;
	            </a>
	        </li>
	    <% } %>
	
	    <%-- 페이지 번호 --%>
	    <% for(int p = startPage; p <= endPage; p++){ %>
	        <% if(p == currentPage){ %>
	            <li class="active"><a href="#"><%=p%></a></li>
	        <% } else { %>
	            <li>
	                <a href="supportList.jsp?currentPage=<%=p%>
	                &status=<%=status==null?"":status%>
	                &categoryType=<%=categoryType==null?"":categoryType%>">
	                    <%=p%>
	                </a>
	            </li>
	        <% } %>
	    <% } %>
	
	    <%-- 다음 --%>
	    <% if(endPage < totalPage){ %>
	        <li class="arrow">
	            <a href="supportList.jsp?currentPage=<%=endPage+1%>
	            &status=<%=status==null?"":status%>
	            &categoryType=<%=categoryType==null?"":categoryType%>">
	                &gt;
	            </a>
	        </li>
	    <% } %>
	
	    </ul>
	</div>
            
            
            
            
            
            
            

        </section>

    </main>
    
    <script>
function handleAnswerClick(secretType, writerId, supportIdx){
    const isAdmin = <%= isAdmin %>;
    const isLogin = <%= isLogin %>;
    const loginId = "<%= isLogin ? id : "" %>";

    if(secretType === "1" && !(isAdmin || (isLogin && loginId === writerId))){
        alert("비밀글입니다");
        return;
    }

    location.href = "supportDetail.jsp?supportIdx=" + supportIdx;
}
</script>
    
</div>

</body>

</html>