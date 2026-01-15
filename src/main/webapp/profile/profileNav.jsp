<%@ page import="member.MemberDto" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<div class="nav-container">
    <h2>메뉴</h2>
    <ul>
        <% 
            Object obj = session.getAttribute("memberInfo");
            MemberDto member = null;
            
            if (obj != null) {
                member = (MemberDto) obj;
            }
        %>
        <% if (member != null) { %>
            <li>
                <a href="#" class="nav-link" data-page="memberProfile.jsp?id=${sessionScope.memberInfo.id}">
                    내 정보 보기
                </a>
            </li>
        <% } %>
        <% 
            if (member != null) {
                // DTO의 필드에 접근할 때는 반드시 getRoleType() 메서드를 호출해야 합니다.
                String roleType = member.getRoleType();
                
                if ("8".equals(roleType) || "9".equals(roleType)) { 
        %>
            <li><a href="#" class="nav-link" data-page="adminPanel.jsp">관리자 설정</a></li>
        <% 
                } 
            } 
        %>
    </ul>
</div>
