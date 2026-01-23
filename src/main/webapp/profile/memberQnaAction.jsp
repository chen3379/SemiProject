<%@page import="support.SupportAdminDao"%>
<%@ page import="support.SupportDto" %>
<%@ page import="support.SupportDao" %>
<%@ page import="java.util.List" %>
<%@ page import="member.MemberDto" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // session check
    MemberDto member = (MemberDto) session.getAttribute("memberInfo");
    if (member == null) {
        response.sendError(403, "로그인이 필요합니다.");
        return;
    }
    String id = member.getId();

    SupportAdminDao dao = new SupportAdminDao();
    List<SupportDto> qnaList = dao.getListById(id);

    request.setAttribute("userQnaList", qnaList);
%>
