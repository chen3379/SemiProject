<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    .community-preview {
        background: var(--bg-surface);
        border: 1px solid var(--border-glass);
        border-radius: 12px;
        padding: 25px;
        margin-top: 80px; /* 영화 섹션과 구분 */
        position: relative;
        overflow: hidden;
    }
    
    /* 배경 장식용 그라데이션 */
    .community-preview::before {
        content: '';
        position: absolute;
        top: -50%;
        right: -10%;
        width: 300px;
        height: 300px;
        background: radial-gradient(circle, rgba(229,9,20,0.15) 0%, rgba(0,0,0,0) 70%);
        z-index: 0;
        pointer-events: none;
    }
</style>

<section id="community-section" class="community-preview content-section">
    <div class="section-header" style="border-bottom: none;">
        <div style="z-index: 1;">
            <h2 class="section-title">🗣️ 왓플릭스 라운지</h2>
            <p style="color: var(--text-muted); font-size: 0.9rem; margin-top: 5px;">영화 수다, 스포일러 리뷰, 추천 요청까지!</p>
        </div>
        <a href="../community/community.jsp" class="more-link btn btn-outline-light btn-sm" 
           style="border-radius: 20px; padding: 8px 20px; font-size: 0.85rem;">
           커뮤니티 바로가기 <i class="bi bi-arrow-right"></i>
        </a>
    </div>
    
    <div style="z-index: 1; position: relative;">
        <div style="border-bottom: 1px solid rgba(255,255,255,0.05); padding: 15px 0; color: var(--text-gray);">
            <span style="color: var(--primary-red); margin-right: 10px;">[BEST]</span>
            이번주 넷플릭스 신작 감상평 공유합니다.
        </div>
    </div>
</section>