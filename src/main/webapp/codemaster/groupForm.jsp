<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<%
	//프로젝트의 경로
	String root=request.getContextPath();
%>
</head>
<body>
<div>
	<form action="codemaster/groupAdd.jsp" method="post" onsubmit="return check(this)">

	<table class="table table-bordered" style="width: 500px; margin-left: 100px;"> 
	<caption align="top"><b>그룹등록</b></caption>
		<tr>
			<th width="100" class="table-secondary">그룹코드</th>
			<td align="left">
				<input type="text" name="Groupcode"  class="form-control"
					required="required" style="width: 200px;">			
			</td>
		</tr>	    
		<tr>
			<th width="100" class="table-secondary">그룹명</th>
			<td>
				<input type="text" name="GroupName"  class="form-control"
					required="required" style="width: 200px;">			
			</td>
		</tr>
		<tr>
		    <th width="100" class="table-secondary">사용여부</th>
		    <td>
		        <select name="useYn" class="form-control" required style="width: 200px;">
		            <option value="Y">사용</option>
		            <option value="N">미사용</option>
		        </select>
		    </td>
		</tr>	    
    	<tr>
			<td align="center" colspan="2">
				<button type="submit" class="btn btn-secondary"
				style="width: 100px;">저장하기</button>
				
				<button type="reset" class="btn btn-secondary"
				style="width: 100px;">초기화</button>
				
				<button type="button" class="btn btn-warning"
					style="width: 120px;"
					onclick="location.href='index.jsp?main=codemaster/groupList.jsp'">목록</button>

			</td>		
		</tr>
	</table>
	</form>
</div>
</body>
</html>