<%@page import="codemaster.CodeDao"%>
<%@page import="codemaster.CodeDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	//세션으로부터 아이디와 아이디저장 체크값 얻어오기
	//String myid=(String)session.getAttribute("idok");
	request.setCharacterEncoding("utf-8");

	//데이타 읽어서 dto에  넣기
	CodeDto dto=new CodeDto();
	
	String groupCode= request.getParameter("Groupcode");
	String groupName= request.getParameter("GroupName");
	String useYn= request.getParameter("useYn");
	String myid= "admin";
	
	dto.setGroup_code(groupCode);
	dto.setGroup_name(groupName);
	dto.setUse_yn(useYn);
	dto.setCreate_id(myid);  
	//dto.setCreate_id(myid);  /*sessionID  */

	//dao선언후에 insert메서드 호출
	CodeDao dao=new CodeDao();
	dao.insertGroup(dto);

	//이동(gaipsuccess)
	response.sendRedirect("../codemaster/groupList.jsp");

%>