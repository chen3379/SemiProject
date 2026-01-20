<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    /* 로그인 모달 전용 커스텀 스타일 */
    #loginModal .modal-content {
        background-color: var(--bg-surface);
        border: 1px solid var(--border-glass);
        color: var(--text-white);
        padding: 2rem;
        border-radius: 8px;
    }

    #loginModal .modal-header {
        border-bottom: none;
        padding: 0;
        margin-bottom: 1.5rem;
    }

    #loginModal .modal-title {
        font-weight: 700;
        font-size: 1.8rem;
    }

    #loginModal .btn-close {
        filter: invert(1); /* 닫기 버튼 흰색으로 변경 */
        position: absolute;
        right: 1.5rem;
        top: 1.5rem;
    }

    #loginModal .form-group {
        margin-bottom: 1rem;
    }

    #loginModal label {
        display: block;
        margin-bottom: 0.5rem;
        color: var(--text-gray);
        font-size: 0.85rem;
    }

    #loginModal .form-control {
        background-color: #333;
        border: none;
        color: white;
        padding: 0.8rem 1rem;
        border-radius: 4px;
    }

    #loginModal .form-control:focus {
        background-color: #454545;
        box-shadow: none;
        border: 1px solid var(--primary-red);
    }

    #loginModal .form-check-label {
        font-size: 0.85rem;
        color: var(--text-gray);
    }

    #loginModal .form-check-input:checked {
        background-color: var(--primary-red);
        border-color: var(--primary-red);
    }

    #loginModal .btn-login {
        background-color: var(--primary-red);
        color: white;
        width: 100%;
        padding: 0.8rem;
        font-weight: 700;
        border: none;
        border-radius: 4px;
        margin-top: 1.5rem;
        transition: background 0.2s;
    }

    #loginModal .btn-login:hover {
        background-color: var(--primary-red-hover);
    }

    #loginModal .login-footer {
        margin-top: 1rem;
        text-align: center;
        font-size: 0.9rem;
    }

    #loginModal .login-footer a {
        color: var(--text-gray);
        margin: 0 10px;
    }

    #loginModal .login-footer a:hover {
        color: var(--text-white);
        text-decoration: underline;
    }
</style>

<div class="modal fade" id="loginModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content shadow-lg">
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            
            <div class="modal-header">
                <h2 class="modal-title">로그인</h2>
            </div>

            <form action="../login/loginAction.jsp" method="post" id="loginForm">
                <div class="form-group">
                    <label for="loginId">이메일 주소</label>
                    <input type="email" class="form-control" id="loginId" name="id" placeholder="email@example.com" required>
                </div>

                <div class="form-group">
                    <label for="loginPassword">비밀번호</label>
                    <input type="password" class="form-control" id="loginPassword" name="password" placeholder="비밀번호 입력" required>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-3">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="loginSaveID" name="saveid">
                        <!-- 
                        session.invalidate()로 싹 날려야 보안이 강화되는데
                        그러면 saveId session도 날아가서 세션으로는 구현 불가능
                        쿠키로 구현 예정
                        -->
                        <label class="form-check-label" for="loginSaveID">아이디 저장</label>
                    </div>
                </div>

                <button type="submit" class="btn-login" id="loginBtn">로그인</button>

                <div class="login-footer">
                    <a href="../signUp/signUpPage.jsp">회원가입</a>
                    <span style="color: var(--text-muted)">|</span>
                    <a href="../login/findAccountPage.jsp">계정 찾기</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('#loginForm').on('submit', function (e) {
            e.preventDefault();

            var $form = $(this);
            var loginId = $('#loginId').val();
            var loginPassword = $('#loginPassword').val();

            if (!loginId || !loginPassword) {
                alert('이메일과 비밀번호를 입력해주세요.');
                return;
            }

            $.ajax({
                url: '../login/loginAction.jsp',
                type: 'POST',
                data: $form.serialize(),
                dataType: 'json',
                beforeSend: function () {
                    $('#loginBtn').prop('disabled', true).text('로그인 중...');
                },
                success: function (res) {
                    if (res.status === "SUCCESS") {
                        var modalEl = document.getElementById('loginModal');
                        var modal = bootstrap.Modal.getInstance(modalEl);
                        if (modal) modal.hide();
                        location.replace('../main/mainPage.jsp');
                    } else if (res.status === "FAIL") {
                        alert(res.message || "로그인 정보가 일치하지 않습니다.");
                    } else {
                        alert("알 수 없는 오류가 발생했습니다.");
                    }
                },
                error: function (xhr, status, error) {
                    console.error("AJAX Error:", status, error);
                    alert("서버 통신 실패: " + xhr.status);
                },
                complete: function () {
                    $('#loginBtn').prop('disabled', false).text('로그인');
                }
            });
        });
    });
</script>
