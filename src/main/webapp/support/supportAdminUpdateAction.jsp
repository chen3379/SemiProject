<%@page import="support.SupportAdminDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

int supportIdx = Integer.parseInt(request.getParameter("supportIdx"));
String content = request.getParameter("content");

SupportAdminDao dao = new SupportAdminDao();
dao.updateAdmin(supportIdx, content);

response.sendRedirect("supportDetail.jsp?supportIdx=" + supportIdx);
%>