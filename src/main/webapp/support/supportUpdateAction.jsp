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

// 파라미터 받기
String supportIdxStr = request.getParameter("supportIdx");
int supportIdx = Integer.parseInt(supportIdxStr);
String categoryType = request.getParameter("categoryType");
String title = request.getParameter("title");
String content = request.getParameter("content");
String secret = request.getParameter("secret");

// 최소 방어
if(categoryType == null || categoryType.trim().equals("")){
    categoryType = "2"; // 기타
}
if(secret == null){
    secret = "0";
}

// DAO 호출
SupportDao dao = new SupportDao();
dao.updateSupport(supportIdx, categoryType, title, content, secretType);
%>
