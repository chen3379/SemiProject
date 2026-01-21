<%@page import="support.SupportDao"%>
<%@page import="support.SupportAdminDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <%
request.setCharacterEncoding("UTF-8");

String supportIdx = request.getParameter("supportIdx");
String content = request.getParameter("content");
String adminId = (String)session.getAttribute("id");

SupportAdminDao aDao = new SupportAdminDao();
SupportDao sDao = new SupportDao();

// 답변 등록
aDao.insertAdmin(Integer.parseInt(supportIdx),adminId,content);

// 원글 상태 변경 → 답변완료
sDao.updateStatus(Integer.parseInt(supportIdx), "1");

out.print("{\"result\":\"OK\"}");
%>