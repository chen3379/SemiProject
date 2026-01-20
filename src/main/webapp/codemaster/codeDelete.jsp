<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	//groupCode
	String groupCode = request.getParameter("groupCode");

	//CodeId
	String codeId = request.getParameter("codeId");
	
	//현재 페이지
	String currentPage=request.getParameter("currentPage");
	
	// 필수값 체크
	if (groupCode == null || codeId == null) {
	%>
	<script>
	    alert("삭제할 정보가 올바르지 않습니다.");
	    history.back();
	</script>
	<%
    	return;
	}

	//dao 생성하고 읽기
	CodeDao dao = new CodeDao();

	//그룹명 조회
	CodeDto dto=dao.getGroup(groupCode);

	
	// DAO 삭제 메서드
	// 삭제 실행 (삭제 성공 여부 리턴받는 게 이상적)
	int result=dao.deleteCode(groupCode, codeId);		
	 
	//보던페이지로 이동하되 현재페이지로
	response.sendRedirect("../index.jsp?main=codemaster/codeList.jsp&groupCode="+ groupCode);

%>