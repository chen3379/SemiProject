<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 위 지시어는 파일 최상단에 딱 한 번만 있어야 합니다. --%>

<style>
    /* 프로필 모달 커스텀 스타일 */
    #profileModal .modal-content {
        background-color: var(--bg-surface);
        border: 1px solid var(--border-glass);
        border-radius: 12px;
        overflow: hidden;
    }

    .main-profile-container {
        padding: 40px 30px;
        text-align: center;
        position: relative;
    }

    #profileModal .profile-img {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid var(--primary-red);
        margin-bottom: 15px;
        box-shadow: 0 0 15px rgba(229, 9, 20, 0.3);
    }

    #profileModal #nickname {
        font-size: 1.4rem;
        font-weight: 700;
        color: var(--text-white);
        margin-bottom: 5px;
    }

    #profileModal .user-email {
        font-size: 0.9rem;
        color: var(--text-gray);
        margin-bottom: 25px;
    }

    .profile-menu-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
        width: 100%;
    }

    .profile-menu-item {
        display: block;
        padding: 12px;
        border-radius: 6px;
        background-color: rgba(255, 255, 255, 0.05);
        color: var(--text-white);
        font-weight: 500;
        transition: all 0.2s ease;
        text-decoration: none;
    }

    .profile-menu-item:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: var(--primary-red);
    }

    #modalLogoutBtn {
        width: 100%;
        background: transparent;
        border: 1px solid var(--text-muted);
        color: var(--text-gray);
        padding: 10px;
        border-radius: 6px;
        font-size: 0.9rem;
        margin-top: 20px;
        transition: all 0.2s;
        cursor: pointer;
    }

    #modalLogoutBtn:hover {
        border-color: var(--primary-red);
        color: var(--primary-red);
    }

    #profileModal .btn-close {
        filter: invert(1);
        position: absolute;
        right: 1.5rem;
        top: 1.5rem;
    }
</style>

<div class="modal fade" id="profileModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
            <div class="main-profile-container">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                
                <!-- 프로필 이미지 및 정보 (세션 데이터 바인딩) -->
                <img src="${pageContext.request.contextPath}${sessionScope.memberInfo.photo}" class="profile-img" alt="프로필 이미지" onerror="this.src='${pageContext.request.contextPath}/profile_photo/default_photo.jpg'"   >
                <div id="nickname">${sessionScope.memberInfo.nickname}님</div>
                <div class="user-email">${sessionScope.memberInfo.id}</div>

                <!-- 메뉴 리스트 -->
                <div class="profile-menu-list">
                    <a href="../profile/profilePage.jsp?id=${sessionScope.memberInfo.id}" class="profile-menu-item">
                        <i class="bi bi-person-circle me-2"></i>내 프로필 관리
                    </a>
                </div>

                <!-- 로그아웃 폼 -->
                <form action="../login/logoutAction.jsp" method="post">
                    <button type="submit" id="modalLogoutBtn">
                        <i class="bi bi-box-arrow-right me-2"></i>로그아웃
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
