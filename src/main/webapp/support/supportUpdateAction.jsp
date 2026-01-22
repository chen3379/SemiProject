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

// 파라미터 받기
int supportIdx = Integer.parseInt(request.getParameter("supportIdx"));
String categoryType = request.getParameter("categoryType");
String title = request.getParameter("title");
String content = request.getParameter("content");
String secret = request.getParameter("secret");
String secretType = request.getParameter("secret") == null ? "0" : "1";

// 최소 방어
if(categoryType == null || categoryType.trim().equals("")){
    categoryType = "2"; // 기타
}
if(secret == null){
    secret = "0";
}

// DAO 호출
SupportDao dao = new SupportDao();
dao.updateSupport(supportIdx, title, content, secretType);

%>
