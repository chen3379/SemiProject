<%@page import="support.SupportAdminDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String supportIdx = request.getParameter("supportIdx");
String content = request.getParameter("content");

SupportAdminDao aDao = new SupportAdminDao();

// 답변 수정
aDao.updateAdmin(
    Integer.parseInt(supportIdx),
    content
);

out.print("{\"result\":\"OK\"}");
%>