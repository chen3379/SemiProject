<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <style>
        .error-msg {
            opacity: 0;
            transition: all 1.5s ease;
        }

        .error-msg.show {
            opacity: 1;
        }
    </style>

    <div class="container">
        <form id="signUpForm" action="generalAction.jsp" method="post">
            <div>
                <label for="signUpNickname">닉네임</label>
                <input type="text" id="signUpNickname" name="nickname" required>
                <span class="error-msg" id="nickMsg"></span>
            </div>
            <div>
                <label for="signUpId">ID</label>
                <input type="email" id="signUpId" name="id" required
                    pattern="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
                    title="알파벳, 숫자, 점(.), 밑줄(_), 하이픈(-)만 사용 가능하며 올바른 이메일 형식이어야 합니다.">
                <span class="error-msg" id="idMsg"></span>
            </div>
            <div>
                <label for="signUpPassword">비밀번호</label>
                <input type="password" id="signUpPassword" name="password" required
                    pattern="^[a-zA-Z0-9!@#$%^&amp;*()_+|~=`{}\[\] :;&lt;&gt;?,.\/\-]+$"
                    title="영문, 숫자, 특수문자만 입력 가능합니다.">

            </div>
            <div>
                <label for="signUpPasswordConfirm">비밀번호 확인</label>
                <input type="password" id="signUpPasswordConfirm" name="passwordConfirm" required placeholder="비밀번호 확인"
                    pattern="^[a-zA-Z0-9!@#$%^&amp;*()_+|~=`{}\[\] :;&lt;&gt;?,.\/\-]+$">
                <span class="error-msg" id="pwMsg"></span>
            </div>

            <button type="submit">회원 가입</button>
        </form>
    </div>

    <script>

        var signUpForm = document.getElementById('signUpForm');
        var nickTimer;
        var signUpNickname = document.getElementById('signUpNickname');
        var signUpId = document.getElementById('signUpId');
        var signUpPassword = document.getElementById('signUpPassword');
        var signUpPasswordConfirm = document.getElementById('signUpPasswordConfirm');
        var nickMsg = document.getElementById('nickMsg');
        var idMsg = document.getElementById('idMsg');
        var pwMsg = document.getElementById('pwMsg');

        signUpNickname.addEventListener('input', function () {
            var nickname = this.value.trim();

            if (nickTimer) {
                clearTimeout(nickTimer);
            }

            nickTimer = setTimeout(function () {
                if (nickname === "") {
                    nickMsg.innerText = "";
                    nickMsg.classList.remove('show');
                    return;
                } else if (nickname.length < 2) {
                    nickMsg.innerText = '닉네임은 2글자 이상 입력해주세요.';
                    nickMsg.style.color = 'red';
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
                            nickMsg.style.color = "red";
                        } else if (res.isDuplicate === false) {
                            nickMsg.innerText = "사용 가능한 닉네임 입니다.";
                            nickMsg.style.color = "green";
                        } else if (res.isDuplicate === null) {
                            nickMsg.innerText = "닉네임 중복 확인 중 오류가 발생했습니다.";
                            nickMsg.style.color = "red";
                        }
                    }
                });
            }, 500);
        });

        function checkPassword() {
            if (!signUpPassword.value || !signUpPasswordConfirm.value) {
                pwMsg.classList.remove('show');
                return;
            }

            if (signUpPassword.value !== signUpPasswordConfirm.value) {
                pwMsg.style.color = 'red';
                pwMsg.innerHTML = '비밀번호가 일치하지 않습니다.';
            } else {
                pwMsg.style.color = 'green';
                pwMsg.innerHTML = '비밀번호가 일치합니다.';
            }
            pwMsg.classList.add('show');
        }

        signUpPassword.addEventListener('input', checkPassword);
        signUpPasswordConfirm.addEventListener('input', checkPassword);

        // 전송 및 AJAX 처리
        signUpForm.addEventListener('submit', function (e) {
            e.preventDefault();

            // 최종 비밀번호 확인
            if (signUpPassword.value !== signUpPasswordConfirm.value) {
                alert("비밀번호가 일치하지 않습니다.");
                signUpPasswordConfirm.focus();
                return;
            }

            var submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.disabled = true;

            $.ajax({
                url: 'generalSignUpAction.jsp',
                type: 'POST',
                dataType: 'json',
                data: $(this).serialize(),
                success: function (res) {
                    if (res.status === 'SUCCESS') {
                        alert('회원가입을 환영합니다!');
                        location.href = '../main/mainPage.jsp';
                    } else {

                        signUpPassword.value = '';
                        signUpPasswordConfirm.value = '';
                        pwMsg.classList.remove('show');

                        if (res.status === 'DUPLICATE') {
                            alert('이미 등록된 이메일입니다.');
                            signUpId.focus();
                            idMsg.innerText = '이미 사용 중인 이메일 주소입니다.';
                            idMsg.style.color = 'red';
                            idMsg.classList.add('show');
                        } else if (res.status === 'FAIL') {
                            alert('가입에 실패했습니다.');
                        } else if (res.status === 'ERROR') {
                            alert('에러 발생.');
                        } 
                    }
                },
                error: function (xhr, status, error) {
                    console.error("AJAX Error:", status, error);
                    alert("서버 통신 중 오류가 발생했습니다.");
                },
                complete: function () {
                    submitBtn.disabled = false;
                }
            });
        });
    </script>