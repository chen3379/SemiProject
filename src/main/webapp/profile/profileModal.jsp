<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <div class="modal fade" id="profileModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="main-profile-container">
                    <img src="${sessionScope.memberInfo.photo}" alt="프로필 이미지">
                    <div id="nickname">${sessionScope.memberInfo.nickname}</div>
                    <a href="../profile/profilePage.jsp?id=${sessionScope.memberInfo.id}">프로필</a>
                    <form action="../login/logoutAction.jsp" method="post">
                        <button type="submit" class="" id="modalLogoutBtn">로그아웃</button>
                    </form>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
            </div>
        </div>
    </div>

 