<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	request.setCharacterEncoding("UTF-8");
	
	// 로그인 체크
	String id = (String)session.getAttribute("id");
	if(id == null){
	    out.print("{\"result\":\"NO_LOGIN\"}");
	    return;
	}
	
	// ===== 파라미터 받기  =====
	String supportIdxParam = request.getParameter("supportIdx");
	String categoryType = request.getParameter("categoryType");
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	int secretType = Integer.parseInt(request.getParameter("secret"));
	
	// supportIdx 필수 체크
	if(supportIdxParam == null || supportIdxParam.trim().equals("")){
	    out.print("{\"result\":\"FAIL\",\"msg\":\"NO_SUPPORT_IDX\"}");
	    return;
	}
	
	// categoryType 방어
	if(categoryType == null || categoryType.trim().equals("")){
	    categoryType = "2";
	}
	
	int supportIdx = Integer.parseInt(supportIdxParam);
	
	// ===== DAO =====
	SupportDao dao = new SupportDao();
	boolean success = dao.updateSupport(
	    supportIdx,
	    categoryType,
	    title,
	    content,
	    secretType
	);
	
	// ===== 응답 =====
	if(success){
	    out.print("{\"result\":\"OK\",\"supportIdx\":" + supportIdx + "}");
	}else{
	    out.print("{\"result\":\"FAIL\",\"msg\":\"UPDATE_ZERO\"}");
	}

%>