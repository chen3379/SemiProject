<%@page import="codemaster.CodeDao"%>
<%@page import="codemaster.CodeDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	// 파라미터 받기
	String groupCode = request.getParameter("Groupcode");
	String groupName = request.getParameter("GroupName");
	String useYn     = request.getParameter("useYn");
	String currentPage=request.getParameter("currentPage");

	// DTO 세팅 (★★★ 핵심 ★★★)
	CodeDto dto=new CodeDto();    
	dto.setGroup_code(groupCode);
	dto.setGroup_name(groupName);
	dto.setUse_yn(useYn);
	
    // DAO 선언
    CodeDao dao = new CodeDao();
		
	//update호출
	dao.updateGroup(dto);

	//이동(gaipsuccess)
	response.sendRedirect("../index.jsp?main=codemaster/groupList.jsp?currentPage="+currentPage);
	
%>