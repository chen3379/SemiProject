<%@page import="member.MemberDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="support.SupportAdminDto"%>
<%@page import="support.SupportAdminDao"%>
<%@page import="support.SupportDto"%>
<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String id = (String)session.getAttribute("id");
    boolean isLogin = (id != null);
    String roleType = isLogin ? new MemberDao().getRoleType(id) : null;
    boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

    String supportIdxStr = request.getParameter("supportIdx");
	//수정 오류 보완
    if(supportIdxStr == null || supportIdxStr.equals("undefined")){
        response.sendRedirect("supportList.jsp");
        return;
    }
    int supportIdx = Integer.parseInt(supportIdxStr);

    SupportDao dao = new SupportDao();
    SupportDto dto = dao.getOneData(supportIdx);

    // 글 없음(잘못된 번호 접근)
    if (dto == null) {
        out.print("<script>alert('존재하지 않는 글입니다');history.back();</script>");
        return;
    }

    // 삭제글
    if ("1".equals(dto.getDeleteType())) {
        out.print("<script>alert('삭제된 글입니다');history.back();</script>");
        return;
    }

    // 비밀글: 관리자 or 작성자만
    if ("1".equals(dto.getSecretType())) {
        boolean isWriter = isLogin && id.equals(dto.getId());
        if (!isAdmin && !isWriter) {
            out.print("<script>alert('비밀글 입니다');history.back();</script>");
            return;
        }
    }

    dao.updateReadCount(supportIdx);

    // 날짜 포맷
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    // 작성자 아이디 가공 (@앞만)
    String writerId = dto.getId();
    if (writerId != null && writerId.contains("@")) {
        writerId = writerId.substring(0, writerId.indexOf("@"));
    }

    // 문의 유형
    String ct = dto.getCategoryType();
    String categoryText = "기타";
	
	if (ct != null) {
	    ct = ct.trim();
	    if ("0".equals(ct)) categoryText = "회원정보";
	    else if ("1".equals(ct)) categoryText = "신고";
	}

    // 문의 상태
    String statusText = "답변대기";
    if ("1".equals(dto.getStatusType())) statusText = "답변완료";
    
    // 작성자, 관리자만 수정버튼 노출
    boolean canEdit = isLogin && (id.equals(dto.getId()) || isAdmin);
    
    
    
    
%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
</head>
<body class="container mt-4">

    <!-- 제목 + 유형 + 상태 -->
    <h3>
        <span class="badge bg-secondary"><%=categoryText%></span>
        <span class="badge <%= "답변완료".equals(statusText) ? "bg-success" : "bg-warning" %>">
            <%=statusText%>
        </span>
        <br class="d-md-none">
        <strong><%=dto.getTitle()%></strong>
    </h3>

    <!-- 작성자 / 작성일 / 조회수 -->
    <div class="text-muted mb-3">
        작성자 : <%=writerId%> |
        작성일 : <%=sdf.format(dto.getCreateDay())%> |
        조회수 : <%=dto.getReadcount()%>
    </div>

    <hr>

    <!-- 내용 -->
    <div class="mb-4">
        <pre style="white-space:pre-wrap;"><%=dto.getContent()%></pre>
    </div>

    <!-- 작성자 버튼 -->
    <% if (isAdmin||(isLogin && id.equals(dto.getId()))) { %>
        <div class="mb-3">
        	<% if(canEdit){ %>
            <a href="supportForm.jsp?supportIdx=<%=supportIdx%>" class="btn btn-outline-primary btn-sm">
                수정
            </a>
            <% } %>
            <a href="supportDeleteAction.jsp?supportIdx=<%=supportIdx%>"
               class="btn btn-outline-danger btn-sm"
               onclick="return confirm('정말 삭제하시겠습니까?');">
                삭제
            </a>
        </div>
    <% } %>

    <hr>

    <!-- 관리자 답변 -->
    <%
        SupportAdminDao aDao = new SupportAdminDao();
        SupportAdminDto answer = aDao.getAdminAnswer(supportIdx);
        
        // 답변 열람 권한 (원글 기준)
        boolean canSeeAnswer = false;

        // 비밀글 아님 → 누구나
        if ("0".equals(dto.getSecretType())) {
            canSeeAnswer = true;
        }
        // 비밀글 → 관리자 or 작성자
        else if (isAdmin || (isLogin && id.equals(dto.getId()))) {
            canSeeAnswer = true;
        }         
	%>
	
	<%-- ================== 관리자 전용 영역 ================== --%>
	<% if (isAdmin) { %>
	
	    <h5 class="mt-4">관리자 답변</h5>
	
	    <% if (answer == null) { %>
	        <!-- 답변 등록 -->
	        <form action="supportAdminInsertAction.jsp" method="post">
	            <input type="hidden" name="supportIdx" value="<%= supportIdx %>">
	
	            <div class="mb-2">
	                <textarea name="content"
	                          class="form-control"
	                          rows="4"
	                          placeholder="답변 내용을 입력하세요"></textarea>
	            </div>
	
	            <button type="submit" class="btn btn-success btn-sm">
	                답변 등록
	            </button>
	
	            <a href="supportList.jsp"
	               class="btn btn-outline-secondary btn-sm ms-2">
	                목록
	            </a>
	        </form>
	
	    <% } else { %>
	        <!-- 답변 수정/삭제 -->
	        <div class="border p-3 bg-light mb-2">
	            <pre style="white-space:pre-wrap;"><%= answer.getContent() %></pre>
	        </div>
	
	        <form action="supportAdminUpdateAction.jsp" method="post" class="d-inline">
	            <input type="hidden" name="supportIdx" value="<%= supportIdx %>">
	            <textarea name="content"
	                      class="form-control mb-2"
	                      rows="4"><%= answer.getContent() %></textarea>
	
	            <button class="btn btn-primary btn-sm">답변 수정</button>
	        
	
		        <a href="supportAdminDeleteAction.jsp?supportIdx=<%=supportIdx%>"
		           class="btn btn-outline-danger btn-sm ms-2"
		           onclick="return confirm('답변을 삭제하시겠습니까?');">
		            답변 삭제
		        </a>
		
		        <a href="supportList.jsp"
		           class="btn btn-outline-secondary btn-sm ms-2">
		            목록
		        </a>
	        </form>
	    <% } %>
	    
		<% } else if (answer != null && canSeeAnswer) { %>
		
		<%-- ================== 일반 사용자 열람 영역 ================== --%>
		    <h5 class="mt-4">관리자 답변</h5>
		    <div class="border p-3 bg-light">
		        <pre style="white-space:pre-wrap;"><%= answer.getContent() %></pre>
		    </div>	    

	<% } %>

</body>
</html>