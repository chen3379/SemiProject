<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    /* [WHATFLIX SignUp Form Style] */
    .signup-form-wrapper {
        animation: fadeIn 0.5s ease-out;
    }

    .form-header {
        margin-bottom: 25px;
        text-align: center;
    }

    .form-header h4 {
        font-weight: 700;
        color: var(--text-white);
        margin-bottom: 5px;
    }

    /* 입력 그룹 스타일 */
    .input-group-custom {
        margin-bottom: 20px;
        position: relative;
    }

    .input-group-custom label {
        display: block;
        margin-bottom: 8px;
        color: var(--text-gray);
        font-size: 0.85rem;
        font-weight: 500;
    }

    .input-group-custom input {
        width: 100%;
        background-color: #222;
        border: 1px solid #333;
        color: white;
        padding: 12px 15px;
        border-radius: 6px;
        transition: all 0.2s;
        font-size: 0.95rem;
    }

    .input-group-custom input:focus {
        outline: none;
        border-color: var(--primary-red);
        background-color: #2a2a2a;
    }

    /* 에러/성공 메시지 스타일 */
    .error-msg {
        display: block;
        font-size: 0.75rem;
        margin-top: 6px;
        height: 1rem;
        opacity: 0;
        transform: translateY(-5px);
        transition: all 0.3s ease;
    }

    .error-msg.show {
        opacity: 1;
        transform: translateY(0);
    }

    /* 회원가입 버튼 */
    .btn-submit-signup {
        width: 100%;
        background-color: var(--primary-red);
        color: white;
        border: none;
        padding: 15px;
        border-radius: 6px;
        font-weight: 700;
        font-size: 1rem;
        margin-top: 10px;
        transition: background 0.2s;
    }

    .btn-submit-signup:hover {
        background-color: var(--primary-red-hover);
    }

    .btn-submit-signup:disabled {
        background-color: #555;
        cursor: not-allowed;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
</style>

<div class="signup-form-wrapper">
    <div class="form-header">
        <h4>상세 정보 입력</h4>
        <p class="text-muted small">계정 생성을 위해 정보를 입력해 주세요.</p>
    </div>

    <form id="signUpForm" action="generalAction.jsp" method="post">
        <!-- 닉네임 입력 -->
        <div class="input-group-custom">
            <label for="signUpNickname">닉네임</label>
            <input type="text" id="signUpNickname" name="nickname" required placeholder="2글자 이상 입력">
            <span class="error-msg" id="nickMsg"></span>
        </div>

        <!-- 아이디(이메일) 입력 -->
        <div class="input-group-custom">
            <label for="signUpId">이메일 계정 (ID)</label>
            <input type="email" id="signUpId" name="id" required
                placeholder="example@whatflix.com"
                pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                title="올바른 이메일 형식을 입력해 주세요.">
            <span class="error-msg" id="idMsg"></span>
        </div>

        <!-- 비밀번호 입력 -->
        <div class="input-group-custom">
            <label for="signUpPassword">비밀번호</label>
            <input type="password" id="signUpPassword" name="password" required
                placeholder="영문, 숫자, 특수문자 조합"
                pattern="^[a-zA-Z0-9!@#$%^&amp;*()_+|~=`{}\[\] :;&lt;&gt;?,.\/\-]+$"
                title="영문, 숫자, 특수문자만 입력 가능합니다.">
        </div>

        <!-- 비밀번호 확인 -->
        <div class="input-group-custom">
            <label for="signUpPasswordConfirm">비밀번호 확인</label>
            <input type="password" id="signUpPasswordConfirm" name="passwordConfirm" required 
                placeholder="비밀번호 재입력"
                pattern="^[a-zA-Z0-9!@#$%^&amp;*()_+|~=`{}\[\] :;&lt;&gt;?,.\/\-]+$">
            <span class="error-msg" id="pwMsg"></span>
        </div>

        <button type="submit" class="btn-submit-signup" id="finalSignUpBtn">WHATFLIX 가입 완료</button>
    </form>
</div>

<script>
    // 기존 비즈니스 로직 유지
    var signUpForm = document.getElementById('signUpForm');
    var nickTimer, idTimer;
    var signUpNickname = document.getElementById('signUpNickname');
    var signUpId = document.getElementById('signUpId');
    var signUpPassword = document.getElementById('signUpPassword');
    var signUpPasswordConfirm = document.getElementById('signUpPasswordConfirm');
    var nickMsg = document.getElementById('nickMsg');
    var idMsg = document.getElementById('idMsg');
    var pwMsg = document.getElementById('pwMsg');

    // [ID 중복 체크] 로직 보존
    signUpId.addEventListener('input', function () {
        var id = this.value.trim();
        if (idTimer) clearTimeout(idTimer);

        idTimer = setTimeout(function () {
            if (id === "") {
                idMsg.innerText = "";
                idMsg.classList.remove('show');
                return;
            }

            $.ajax({
                url: 'checkIdAction.jsp',
                type: 'POST',
                data: { id: id },
                dataType: 'json',
                success: function (res) {
                    idMsg.classList.add('show');
                    if (res.isDuplicate === true) {
                        idMsg.innerText = "이미 사용 중인 ID입니다.";
                        idMsg.style.color = "#E50914"; // WHATFLIX Red
                    } else if (res.isDuplicate === false) {
                        idMsg.innerText = "사용 가능한 ID 입니다.";
                        idMsg.style.color = "#28a745"; // Green
                    }
                }
            });
        }, 500);
    });

    // [닉네임 중복 체크] 로직 보존
    signUpNickname.addEventListener('input', function () {
        var nickname = this.value.trim();
        if (nickTimer) clearTimeout(nickTimer);

        nickTimer = setTimeout(function () {
            if (nickname === "") {
                nickMsg.innerText = "";
                nickMsg.classList.remove('show');
                return;
            } else if (nickname.length < 2) {
                nickMsg.innerText = '닉네임은 2글자 이상 입력해주세요.';
                nickMsg.style.color = '#E50914';
                nickMsg.classList.add('show');
                return;
            }

            $.ajax({
                url: 'checkNicknameAction.jsp',
                type: 'POST',
                data: { nickname: nickname },
                dataType: 'json',
                success: function (res) {
                    nickMsg.classList.add('show');
                    if (res.isDuplicate === true) {
                        nickMsg.innerText = "이미 사용 중인 닉네임입니다.";
                        nickMsg.style.color = "#E50914";
                    } else if (res.isDuplicate === false) {
                        nickMsg.innerText = "사용 가능한 닉네임 입니다.";
                        nickMsg.style.color = "#28a745";
                    }
                }
            });
        }, 500);
    });

    // [비밀번호 일치 확인] 로직 보존
    function checkPassword() {
        if (!signUpPassword.value || !signUpPasswordConfirm.value) {
            pwMsg.classList.remove('show');
            return;
        }
        if (signUpPassword.value !== signUpPasswordConfirm.value) {
            pwMsg.style.color = '#E50914';
            pwMsg.innerHTML = '비밀번호가 일치하지 않습니다.';
        } else {
            pwMsg.style.color = '#28a745';
            pwMsg.innerHTML = '비밀번호가 일치합니다.';
        }
        pwMsg.classList.add('show');
    }

    signUpPassword.addEventListener('input', checkPassword);
    signUpPasswordConfirm.addEventListener('input', checkPassword);

    // [폼 제출] 로직 보존
    signUpForm.addEventListener('submit', function (e) {
        e.preventDefault();

        if (signUpPassword.value !== signUpPasswordConfirm.value) {
            alert("비밀번호가 일치하지 않습니다.");
            signUpPasswordConfirm.focus();
            return;
        }

        var submitBtn = document.getElementById('finalSignUpBtn');
        submitBtn.disabled = true;
        submitBtn.innerText = "가입 처리 중...";

        $.ajax({
            url: 'generalSignUpAction.jsp',
            type: 'POST',
            dataType: 'json',
            data: $(this).serialize(),
            success: function (res) {
                if (res.status === 'SUCCESS') {
                    alert('WHATFLIX 회원이 되신 것을 환영합니다!');
                    location.href = '../main/mainPage.jsp';
                } else {
                    submitBtn.disabled = false;
                    submitBtn.innerText = "WHATFLIX 가입 완료";
                    
                    if (res.status === 'DUPLICATE_ID') {
                        alert('이미 등록된 아이디입니다.');
                        signUpId.focus();
                    } else if (res.status === 'DUPLICATE_NICKNAME') {
                        alert('이미 등록된 닉네임입니다.');
                        signUpNickname.focus();
                    } else {
                        alert('가입 처리 중 오류가 발생했습니다.');
                    }
                }
            },
            error: function () {
                alert("서버 통신 오류가 발생했습니다.");
                submitBtn.disabled = false;
                submitBtn.innerText = "WHATFLIX 가입 완료";
            }
        });
    });
</script>
