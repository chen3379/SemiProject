<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.AdminDao" %>
<%@ page import="member.MemberDto" %>
<%@ page import="java.util.List" %>

<%
    AdminDao dao = new AdminDao();
    String search = request.getParameter("search");
    String sort = request.getParameter("sort");
    if(sort == null) sort = "latest"; // 기본 정렬값 설정
    
    List<MemberDto> list;

    if (search != null && !search.trim().isEmpty()) {
        list = dao.selectSearchMembers(search); 
    } else {
        // [중요] 파라미터 sort를 꼭 넘겨주어야 합니다.
        list = dao.selectAllMemberbyId(sort);
    }

    request.setAttribute("memberList", list);
    request.setAttribute("totalCount", list.size());
    request.setAttribute("sortOrder", sort);
%>

