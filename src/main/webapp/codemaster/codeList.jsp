<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<title>CodeList title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<head>
</head>
<%
	request.setCharacterEncoding("UTF-8");

	//그룹코드 조회groupCode
	CodeDao dao=new CodeDao();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	String groupCode=request.getParameter("groupCode");
	/* String groupName=request.getParameter("groupName"); */
	String currentPage=request.getParameter("currentPage");

	if(groupCode == null){
	    response.sendRedirect("../codemaster/groupList.jsp");
	    return;
	}
	//그룹명 조회
	CodeDao daog=new CodeDao();
	CodeDto dtog=daog.getGroup(groupCode);

	
	//dto가져오기
	List<CodeDto> list=dao.getCodeList(groupCode);
	int totalCount = list.size();

%>
<body>

<div  style="margin: 10px 30px; width: 900px; float:right;">
	<button type="button" class="btn btn-secondary" style="width:100px;"
		onclick="location.href='../codemaster/codeForm.jsp?groupCode=<%=groupCode %>'">코드등록</button>
	<button type="button" class="btn btn-secondary" style="width:100px;"
		onclick="location.href='../codemaster/groupList.jsp?groupCode=<%=groupCode %>'">그룹목록</button>
</div> 
	<input type="hidden" name="groupCode" value="<%=groupCode%>">
	<input type="hidden" name="groupName" value="<%=dtog.getGroup_name()%>">

<div style="margin: 10px 30px; width: 1000px;">
	<h5><b><%=totalCount %>개의 코드가 있습니다</b></h5>
	<table class="table table-bordered" style="width: 1200px;">
	<caption align="top"><b>그룹코드 : <%=groupCode %> &nbsp;&nbsp;&nbsp;    그룹명 : [ <%=dtog.getGroup_name() %>] </b></caption>
		<tr class="table-secondary" align="center">
<!-- 		    <th width="150">그룹코드</th>
		    <th width="480">그룹명</th>
 -->
		    <th width="150">코드ID</th>
		    <th width="280">코드명</th>
		    <th width="180">표기</th>
		    <th width="180">사용여부</th>
		    <th width="180">등록ID</th>
		    <th width="300">가입일</th>
		    <th width="180">수정ID</th>
		    <th width="300">수정일</th>
		    <th width="300">처리</th>
		</tr>
<%
    	if(totalCount==0){%>
	  	  <tr>
	  	    <td align="center" colspan="11">
	  	      <b>등록된 코드가 없습니다</b>
	  	    </td>
	  	  </tr>
    <%	}else{
				
		for(CodeDto dto:list)
		{%>
		<tr align="center">
<%-- 			<td><%=dto.getGroup_code() %></td>
			<td><%=dto.getGroup_name() %></td>
 --%>
			<td><%=dto.getCode_id() %></td>
			<td><%=dto.getCode_name() %></td>
			<td><%=dto.getSort_order() %></td>
			<td><%=dto.getUse_yn() %></td>
			<td><%=dto.getCreate_id() %></td>
			<td>
        		<%= dto.getCreate_day() != null 
            		? sdf.format(dto.getCreate_day()) : "-" %>
    		</td>
			<td><%= dto.getUpdate_id() != null ? dto.getUpdate_id() : "-" %></td>
			<td>
        		<%= dto.getUpdate_day() != null 
            		? sdf.format(dto.getUpdate_day()) : "-" %>
    		</td>
    		
			<td align="right">
			 	<!-- 수정 -->
				<button type="button" class="btn btn-outline-secondary"
				    onclick="location.href='../codemaster/codeUpdateForm.jsp?groupCode=<%=dto.getGroup_code()%>&codeId=<%=dto.getCode_id()%>'">

				<%-- <a href="../codemaster/codeUpdateForm.jsp?groupCode=<%=dto.getGroup_code()%>&codeId=<%=dto.getCode_id()%>" class="btn btn-outline-secondary">수정</a>
 --%>
				    수정
				</button>
    			
 				&nbsp;
 				
 				 <!-- 삭제 -->
	           <form action="../codemaster/codeDelete.jsp" method="post"
					style="display:inline;"
					onsubmit="return confirm('정말 삭제하시겠습니까?');">

					<input type="hidden" name="groupCode" value="<%=dto.getGroup_code()%>">
					<input type="hidden" name="codeId" value="<%=dto.getCode_id()%>">
					<input type="hidden" name="currentPage" value="<%=currentPage%>">
					
			        <button type="submit" class="btn btn-danger">삭제</button>
    		</form>
 	       </td>
		</tr>
		<%}
	}
%>
</table>
	
</div>

</body>
</html>

