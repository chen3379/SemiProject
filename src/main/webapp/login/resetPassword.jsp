<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="reset-password-container">
    <form action="sendOtpAction.jsp" id="sendOtpForm">
        <a href="#" id="goToOtpConfirmBtn">이미 인증 번호를 받으셨나요?</a>
        <label for="passFindId">회원가입한 이메일을 입력하세요</label>
        <input type="email" name="id" id="passFindId">
        <span id="sendOtpMsg"></span>
        <button type="submit" id="sendOtpBtn">인증 번호 전송</button>
    </form>

    <form action="otpConfirmAction.jsp" id="otpConfirmForm" style="display: none;">
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

    <form action="resetPasswordAction.jsp" id="resetPasswordForm" style="display: none;">
        <label for="newPassword">새 비밀번호</label>
        <input type="password" name="password" id="newPassword">
        <button type="submit" id="resetPasswordActionBtn">비밀번호 변경</button>
        
    </form>
    <span id="resetPasswordMsg"></span>
    <p>세션에 저장된 인증번호 : <%=session.getAttribute("otp") %>, ${sessionScope.otp}</p>
</div>

<script>
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

        // 비밀번호 변경
        $('#resetPasswordForm').on('submit', function (e) {
            e.preventDefault();

            if ($('#newPassword').val().length < 4) {
                alert('비밀번호는 4자리 이상이어야 합니다.');
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
                        alert('비밀번호가 변경되었습니다.');
                        window.location.href = '../main/mainPage.jsp';
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