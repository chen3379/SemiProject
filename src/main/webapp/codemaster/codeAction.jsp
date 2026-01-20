<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

//세션으로부터 아이디와 아이디저장 체크값 얻어오기
//String myid=(String)session.getAttribute("idok");

//엔코딩 (post방식은 한글이 깨진다:엔코딩일 필요)
request.setCharacterEncoding("utf-8");

String currentPage=request.getParameter("currentPage");

//입력폼데이타 
String groupCode= request.getParameter("groupCode");

/* String groupName= request.getParameter("groupName"); */

String codeId= request.getParameter("codeId");
String codeName= request.getParameter("codeName");

//필수값 체크
if (groupCode == null || codeId == null) {
%>
	<script>
    	alert("필수 값이 누락되었습니다.");
   		history.back();
	</script>
<%
    return;
}

//sortOrder 안전 처리
int sortOrder = 0;
String sortOrderParam = request.getParameter("sortOrder");
if (sortOrderParam != null && !sortOrderParam.trim().isEmpty()) {
    sortOrder = Integer.parseInt(sortOrderParam);
}

//useYn null 
String useYn= request.getParameter("useYn");
if (useYn == null) {
    useYn = "N";
}

String createId= "admin";
String updateId= "admin";

//그룹명 조회
CodeDao daog=new CodeDao();
CodeDto dtog=daog.getGroup(groupCode);


//dto 선언
CodeDto dto=new CodeDto();

//dto로 묶기
dto.setGroup_code(groupCode);
dto.setGroup_name(dtog.getGroup_name());
dto.setCode_id(codeId);
dto.setCode_name(codeName);
dto.setSort_order(sortOrder);
dto.setUse_yn(useYn);
dto.setCreate_id(createId);
dto.setUpdate_id(updateId);

//dto.setCreate_id(myid);  /*sessionID  */
//dto.setUpdate_id(myid);  /*sessionID  */

//dao 생성해주고 접근한다
CodeDao dao=new CodeDao();

if (dao.isCodeExists(groupCode, codeId)) 
{%>
    <script>
        alert("이미 존재하는 코드ID입니다.");
        history.back();
    </script>
<%
    return;
}
//insert 메서드 호출
dao.insertCode(dto);

//이동(gaipsuccess)
response.sendRedirect(
	    request.getContextPath() +
	    "/index.jsp?main=codemaster/codeList.jsp"
	    + "&groupCode=" + groupCode	    
	);
%>