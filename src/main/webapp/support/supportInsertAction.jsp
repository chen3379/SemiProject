<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String id = (String)session.getAttribute("id");
String categoryType = request.getParameter("categoryType");
String title = request.getParameter("title");
String content = request.getParameter("content");
String secret = request.getParameter("secret");

if(categoryType == null || title == null || content == null ||
   title.trim().isEmpty() || content.trim().isEmpty()){
    out.print("{\"result\":\"FAIL\"}");
    return;
}

SupportDao dao = new SupportDao();
dao.insertSupport(categoryType, title, content, id, secret);

out.print("{\"result\":\"OK\"}");
%>