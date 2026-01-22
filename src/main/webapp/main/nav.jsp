<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="member.GuestDao"%>
<%
Object statusObj = session.getAttribute("loginStatus");
String loginStatus = (statusObj != null) ? statusObj.toString() : "false";

if (!"true".equals(loginStatus)) {
    if (session.getAttribute("guestUUID") == null) {
        GuestDao guestDao = new GuestDao();
        String newGuestUUID = guestDao.createGuestUUID();
        guestDao.insertGuest(newGuestUUID);
        session.setAttribute("guestUUID", newGuestUUID);
        session.setAttribute("roleType", "0");
    }
}
%>

<style>
/* Navbar 전용 CSS (이 파일에 포함되어야 어디서든 적용됨) */
:root {
	--nav-height: 70px;
	--primary-red: #E50914;
	--text-white: #FFFFFF;
	--text-gray: #B3B3B3;
}

.global-nav {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: var(--nav-height);
	background: rgba(20, 20, 20, 0.85); /* 반투명 배경 */
	backdrop-filter: blur(12px); /* 유리 효과 */
	-webkit-backdrop-filter: blur(12px);
	border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	z-index: 1000; /* 항상 최상단 */
	display: flex;
	align-items: center;
	padding: 0 4%; /* 좌우 여백 반응형 */
	transition: background 0.3s;
}

.nav-content {
	width: 100%;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

/* [수정] 로고 이미지 스타일 */
.brand-logo-link {
	display: flex;
	align-items: center;
	margin-right: 40px;
	text-decoration: none;
}

.brand-logo-img {
	height: 38px; /* 네비게이션 높이에 맞게 조절 */
	width: auto; /* 비율 유지 */
	/* 텍스트의 text-shadow 대신 이미지용 그림자 필터 사용 */
	filter: drop-shadow(0 0 8px rgba(229, 9, 20, 0.6));
	transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.brand-logo-link:hover .brand-logo-img {
	transform: scale(1.08); /* 호버 시 살짝 커지는 효과 */
	filter: drop-shadow(0 0 12px rgba(229, 9, 20, 0.9)); /* 빛이 더 강해짐 */
}

.nav-links {
	display: flex;
	gap: 30px;
	list-style: none;
	margin: 0;
	padding: 0;
}

.nav-item {
	font-size: 0.95rem;
	color: var(--text-gray);
	font-weight: 500;
	position: relative;
	padding: 5px 0;
	text-decoration: none;
}

.nav-item:hover, .nav-item.active {
	color: var(--text-white);
}

/* 밑줄 애니메이션 */
.nav-item::after {
	content: '';
	position: absolute;
	bottom: 0;
	left: 0;
	width: 0%;
	height: 2px;
	background-color: var(--primary-red);
	transition: width 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.nav-item:hover::after {
	width: 100%;
}

.nav-actions {
	display: flex;
	align-items: center;
	gap: 20px;
	list-style: none;
	margin: 0;
	padding: 0;
}

.btn-login {
	background: transparent;
	color: var(--text-white);
	border: 1px solid rgba(255, 255, 255, 0.3);
	padding: 6px 16px;
	border-radius: 4px;
	font-size: 0.9rem;
	transition: all 0.2s;
	text-decoration: none;
}

.btn-login:hover {
	border-color: var(--text-white);
	background: rgba(255, 255, 255, 0.1);
}

.btn-signup {
	background-color: var(--primary-red);
	color: white;
	padding: 6px 16px;
	border-radius: 4px;
	font-weight: 600;
	font-size: 0.9rem;
	border: none;
	transition: transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
	text-decoration: none;
}

.btn-signup:hover {
	background-color: #B20710;
	transform: scale(1.05);
	color: white;
}

#logoutBtn {
	background: none;
	border: none;
	color: var(--text-gray);
	font-size: 0.95rem;
	padding: 0;
	cursor: pointer;
}

#logoutBtn:hover {
	color: var(--primary-red);
}
</style>

<nav class="global-nav">
	<div class="nav-content">
		<div class="d-flex align-items-center">
			<a href="<%=request.getContextPath()%>/main/mainPage.jsp"
				class="brand-logo-link"> <img
				src="<%=request.getContextPath()%>/save/whatflix-grunge-transparent2.PNG"
				alt="WHATFLIX" class="brand-logo-img">
			</a>
			<ul class="nav-links">
				<li><a href="<%=request.getContextPath()%>/main/mainPage.jsp"
					class="nav-item">홈</a></li>
				<li><a href="<%=request.getContextPath()%>/movie/movieList.jsp"
					class="nav-item">영화</a></li>
				<li><a
					href="<%=request.getContextPath()%>/main/communitySection.jsp"
					class="nav-item">커뮤니티</a></li>
				<li><a
					href="<%=request.getContextPath()%>/support/supportList.jsp"
					class="nav-item">지원</a></li>
				<%
				String roleType = (String) session.getAttribute("roleType");
				if ("3".equals(roleType) || "9".equals(roleType)) {
				%>
				<li><a href="<%=request.getContextPath()%>/chart/adminMain.jsp"
					class="nav-item">분석</a></li>

				<%
				}
				%>
			</ul>
		</div>
		<ul class="nav-actions">
			<li><a href="../main/sessionCheck.jsp" class="nav-item"
				style="font-size: 0.8rem; opacity: 0.5;">Dev:세션</a></li>

			<%
			if ("true".equals(loginStatus)) {
			%>
			<li><a href="#" id="openProfile" data-bs-toggle="modal"
				data-bs-target="#profileModal" class="nav-item"> <i
					class="bi bi-person-circle" style="font-size: 1.2rem;"></i>
			</a></li>
			<li>
				<form action="../login/logoutAction.jsp" method="post"
					style="margin: 0;">
					<button id="logoutBtn" type="submit">로그아웃</button>
				</form>
			</li>
			<%
			} else {
			%>
			<li><a href="#" id="openLoginModal" data-bs-toggle="modal"
				data-bs-target="#loginModal" class="btn-login">로그인</a></li>
			<li><a href="../signUp/signUpPage.jsp" class="btn-signup">회원가입</a></li>
			<%
			}
			%>
		</ul>
	</div>
</nav>