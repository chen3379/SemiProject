<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

// 로그인 체크
String id = (String)session.getAttribute("id");
if(id == null){
    out.print("{\"result\":\"NO_LOGIN\"}");
    return;
}

// 파라미터
String categoryType = request.getParameter("categoryType");
String title = request.getParameter("title");
String content = request.getParameter("content");
int secretType = Integer.parseInt(request.getParameter("secret"));

// 최소 방어
if(categoryType == null || categoryType.trim().equals("")){
    categoryType = "2";
}

SupportDao dao = new SupportDao();
boolean success = dao.insertSupport(
	    categoryType,
	    title,
	    content,
	    id,
	    secretType
	);

if(success){
    out.print("{\"result\":\"OK\"}");
}else{
    out.print("{\"result\":\"FAIL\"}");
}
%>
