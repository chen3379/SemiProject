<%@page import="support.SupportDao"%>
<%@page import="support.SupportAdminDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

String adminId = (String)session.getAttribute("id");
int supportIdx = Integer.parseInt(request.getParameter("supportIdx"));
String content = request.getParameter("content");

if(content == null || content.trim().isEmpty()){
    out.print("<script>alert('답변 내용을 입력하세요');history.back();</script>");
    return;
}

SupportAdminDao aDao = new SupportAdminDao();
SupportDao sDao = new SupportDao();

aDao.insertAdmin(supportIdx, adminId, content);
sDao.updateStatus(supportIdx, "1"); // 답변완료

response.sendRedirect("supportDetail.jsp?supportIdx=" + supportIdx);
%>