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
	
	List<FaqDto> faqList = fDao.getActiveFaq();
	List<SupportDto> list = sDao.getList(status, order, categoryType);
	
	String id = (String)session.getAttribute("id");
	
    boolean isLogin = (id != null);
    String roleType = isLogin ? new MemberDao().getRoleType(id) : null;

    System.out.println("SESSION roleType=" + roleType);

    boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));
    
	// 문의유형 필터 변수
	String categoryParam = request.getParameter("categoryType");
	
	// 필요업
	boolean canSeeSecret = false;
	
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
    /* [Core System] Design Tokens */
    :root {
        --primary-red: #E50914;
        --primary-red-hover: #B20710;
        --bg-main: #141414;
        --bg-surface: #181818;
        --bg-glass: rgba(20, 20, 20, 0.7);
        --border-glass: rgba(255, 255, 255, 0.1);
        --text-white: #FFFFFF;
        --text-gray: #B3B3B3;
        --text-muted: #666666;
        
        /* Layout Dimensions */
        --nav-height: 70px;
        --sidebar-width: 240px;
        
        /* Animation */
        --ease-spring: cubic-bezier(0.175, 0.885, 0.32, 1.275);
        --ease-smooth: cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    /* [Global Reset] */
    body {
        background-color: var(--bg-main);
        color: var(--text-white);
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
        overflow-x: hidden;
        margin: 0;
    }

    a { text-decoration: none; color: inherit; transition: color 0.2s; }
    ul { list-style: none; padding: 0; margin: 0; }

    /* [Layout System] Sticky Nav + Sidebar Grid */
    .app-container {
        display: grid;
        grid-template-columns: var(--sidebar-width) 1fr;
        min-height: 100vh;
        padding-top: var(--nav-height); /* Header 높이만큼 띄움 */
    }

    .main-content {
        padding: 40px 50px;
        min-width: 0; /* Grid overflow 방지 */
    }

    /* [Component] Section Headers (Movie & Community) */
    .content-section {
        margin-bottom: 60px;
        opacity: 0;
        animation: fadeInUp 0.6s var(--ease-smooth) forwards;
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }

    .section-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-white);
        letter-spacing: -0.5px;
    }

    .more-link {
        font-size: 0.9rem;
        color: var(--text-gray);
        display: flex;
        align-items: center;
        gap: 5px;
        transition: all 0.2s;
    }

    .more-link:hover {
        color: var(--text-white);
        transform: translateX(5px);
    }
    
    .more-link i { font-size: 0.8rem; }
    
    .table-hover tbody tr:hover {
	    background-color: rgba(255,255,255,0.08);
	}

    /* Animation Keyframes */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    /* Scrollbar Customization */
    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrollbar-track { background: var(--bg-main); }
    ::-webkit-scrollbar-thumb { background: #333; border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: #555; }

    /* 모바일 대응 (반응형) */
    @media (max-width: 768px) {
        .app-container { grid-template-columns: 1fr; }
        .sidebar-container { display: none; } /* 모바일에서 사이드바 숨김 (또는 햄버거 메뉴로 변경) */
        .main-content { padding: 20px; }
    }
    
    @media (max-width: 1200px) {
	    .app-container {
	        grid-template-columns: 1fr;
	    }
	}
    
    /* 사이드바 없는 페이지용 */
	.app-container.full {
	    grid-template-columns: 1fr;
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
            <div class="mb-4">
                <h5 class="mb-3">자주 묻는 질문</h5>
                <ul>
                <% for(FaqDto f : faqList){ %>
                    <li class="mb-2">
                        <strong><%=f.getTitle()%></strong><br>
                        <span class="text-muted"><%=f.getContent()%></span>
                    </li>
                <% } %>
                </ul>
            </div>

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
            <div class="table-responsive">
                <table class="table table-dark table-hover align-middle">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>문의유형</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>작성일</th>
                            <th>조회</th>
                            <% if(isAdmin){ %><th>상태</th><% } %>
                        </tr>
                    </thead>
                    <tbody>

                    <% for(SupportDto dto : list){ %>
                        <!-- 원글 -->
                        <tr style="cursor:pointer;" onclick="location.href='supportDetail.jsp?supportIdx=<%=dto.getSupportIdx()%>'">
                            <td><%=dto.getSupportIdx()%></td>
                            <td>
                                <%= "0".equals(dto.getCategoryType()) ? "회원정보" :
                                    "1".equals(dto.getCategoryType()) ? "신고" : "기타" %>
                            </td>
                            <td>
                                [<%=dto.getStatusType().equals("0")?"답변대기":"답변완료"%>]
                                <% if("1".equals(dto.getSecretType())){ %> 🔒 <% } %>
                                <a href="supportDetail.jsp?supportIdx=<%=dto.getSupportIdx()%>"
                                   class="text-white">
                                    <%=dto.getTitle()%>
                                </a>
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

                        <%
                        boolean showAnswer = false;
                        if("1".equals(dto.getStatusType())){
                            if("0".equals(dto.getSecretType())){
                                showAnswer = true;
                            } else if(isAdmin || (isLogin && id.equals(dto.getId()))){
                                showAnswer = true;
                            }
                        }
                        %>

						<% if("1".equals(dto.getStatusType())){ %>
						<tr class="bg-light"
						    style="cursor:pointer;"
						    onclick="handleAnswerClick('<%=dto.getSecretType()%>', '<%=dto.getId()%>', '<%=dto.getSupportIdx()%>')">
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