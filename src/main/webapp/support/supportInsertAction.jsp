<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String id = (String)session.getAttribute("id");
if(id == null){
    out.print("{\"result\":\"NO_LOGIN\"}");
    return;
}

String supportIdxStr = request.getParameter("supportIdx");
String categoryType = request.getParameter("categoryType");
String title = request.getParameter("title");
String content = request.getParameter("content");
String secret = request.getParameter("secret");

SupportDao dao = new SupportDao();

if(supportIdxStr == null || supportIdxStr.trim().equals("")){
    // ===== 등록 =====
    dao.insertSupport(categoryType, title, content, id, secret);
} else {
    // ===== 수정 =====
    int supportIdx = Integer.parseInt(supportIdxStr);
    dao.updateSupport(supportIdx, title, content);
}

out.print("{\"result\":\"OK\"}");
%>