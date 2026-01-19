<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.GuestDao" %>
<% 
	Object statusObj = session.getAttribute("loginStatus");
    String loginStatus = (statusObj != null) ? statusObj.toString() : "false";
	
	if(!"true".equals(loginStatus)) {
		if (session.getAttribute("guestUUID") == null) {
            GuestDao guestDao = new GuestDao();

            String newGuestUUID = guestDao.createGuestUUID(); 
			guestDao.insertGuest(newGuestUUID);
			
            session.setAttribute("guestUUID", newGuestUUID);
            session.setAttribute("roleType", "0");
        }
	}
%>
<nav>
	<div>
		<h1>WHATFLIX</h1>
		<ul>
			<li><a href="../main/mainPage.jsp">홈</a></li>
			<li><a href="../movie/movieList.jsp">영화</a></li>
			<li><a href="../community/community.jsp">커뮤니티</a></li>
			<li><a href="../support/support.jsp">지원</a></li>

			<% 
			if ("true".equals(loginStatus)) {
			%>
			<li><a href="#" id="openProfile" data-bs-toggle="modal"
				data-bs-target="#profileModal">프로필</a></li>
			<li><form action="../login/logoutAction.jsp" method="post">
			<button id="navLogoutBtn" type="submit">로그아웃</button></form></li>
			<% } else { 
				%>
			<li><a href="#" id="openLoginModal" data-bs-toggle="modal"
				data-bs-target="#loginModal">로그인</a></li>
			<li><a href="../signUp/signUpPage.jsp" id="openSignUpPage">회원가입</a></li>
			<% } %>

			<li><a href="../main/sessionCheck.jsp">세션 확인</a></li>
		</ul>
	</div>
</nav>

