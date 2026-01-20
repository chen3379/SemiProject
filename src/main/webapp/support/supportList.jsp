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
	
	MemberDao memberDao=new MemberDao();
	
	String id = (String)session.getAttribute("id");
	String roleType = memberDao.getRoleType(id);
	
	System.out.println("SESSION roleType=" + roleType);

	boolean isLogin = (id != null);
	boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));
	
	// 문의유형 필터 변수
	String categoryParam = request.getParameter("categoryType");
	
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

	<!-- FAQ 영역 -->
	<h3>자주 묻는 질문</h3>
	<ul>
	<% for(FaqDto f : faqList){ %>
	  <li><b><%=f.getTitle()%></b><br><%=f.getContent()%></li>
	<% } %>
	</ul>
	
	
	<form method="get" id="filterForm">
	
  	  <!-- 문의유형 필터 (전체 사용자) -->
	  <select name="categoryType" id="categoryType"
	          onchange="document.getElementById('filterForm').submit();">
	    <option value="">전체</option>
	    <option value="0" <%= "0".equals(categoryParam) ? "selected" : "" %>>회원정보</option>
	    <option value="1" <%= "1".equals(categoryParam) ? "selected" : "" %>>신고</option>
	    <option value="2" <%= "2".equals(categoryParam) ? "selected" : "" %>>기타</option>
	  </select>
	
	  <!-- 관리자 전용 답변상태 필터 -->
	  <% if(isAdmin){ %>
	    <select name="status" id="status"
	            onchange="document.getElementById('filterForm').submit();">
	      <option value="">답변상태 전체</option>
	      <option value="0" <%= "0".equals(status) ? "selected" : "" %>>답변대기</option>
	      <option value="1" <%= "1".equals(status) ? "selected" : "" %>>답변완료</option>
	    </select>
	  <% } %>
	
	</form>
	
	
	<!-- 문의글 목록 -->
	<table>
		<tr>
		  <th>No</th><th>문의유형</th><th>제목</th><th>작성자</th><th>작성일</th><th>조회</th>
		  <% if(isAdmin){ %><th>상태</th><% } %>
		</tr>
		
		<% for(SupportDto dto : list){ %>
		<tr>
		  <td><%=dto.getSupportIdx()%></td>
		  <td>
		    <% if("1".equals(dto.getDeleteType())){ %>
		      [삭제된 문의글입니다]
		    <% } else { %>

		      <%
			      String categoryText = "기타";
			      String ct = dto.getCategoryType();
			      if(ct != null){
			          if("0".equals(ct)) categoryText = "회원정보";
			          else if("1".equals(ct)) categoryText = "신고";
			          else if("2".equals(ct)) categoryText = "기타";
			      }
		      %>
		      [<%= categoryText %>]
		      [<%=dto.getStatusType().equals("0")?"답변대기":"답변완료"%>]
		      <% if("1".equals(dto.getSecretType())){ %> 🔒 <% } %>
		      <a href="supportDetail.jsp?supportIdx=<%=dto.getSupportIdx()%>">
		        <%=dto.getTitle()%>
		      </a>
		    <% } %>
		  </td>
		  <td><%= dto.getId().split("@")[0] %></td>
		  <td><%=sdf.format(dto.getCreateDay())%></td>
		  <td><%=dto.getReadcount()%></td>
		  <% if(isAdmin){ %>
		    <td><%=dto.getStatusType()%></td>
		  <% } %>
		</tr>
		<% } %>
	</table>
	
	<!-- 글쓰기 -->
	<% if(isLogin){ %>
		<button type="button" onclick="location.href='supportForm.jsp'">문의하기</button>
	<% } else { %>
	  <button onclick="alert('로그인 후 이용해주세요')">문의하기</button>
	<% } %>

</body>
</html>