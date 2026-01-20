<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* 푸터 전체 컨테이너 */
    .footer-container {
        background-color: #f8f9fa; /* 밝은 회색 배경 */
        padding: 30px 20px;
        border-top: 1px solid #e7e7e7;
        margin-top: auto; /* 본문이 적어도 하단에 붙도록 함 */
    }

    /* 리스트 스타일 및 가로 정렬 */
    .footer-nav {
        list-style: none;
        padding: 0;
        margin: 0;
        display: flex;
        flex-wrap: wrap; /* 화면이 좁아지면 아래로 줄바꿈 */
        justify-content: center; /* 가운데 정렬 */
        align-items: center;
        gap: 25px; /* 항목 간 간격 */
    }

    /* 링크 및 텍스트 스타일 */
    .footer-nav li, .footer-nav strong {
        font-size: 14px;
        color: #666;
    }

    .footer-nav a {
        text-decoration: none;
        color: #666;
        transition: color 0.2s;
    }

    .footer-nav a:hover {
        color: #000; /* 호버 시 진하게 */
    }

    .footer-logo {
        font-size: 18px;
        color: #000;
        margin-right: 10px;
    }

    /* 가입 버튼 강조 */
    .join-link {
        font-weight: bold;
        color: #d9534f !important; /* 강조색 */
    }
</style>

<footer class="footer-container">
    <nav>
        <ul class="footer-nav">
            <li><strong class="footer-logo"><a href="../main/mainPage.jsp">WHATFLIX</a></strong></li>
            <li>H.P 333-3333-333</li>
            <li>소셜 로고</li>
            <li><a href="../support/dataPrivacy.jsp">개인정보 처리방침</a></li>
            <li><a href="../support/joinAgreement.jsp">가입 약관</a></li>
            <li><a href="../signUp/signUpPage.jsp" class="join-link">지금 가입하기</a></li>
            <li><a href="#" onclick="window.scrollTo({top: 0, behavior: 'smooth'}); return false;">TOP ▲</a></li>
        </ul>
    </nav>
</footer>
