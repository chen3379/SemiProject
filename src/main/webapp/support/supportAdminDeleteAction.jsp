<%@page import="support.SupportDao"%>
<%@page import="support.SupportAdminDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String supportIdx = request.getParameter("supportIdx");

SupportAdminDao aDao = new SupportAdminDao();
SupportDao sDao = new SupportDao();

// 답변 삭제
aDao.deleteAnswer(Integer.parseInt(supportIdx));

// 원글 상태 되돌리기 → 답변대기
sDao.updateStatus(Integer.parseInt(supportIdx), "0");

out.print("{\"result\":\"OK\"}");
%>