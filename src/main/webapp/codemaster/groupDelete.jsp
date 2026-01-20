<%@page import="codemaster.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	//groupCode
	String groupCode = request.getParameter("groupCode");
	//현재 페이지
	String currentPage=request.getParameter("currentPage");
	
	if (groupCode != null && !groupCode.equals("")) {
		//dao 생성하고 읽기
		CodeDao dao = new CodeDao();
		
		//delete 메서드 호출
		dao.deleteGroup(groupCode); // DAO 삭제 메서드
	}
	response.sendRedirect("../index.jsp?main=codemaster/groupList.jsp?currentPage="+currentPage);
	//response.sendRedirect("index.jsp?main=codemaster/groupList.jsp?currentPage="+currentPage);

%>