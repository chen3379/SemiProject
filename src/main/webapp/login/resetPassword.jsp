<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* WHATFLIX 전용 스타일 추가 - 로직에 영향 주지 않음 */
    .reset-password-container {
        max-width: 450px;
        margin: 0 auto;
        color: var(--text-white);
        animation: fadeInUp 0.4s ease-out;
    }

    .reset-password-container label {
        display: block;
        margin-bottom: 10px;
        font-weight: 600;
        color: var(--text-gray);
    }

    .reset-password-container input[type="email"],
    .reset-password-container input[type="password"] {
        width: 100%;
        background-color: #222;
        border: 1px solid #333;
        color: white;
        padding: 12px 15px;
        border-radius: 4px;
        margin-bottom: 20px;
    }

    .reset-password-container input:focus {
        outline: none;
        border-color: var(--primary-red);
    }

    /* OTP 필드 스타일 */
    .otp-input-wrapper {
        display: flex;
        justify-content: space-between;
        gap: 10px;
        margin-bottom: 25px;
    }

    .otp-field {
        width: 100%;
        height: 55px;
        background-color: #222;
        border: 2px solid #333;
        border-radius: 6px;
        color: var(--primary-red);
        font-size: 1.5rem;
        font-weight: 800;
        text-align: center;
    }

    .otp-field:focus {
        outline: none;
        border-color: var(--primary-red);
    }

    /* 버튼 스타일 */
    .reset-password-container button[type="submit"] {
        width: 100%;
        background-color: var(--primary-red);
        color: white;
        border: none;
        padding: 14px;
        font-weight: 700;
        border-radius: 4px;
        transition: background 0.2s;
        cursor: pointer;
    }

    .reset-password-container button[type="submit"]:hover {
        background-color: var(--primary-red-hover);
    }

    .reset-password-container button[type="submit"]:disabled {
        background-color: #555;
    }

    #goToOtpConfirmBtn {
        color: var(--text-gray);
        font-size: 0.85rem;
        text-decoration: underline;
        margin-bottom: 15px;
        display: inline-block;
    }

    #sendOtpMsg, #resetPasswordMsg {
        display: block;
        margin-bottom: 15px;
        font-size: 0.9rem;
        color: #28a745; /* 성공 컬러 */
    }

    /* 디버그 정보 스타일 */
    .reset-password-container p {
        margin-top: 30px;
        padding: 15px;
        background: rgba(187, 187, 161, 0.1);
        font-size: 0.8rem;
        border-radius: 4px;
    }

    /* 에러/성공 메시지 스타일 */
    .error-msg {
        display: block;
        font-size: 0.75rem;
        margin-top: -15px;
        margin-bottom: 15px;
        height: 1rem;
        opacity: 0;
        transform: translateY(-5px);
        transition: all 0.3s ease;
    }

    .error-msg.show {
        opacity: 1;
        transform: translateY(0);
    }
</style>
<jsp:include page="../common/customAlert.jsp"/>
<div class="reset-password-container">
    <!-- 원본 폼 구조 100% 유지 -->
    <form action="sendOtpAction.jsp" id="sendOtpForm">
        <a href="#" id="goToOtpConfirmBtn">이미 인증 번호를 받으셨나요?</a>
        <label for="passFindId">회원가입한 이메일을 입력하세요</label>
        <input type="email" name="id" id="passFindId">
        <span id="sendOtpMsg"></span>
        <button type="submit" id="sendOtpBtn">인증 번호 전송</button>
    </form>

    <form action="otpConfirmAction.jsp" id="otpConfirmForm" style="display: none; margin-top: 20px;">
        <label>인증 번호를 입력하세요</label>
        <div class="otp-input-wrapper">
            <input type="text" class="otp-field" maxlength="1" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" inputmode="numeric">
            <input type="text" class="otp-field" maxlength="1" inputmode="numeric">
        </div>
        <input type="hidden" name="otp" id="fullOtp">
        <button type="submit" id="otpConfirmBtn">인증 번호 확인</button>
    </form>

    <form action="resetPasswordAction.jsp" id="resetPasswordForm" style="display: none; margin-top: 20px;">
        <label for="newPassword">새 비밀번호</label>
        <input type="password" name="password" id="newPassword" placeholder="영문, 숫자, 특수문자 조합">
        
        <label for="newPasswordConfirm">새 비밀번호 확인</label>
        <input type="password" id="newPasswordConfirm" placeholder="비밀번호 재입력">
        <span id="pwConfirmMsg" class="error-msg"></span>

        <button type="submit" id="resetPasswordActionBtn">비밀번호 변경</button>
    </form>

    <span id="resetPasswordMsg"></span>
    <p>세션에 저장된 인증번호 : <span id="adminOtpDisplay"><%=session.getAttribute("otp") != null ? session.getAttribute("otp") : "" %></span></p>
</div>

