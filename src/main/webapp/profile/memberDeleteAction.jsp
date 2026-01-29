<%@page import="member.MemberDto"%>
<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:include page="../common/customAlert.jsp"/>
<%
    String requestedId = request.getParameter("id");
    String password = request.getParameter("password");

    Object obj = session.getAttribute("memberInfo");
    
    // 세션 정보가 없는 경우 예외 처리
    if (obj == null) {
        response.sendRedirect("../main/mainPage.jsp");
        return;
    }
    
    MemberDto dto = (MemberDto) obj;
    String sessionId = dto.getId();
    MemberDao dao = new MemberDao();

    // 1. 접근 권한 확인
    if(!requestedId.equals(sessionId)){
%>
        <script>
            // 잘못된 접근 시 알림 후 뒤로가기 (콜백 사용)
            alert("잘못된 접근입니다.", function() {
                history.back();
            });
        </script>
<%  
        return; 
    }

    // 2. 비밀번호 확인 (소셜 로그인 사용자가 아닐 경우에만)
    String joinType = dto.getJoinType();
    boolean isSocial = (joinType != null && !joinType.isEmpty());

    if (!isSocial && !dao.checkPassword(sessionId, password)) {
%>
        <script>
            // 비밀번호 불일치 시 알림 후 뒤로가기 (콜백 사용)
            alert("비밀번호가 일치하지 않습니다.", function() {
                history.back();
            });
        </script>
<%
        return;
    }

    // 3. 회원 탈퇴 처리
    int result = dao.deleteMember(requestedId);

    if (result > 0) {
        // 탈퇴 성공 시 세션 무효화 및 캐시 삭제
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        session.invalidate();
%>
        <script>
            // 탈퇴 완료 알림 후 메인 이동 (콜백 사용)
            alert("회원 탈퇴가 완료되었습니다.", function() {
                location.replace("../main/mainPage.jsp");
            });
        </script>
<%
    } else {
%>
        <script>
            // DB 처리 오류 시 알림 후 뒤로가기 (콜백 사용)
            alert("처리 중 오류가 발생했습니다.", function() {
                history.back();
            });
        </script>
<%
    }
%>
