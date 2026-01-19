<%@ page import="member.MemberDto" %> 
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<style>

    ul {
        list-style: none;
    }
</style>
<div class="nav-container">
    <hr>
    <ul>
        <% 
            Object obj = session.getAttribute("memberInfo");
            MemberDto member = null;
            
            if (obj != null) {
                member = (MemberDto) obj;
            }
        %>
            <li>
                <a href="#" class="nav-link" onclick="location.href = 'profilePage.jsp?id=${sessionScope.memberInfo.id}'">
                    회원정보
                </a>
            </li>
        <% 
            if (member != null) {
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
