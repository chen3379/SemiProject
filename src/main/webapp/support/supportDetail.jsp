<%@page import="support.SupportAdminDto"%>
<%@page import="support.SupportAdminDao"%>
<%@page import="support.SupportDto"%>
<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	String loginId = (String)session.getAttribute("id");
	String roleType = (String)session.getAttribute("roleType");
	boolean isLogin = (loginId != null);
	boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

	int idx = Integer.parseInt(request.getParameter("idx"));
	SupportDao dao = new SupportDao();
	SupportDto dto = dao.getOneData(idx);
	
	// 삭제글
	if("1".equals(dto.getDeleteType())){
	  out.print("<script>alert('삭제된 글입니다');history.back();</script>");
	  return;
	}
	
	// 비밀글
	if("1".equals(dto.getSecretType())){
	  if(!isAdmin && !loginId.equals(dto.getId())){
	    out.print("<script>alert('접근 권한이 없습니다');history.back();</script>");
	    return;
	  }
	}
	
	dao.updateReadCount(idx);
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
<body>

	<h2><%=dto.getTitle()%></h2>
	<p><%=dto.getContent()%></p>
	
	<!-- 작성자만 수정/삭제 -->
	<% if(isLogin && loginId.equals(dto.getId())){ %>
	  <a href="supportForm.jsp?idx=<%=idx%>">수정</a>
	  <a href="action/supportDeleteAction.jsp?idx=<%=idx%>">삭제</a>
	<% } %>
	
	<!-- 관리자 답변 -->
	<%
	SupportAdminDao aDao = new SupportAdminDao();
	SupportAdminDto answer = aDao.getAdminAnswer(idx);
	%>
	
	<% if(isAdmin){ %>
	  <% if(answer == null){ %>
	    <form action="action/supportAnswerInsert.jsp" method="post">
	      <input type="hidden" name="idx" value="<%=idx%>">
	      <textarea name="content"></textarea>
	      <button>답변 등록</button>
	    </form>
	  <% } else { %>
	    <h3>관리자 답변</h3>
	    <p><%=answer.getContent()%></p>
	    <a href="action/supportAnswerDelete.jsp?idx=<%=idx%>">삭제</a>
	  <% } %>
	<% } %>
	
	<script type="text/javascript">
	
	</script>

</body>
</html>