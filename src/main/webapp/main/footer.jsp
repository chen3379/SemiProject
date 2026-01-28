<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<style>
/* Footer 기본 스타일 (기존 유지) */
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
	grid-template-columns: repeat(4, 1fr) auto;
	gap: 15px;
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

.footer-links a, .map-trigger {
	color: var(--text-muted);
	text-decoration: none;
	transition: color 0.2s;
	cursor: pointer;
}

.footer-links a:hover, .map-trigger:hover {
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
footer .bi {
    color: #E50914;
}

/* [추가] 모달(지도) 다크 테마 커스텀 */
.map-modal-content {
	background-color: #141414; /* 넷플릭스 배경색 */
	border: 1px solid #333;
	color: white;
}

.map-modal-header {
	border-bottom: 1px solid #333;
}

.map-iframe {
	width: 100%;
	height: 450px;
	border: 0;
	border-radius: 4px;
}

.map-trigger i {
	color: #E50914 !important; /* 넷플릭스 레드 */
	font-size: 1.1rem; /* 아이콘 크기 살짝 키움 */
	margin-right: 5px; /* 글자와 간격 */
	vertical-align: middle; /* 높이 중앙 정렬 */
}

/* (옵션) 마우스 올렸을 때 더 밝게 빛나게 하려면 */
.map-trigger:hover i {
	color: #ff1f1f !important;
	text-shadow: 0 0 8px rgba(229, 9, 20, 0.6);
}
</style>

<div class="footer-wrapper">
	<div class="footer-content">
		<div class="footer-col">
			<h4>WHATFLIX</h4>
			<ul class="footer-links">
				<li><a href="<%=request.getContextPath()%>/main/mainPage.jsp">홈</a></li>
				<li><a href="<%=request.getContextPath()%>/support/supportList.jsp">고객센터</a></li>
				<li><a href="#">이용약관</a></li>
				<li><a href="#">개인정보처리방침</a></li>
			</ul>
		</div>
		<div class="footer-col">
			<h4>소개</h4>
			<ul class="footer-links">
				<li><a href="https://www.sist.co.kr/index.jsp">회사소개</a></li>
				<li><a class="map-trigger" data-bs-toggle="modal"
					data-bs-target="#mapModal"> <i class="bi bi-geo-alt-fill"></i>
						오시는 길 (지도)
				</a></li>
				<li><a href="https://www.sist.co.kr/index.jsp">제휴문의</a></li>
			</ul>
		</div>
		<div class="footer-col">
			<h4>고객센터</h4>
			<ul class="footer-links">
				<li>문의: help@whatflix.com</li>
				<li>Tel: 02-1234-5678</li>
				<li>운영시간: 09:00 ~ 18:00</li>
			</ul>
		</div>
		<div class="footer-col">
			<h4>소셜 미디어</h4>
			<div style="display: flex; gap: 15px; font-size: 1.2rem; align-items: center;">
				<a href="#"><i class="bi bi-instagram"></i></a> 
				<a href="#"><i class="bi bi-youtube"></i></a> 
				<a href="#"><i class="bi bi-twitter-x"></i></a> 
				<a href="#"><i class="bi bi-facebook"></i></a>
			</div>
		</div>
		<div class="footer-col" style="display: flex; align-items: flex-start; justify-content: flex-start;">
			<a href="javascript:void(0)" onclick="window.scrollTo({top: 0, behavior: 'smooth'})" title="Top" style="text-decoration: none;">
					<h4 style="color: var(--primary-red); margin-bottom: 0; display: flex; align-items: center; gap: 4px;">
						TOP <i class="bi bi-chevron-up"></i>
					</h4> 
			</a>
		</div>
	</div>
	<div class="footer-bottom">&copy; 2026 WHATFLIX Inc. All rights
		reserved.</div>
</div>

<div class="modal fade" id="mapModal" tabindex="-1"
	aria-labelledby="mapModalLabel" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered">
		<div class="modal-content map-modal-content">
			<div class="modal-header map-modal-header">
				<h5 class="modal-title" id="mapModalLabel">오시는 길</h5>
				<button type="button" class="btn-close btn-close-white"
					data-bs-dismiss="modal" aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<iframe class="map-iframe"
					src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3165.134301625626!2d127.05059697654754!3d37.50475047205476!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x357ca1c32408f9b7%3A0x4e3761a4f356d1eb!2z7IyN7Jqp6rWQ7Jyh7IS87YSw!5e0!3m2!1sko!2skr!4v1768183729313!5m2!1sko!2skr"
					allowfullscreen="" loading="lazy"
					referrerpolicy="no-referrer-when-downgrade"> </iframe>
				<div
					style="margin-top: 15px; text-align: center; font-size: 0.9rem; color: #ccc;">
					<i class="bi bi-geo-alt"></i> 서울특별시 강남구 테헤란로 123 왓플릭스 타워
				</div>
			</div>
		</div>
	</div>
</div>
<jsp:include page="../common/customAlert.jsp" />
