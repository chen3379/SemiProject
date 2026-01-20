<%@page import="java.text.SimpleDateFormat"%>
<%@page import="support.SupportAdminDto"%>
<%@page import="support.SupportAdminDao"%>
<%@page import="support.SupportDto"%>
<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String id = (String)session.getAttribute("id");
    String roleType = (String)session.getAttribute("roleType");
    boolean isLogin = (id != null);
    boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

    int supportIdx = Integer.parseInt(request.getParameter("supportIdx"));

    SupportDao dao = new SupportDao();
    SupportDto dto = dao.getOneData(supportIdx);

    // 삭제글
    if ("1".equals(dto.getDeleteType())) {
        out.print("<script>alert('삭제된 글입니다');history.back();</script>");
        return;
    }

    // 비밀글
    if ("1".equals(dto.getSecretType())) {
        if (!isAdmin && !id.equals(dto.getId())) {
            out.print("<script>alert('접근 권한이 없습니다');history.back();</script>");
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
    <% if (isLogin && id.equals(dto.getId())) { %>
        <div class="mb-3">
            <a href="supportForm.jsp?supportIdx=<%=supportIdx%>" class="btn btn-outline-primary btn-sm">
                수정
            </a>
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
    %>

    <% if (isAdmin) { %>
        <% if (answer == null) { %>
            <!-- 답변 등록 -->
            <form action="supportInsertAction.jsp" method="post">
                <input type="hidden" name="supportIdx" value="<%=supportIdx%>">
                <div class="mb-2">
                    <label class="form-label">관리자 답변</label>
                    <textarea name="content" class="form-control" rows="4"></textarea>
                </div>
                <button class="btn btn-success btn-sm">답변 등록</button>
            </form>
        <% } else { %>
            <!-- 답변 출력 -->
            <h5 class="mt-3">관리자 답변</h5>
            <div class="border p-3 mb-2 bg-light">
                <pre style="white-space:pre-wrap;"><%=answer.getContent()%></pre>
            </div>
            <a href="supportDeleteAction.jsp?supportIdx=<%=supportIdx%>&admin=Y"
               class="btn btn-outline-danger btn-sm"
               onclick="return confirm('답변을 삭제하시겠습니까?');">
                답변 삭제
            </a>
        <% } %>
    <% } %>

</body>
</html>