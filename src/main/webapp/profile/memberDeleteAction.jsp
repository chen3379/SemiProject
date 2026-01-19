<%@page import="member.MemberDto"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
    String requestedId = request.getParameter("id");

    Object obj = session.getAttribute("memberInfo");
    MemberDto dto = (MemberDto) obj;
    String sessionId = dto.getId();
    MemberDao dao = new MemberDao();

    if(!requestedId.equals(sessionId)){
        %>
        <script>
            alert("잘못된 접근입니다.");
            history.back();
        </script>
<%  return; }

    int result = dao.deleteMember(requestedId);

    if (result > 0) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        session.invalidate();
%>
        <script>
            alert("회원 탈퇴가 완료되었습니다.");
            location.replace("../main/mainPage.jsp");
        </script>
<%
    } else {
%>
        <script>
            alert("처리 중 오류가 발생했습니다.");
            history.back();
        </script>
<%
    }
%>