<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String groupCode = request.getParameter("groupCode");
    String codeId = request.getParameter("codeId");
    String codeName = request.getParameter("codeName");
    String useYn = request.getParameter("useYn");
    String currentPage = request.getParameter("currentPage");
	
	int sortOrder = 0;
	try {
	    sortOrder = Integer.parseInt(request.getParameter("sortOrder"));
	} catch(Exception e){ 
		sortOrder = 0; 
	}
	
	//그룹명 조회
	CodeDao daog=new CodeDao();
	CodeDto dtog=daog.getGroup(groupCode);


	// DTO 세팅 (★★★ 핵심 ★★★)
	CodeDto dto=new CodeDto();
	
    dto.setGroup_code(groupCode);
    dto.setGroup_name(dtog.getGroup_name());
    dto.setCode_id(codeId);
    dto.setCode_name(codeName);
    dto.setSort_order(sortOrder);
    dto.setUse_yn(useYn);
    dto.setUpdate_id("admin");

    // DAO 선언
    CodeDao dao=new CodeDao();
	
	//update호출
	int result = dao.updateCode(dto);
	
	response.sendRedirect("../codemaster/codeList.jsp?groupCode="+ groupCode);
	
%>