<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    .footer-wrapper {
        background-color: #000;
        padding: 60px 0;
        margin-top: 80px;
        border-top: 1px solid #222;
        color: var(--text-muted);
        font-size: 0.85rem;
    }

    .footer-content {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 40px;
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 40px;
    }

    .footer-col h4 {
        color: var(--text-gray);
        font-size: 1rem;
        margin-bottom: 20px;
        font-weight: 600;
    }

    .footer-links li {
        margin-bottom: 12px;
    }

    .footer-links a {
        transition: color 0.2s;
    }

    .footer-links a:hover {
        color: var(--primary-red);
        text-decoration: underline;
    }
    
    .footer-bottom {
        text-align: center;
        margin-top: 50px;
        padding-top: 20px;
        border-top: 1px solid #222;
        color: #444;
    }
</style>

<div class="footer-wrapper">
    <div class="footer-content">
        <div class="footer-col">
            <h4>WHATFLIX</h4>
            <ul class="footer-links">
                <li><a href="main.jsp">홈</a></li>
                <li><a href="support.jsp">고객센터</a></li>
                <li><a href="#">이용약관</a></li>
                <li><a href="#">개인정보처리방침</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>소개</h4>
            <ul class="footer-links">
                <li><a href="#">회사소개</a></li>
                <li><a href="#">인재채용</a></li>
                <li><a href="#">제휴문의</a></li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>고객지원</h4>
            <ul class="footer-links">
                <li>문의: help@whatflix.com</li>
                <li>Tel: 02-1234-5678</li>
                <li>운영시간: 09:00 ~ 18:00</li>
            </ul>
        </div>
        <div class="footer-col">
            <h4>소셜 미디어</h4>
            <div style="display: flex; gap: 15px; font-size: 1.2rem;">
                <a href="#"><i class="bi bi-instagram"></i></a>
                <a href="#"><i class="bi bi-youtube"></i></a>
                <a href="#"><i class="bi bi-twitter-x"></i></a>
                <a href="#"><i class="bi bi-facebook"></i></a>
            </div>
            <a href="#" class="btn btn-outline-light btn-sm mt-3" style="font-size: 0.8rem;">지금 가입하기</a>
        </div>
    </div>
    <div class="footer-bottom">
        &copy; 2026 WHATFLIX Inc. All rights reserved.
    </div>
</div>