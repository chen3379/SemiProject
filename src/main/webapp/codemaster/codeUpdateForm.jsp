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
<title>코드 수정</title>
<style>
    .readonly-input {
        background-color: #f5f5dc !important; /* 연한 베이지 */
        color: #333 !important; /* 글자색 */
    }
</style>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<%
	request.setCharacterEncoding("UTF-8");

	String groupCode=request.getParameter("groupCode");
	String codeId=request.getParameter("codeId");
	String currentPage=request.getParameter("currentPage");

  /* 	if (groupCode == null || codeId == null) {
	    response.sendRedirect("../codemaster/codeList.jsp?groupCode="+ groupCode);
	    return;
	} */

	CodeDao dao=new CodeDao();
	CodeDto dto=dao.getCode(groupCode, codeId);
	
%>


<script type="text/javascript">
function check(f) {
    if (f.codeName.value.trim() === "") {
        alert("코드명을 입력하세요");
        f.codeName.focus();
        return false;
    }
    return true;
}

</script>
</head>

<body>

<div class="container mt-4" style="max-width:600px;">
	
<form action="../codemaster/codeUpdateAction.jsp" method="post" accept-charset="UTF-8" onsubmit="return check(this)">
    <input type="hidden" name="currentPage" value="<%=currentPage%>">
    
	<table class="table table-bordered">
	<caption align="top"><b>코드수정</b></caption>
        <tr>
            <th class="table-secondary">그룹코드</th>
            <td><input type="text" name="groupCode" value="<%=dto.getGroup_code()%>" readonly class="form-control readonly-input"></td>
        </tr>
        <tr>
            <th class="table-secondary">그룹명</th>
            <td><input type="text" name="groupName" value="<%=dto.getGroup_name()%>" readonly class="form-control readonly-input"></td>
        </tr>
        <tr>
            <th class="table-secondary">코드ID</th>
            <td><input type="text" name="codeId" value="<%=dto.getCode_id()%>" readonly class="form-control readonly-input"></td>
        </tr>
        <tr>
            <th class="table-secondary">코드명</th>
            <td><input type="text" name="codeName" value="<%=dto.getCode_name()%>" class="form-control" required></td>
        </tr>
        <tr>
            <th class="table-secondary">표기순서</th>
            <td><input type="number" name="sortOrder" value="<%=dto.getSort_order()%>" class="form-control" required></td>
        </tr>
        <tr>
            <th class="table-secondary">사용여부</th>
            <td>
                <select name="useYn" class="form-control">
                    <option value="Y" <%= "Y".equals(dto.getUse_yn())?"selected":"" %>>사용</option>
                    <option value="N" <%= "N".equals(dto.getUse_yn())?"selected":"" %>>미사용</option>
                </select>
            </td>
        </tr>
        
        <tr>
            <td colspan="2" class="text-center">
                <button type="submit" class="btn btn-primary">수정</button>
                <button type="button" class="btn btn-secondary"
                    onclick="location.href='../codemaster/codeList.jsp?groupCode=<%=dto.getGroup_code()%>&currentPage=<%=currentPage%>'">
                    목록
                </button>
            </td>
        </tr>
	</table>
</form>
	
</div>
</body>
</html>