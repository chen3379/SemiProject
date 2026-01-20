<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<title>Insert title here</title>
<style>
    .readonly-input {
        background-color: #f5f5dc !important; /* 연한 베이지 */
        color: #333 !important; /* 글자색 */
    }
</style>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<%

	String groupCode=request.getParameter("groupCode");
	if(groupCode == null){
	    response.sendRedirect("index.jsp?main=codemaster/groupList.jsp");
	    return;
	}
	String currentPage=request.getParameter("currentPage");
	
	CodeDao dao=new CodeDao();
	CodeDto dto=dao.getGroup(groupCode);
	
%>
</head>

<body>

<%
	//세션으로부터 로그인한 사람의 아이디 얻기  
	String id=(String)session.getAttribute("id");

	//로그인한 상태인지?
	String loginok=(String)session.getAttribute("loginStatus");
%>

<div style="margin: 30px 100px; width: 600px;">
	
<form action="codemaster/groupUpdateAction.jsp" method="post">
	<input type="hidden" name="groupCode" value="<%=groupCode%>">
	<input type="hidden" name="currentPage" value="<%=currentPage%>">
	
	<table class="table table-bordered">
		<tr>
		    <th>그룹코드</th>
		    <td>
		        <input type="text" name="Groupcode"
		               value="<%=dto.getGroup_code()%>"
		               readonly class="form-control readonly-input">
		    </td>
		</tr>
		
		<tr>
		    <th>그룹명</th>
		    <td>
		        <input type="text" name="GroupName"
		               value="<%=dto.getGroup_name()%>"
		               class="form-control">
		    </td>
		</tr>
		
		<tr>
		    <th>사용여부</th>
		    <td>
		        <select name="useYn" class="form-control">
					<option value="Y" <%= "Y".equals(dto.getUse_yn().trim()) ? "selected" : "" %>>사용</option>
					<option value="N" <%= "N".equals(dto.getUse_yn().trim()) ? "selected" : "" %>>미사용</option>
		        </select>
		    </td>
		</tr>

		<tr>
		    <td colspan="2" align="center">
		        <button type="submit" class="btn btn-secondary">수정</button>
		        <button type="button" class="btn btn-warning"
		            onclick="location.href='index.jsp?main=codemaster/groupList.jsp&currentPage=<%=currentPage%>'">
		            목록
		        </button>
		    </td>
		</tr>		
	</table>
</form>
	
</div>
</body>
</html>