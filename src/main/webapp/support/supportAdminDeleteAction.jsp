<%@page import="support.SupportDao"%>
<%@page import="support.SupportAdminDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int supportIdx = Integer.parseInt(request.getParameter("supportIdx"));

SupportAdminDao aDao = new SupportAdminDao();
SupportDao sDao = new SupportDao();

aDao.deleteAdmin(supportIdx);
sDao.updateStatus(supportIdx, "0"); // 답변대기 되돌림

response.sendRedirect("supportDetail.jsp?supportIdx=" + supportIdx);
%>