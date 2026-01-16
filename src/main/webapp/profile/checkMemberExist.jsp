<%@page import="member.ProfileDao"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String id = request.getParameter("id");
    ProfileDao profileDao = new ProfileDao();
    boolean isExist = profileDao.checkId(id);

    if (isExist) {
        response.sendRedirect("profilePage.jsp?id=" + id);
    } else {
        out.println("<script>alert('존재하지 않는 사용자입니다.'); history.back();</script>");
    }
%>