<script>
    /* 기존 스크립트 로직 100% 유지 (원본 그대로) */
    $(document).ready(function () {
        var isSubmitting = false;
        var $fields = $('.otp-field');
        // 인증 번호 전송
        $('#sendOtpForm').on('submit', function (e) {
            e.preventDefault();

            $.ajax({
                url: 'sendOtpAction.jsp',
                type: 'post',
                data: $(this).serialize(),
                success: function (res) {
                    if (res.status == 'NOT_FOUND') {
                        alert('해당 이메일로 가입된 아이디가 없습니다.');
                        $("#passFindId").focus();
                        return;
                    } else if (res.status == 'SYSTEM_ERROR' || res.status == 'DB_ERROR') {
                        alert('오류가 발생했습니다. 다시 시도해주세요');
                        $("#passFindId").focus();
                        return;
                    } else if (res.status == 'SUCCESS') {
                        $('#sendOtpMsg').text('해당 이메일로 6자리의 인증번호가 전송되었습니다.');
                        $('#adminOtpDisplay').text(res.otp);
                        $('#otpConfirmForm').show();
                        $fields.eq(0).focus()
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX 요청 중 오류 발생:', error);
                    alert('오류가 발생했습니다. 다시 시도해주세요');
                }
            })
        });
        // 인증 번호 확인 
        $('#otpConfirmForm').on('submit', function (e) {
            e.preventDefault();

            if ($('#fullOtp').val().length < 6) {
                alert('인증번호 6자리를 모두 입력해주세요.');
                return;
            }
            
            if (isSubmitting) return; 
            isSubmitting = true;
            $('#otpConfirmBtn').prop('disabled', true);

            $.ajax({
                url: 'otpConfirmAction.jsp',
                type: 'post',
                data: $(this).serialize(),
                success: function (res) {
                    if (res.status == 'NOT_MATCH') {
                        alert('인증번호가 일치하지 않습니다.');
                        $('#otp-field').val('');
                        $fields.eq(0).focus();
                        return;
                    } else if (res.status == 'SYSTEM_ERROR' || res.status == 'DB_ERROR') {
                        alert('오류가 발생했습니다. 다시 시도해주세요');
                        return;
                    } else if (res.status == 'SUCCESS') {
                        $('#otpConfirmForm').hide();
                        $('#resetPasswordForm').show();
                        $('#resetPasswordMsg').text('인증번호가 일치합니다.');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX 요청 중 오류 발생:', error);
                    alert('오류가 발생했습니다. 다시 시도해주세요');
                },
                complete: function() {
                    isSubmitting = false;
                    $('#otpConfirmBtn').prop('disabled', false);
                }
            })
        });

        // 비밀번호 실시간 일치 확인
        function checkPasswordMatch() {
            var pw = $('#newPassword').val();
            var pwConfirm = $('#newPasswordConfirm').val();
            var $msg = $('#pwConfirmMsg');

            if (!pw || !pwConfirm) {
                $msg.removeClass('show');
                return;
            }

            if (pw !== pwConfirm) {
                $msg.addClass('show').text('비밀번호가 일치하지 않습니다.').css('color', '#E50914');
            } else {
                $msg.addClass('show').text('비밀번호가 일치합니다.').css('color', '#28a745');
            }
        }

        $('#newPassword, #newPasswordConfirm').on('input', checkPasswordMatch);

        // 비밀번호 변경
        $('#resetPasswordForm').on('submit', function (e) {
            e.preventDefault();

            var pw = $('#newPassword').val();
            var pwConfirm = $('#newPasswordConfirm').val();

            if (pw.length < 4) {
                alert('비밀번호는 4자리 이상이어야 합니다.');
                $('#newPassword').focus();
                return;
            }

            if (pw !== pwConfirm) {
                alert('비밀번호가 일치하지 않습니다.');
                $('#newPasswordConfirm').focus();
                return;
            }

            $.ajax({
                url: 'resetPasswordAction.jsp',
                type: 'post',
                dataType: 'json',
                data: $(this).serialize(),
                success: function (res) {
                    if (res.status == 'SYSTEM_ERROR' || res.status == 'DB_ERROR') {
                        alert('오류가 발생했습니다. 다시 시도해주세요');
                        return;
                    } else if (res.status == 'SUCCESS') {
                        alert('비밀번호가 변경되었습니다.', function() {
                            location.replace("../main/mainPage.jsp");
                        });
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX 요청 중 오류 발생:', error);
                    alert('오류가 발생했습니다. 다시 시도해주세요');
                }
            })
        });
        // 6자리 input 구현 로직
        $fields.on('input', function () {
            var $this = $(this);

            $this.val($this.val().replace(/[^0-9]/g, ''));

            if ($this.val().length === 1) {
                $this.next('.otp-field').focus();
            }
            updateFullOtp();
        });

        // 매끄러운 input 구현 로직
        $fields.on('keydown', function (e) {
            var $this = $(this);
            var index = $fields.index(this);

            if (e.key === 'Backspace') {
                if ($this.val() !== '') {
                    $this.val('');
                    if (index > 0) {
                        var $prevField = $fields.eq(index - 1);
                        $prevField.focus()
                    }
                    updateFullOtp();
                    e.preventDefault();
                } else {    
                    if (index > 0) {
                        var $prevField = $fields.eq(index - 1);
                        $prevField.focus().val('');
                        updateFullOtp();
                        e.preventDefault();
                    }
                }
                
            }
        });

        // 붙혀넣기 로직
        $fields.on('paste', function (e) {
            var pasteData = e.originalEvent.clipboardData.getData('text').trim();
            if (!/^\d{6}$/.test(pasteData)) return; // 6자리 숫자일 때만 작동

            var digits = pasteData.split('');
            $fields.each(function (i) {
                $(this).val(digits[i]);
            });
            updateFullOtp();
            $fields.last().focus();
            e.preventDefault();
        });

        function updateFullOtp() {
            var fullValue = "";
            $fields.each(function () {
                fullValue += $(this).val();
            });
            $('#fullOtp').val(fullValue);
            if (fullValue.length === 6 && !isSubmitting) { $('#otpConfirmForm').submit(); }
        }

        $('#goToOtpConfirmBtn').on('click', function () {
            $('#otpConfirmForm').show();
        });
    })
</script>
