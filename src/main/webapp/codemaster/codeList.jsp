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
	List<CodeDto> groupList = dao.getGroupList();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	String groupCode=request.getParameter("groupCode");
	String currentPage=request.getParameter("currentPage");
	
	CodeDto dtog = null;
	List<CodeDto> list = null;
	
	int totalCount = 0;
	
	if(groupCode != null && !groupCode.equals("")){
	    dtog = dao.getGroup(groupCode);
	    list = dao.getCodeList(groupCode);
	    totalCount = list.size();
	}

%>
<body>
 
<div class="container-fluid mt-3">
  <!-- 상단 버튼 -->
    <div class="row mb-3">
        <div class="col text-end">
            <button class="btn btn-secondary me-2"
                onclick="location.href='../codemaster/codeForm.jsp?groupCode=<%=groupCode%>'">
                코드등록
            </button>
            <button class="btn btn-secondary"
                onclick="location.href='../codemaster/groupList.jsp'">
                그룹목록
            </button>
        </div>
    </div>

  <!-- 그룹 선택 -->
    <div class="row mb-3">
        <div class="col-md-4 col-12">
            <form method="get" action="../codemaster/codeList.jsp">
                <select name="groupCode"
                        class="form-select"
                        onchange="this.form.submit()">
                    <% for (CodeDto g : groupList) {
                        String selected = g.getGroup_code().equals(groupCode) ? "selected" : "";
                    %>
                        <option value="<%=g.getGroup_code()%>" <%=selected%>>
                            <%=g.getGroup_code()%> [ <%=g.getGroup_name()%> ]
                        </option>
                    <% } %>
                </select>
            </form>
        </div>
    </div>
     <h5 class="fw-bold"><%=totalCount %>개의 코드가 있습니다</h5>
	<!-- 테이블 -->
	<div class="table-responsive">
	<table class="table table-bordered align-middle text-center">
	  <caption class="caption-top fw-bold">
		그룹코드 :	<%= groupCode != null ? groupCode : "-" %>
		&nbsp;&nbsp;
		그룹명 :	[ <%= dtog != null ? dtog.getGroup_name() : "선택하세요" %> ]
	</caption>
		
	<tr class="table-secondary" align="center">
	    <th>코드ID</th>
	    <th>코드명</th>
	    <th>표기</th>
	    <th>사용여부</th>
        <th>등록ID</th>
        <th>가입일</th>
        <th>수정ID</th>
        <th>수정일</th>
 		<th>처리</th>        
	    
	</tr>
<%
	if(groupCode == null || groupCode.equals("") || list == null){
		%>
		<tr>
		    <td colspan="9"><b>그룹을 선택하세요</b></td>
		</tr>
		<%
	}else if(totalCount == 0){
		%>
		<tr>
		    <td colspan="9"><b>등록된 코드가 없습니다</b></td>
		</tr>
	<%}else{
					
		for(CodeDto dto:list)
		{%>
			<tr align="center">
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
						수정
					</button>
	    			
	 				
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
</div>

</body>
</html>

