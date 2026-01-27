<%@ page import="support.SupportDto" %>
<%@ page import="member.AdminDao" %>
<%@ page import="java.util.List" %>
<%@ page import="member.MemberDto" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // admin session check
    MemberDto member = (MemberDto) session.getAttribute("memberInfo");
    if (member == null || !("8".equals(member.getRoleType()) || "9".equals(member.getRoleType()))) {
        response.sendError(403, "관리자 권한이 필요합니다.");
        return;
    }

    String searchKeyword = request.getParameter("search");
    if (searchKeyword == null) searchKeyword = "";

    AdminDao dao = new AdminDao();
    List<SupportDto> qnaList = dao.getAllSupportListAdmin(searchKeyword);

    request.setAttribute("adminQnaList", qnaList);
    request.setAttribute("searchKeyword", searchKeyword);
%>
