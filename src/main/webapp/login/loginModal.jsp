<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<div class="modal fade" id="loginModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<form action="../login/loginAction.jsp" method="post" id="loginForm">
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>

					<div>
						<label for="loginId">이메일</label>
						<input type="email" id="loginId" name="id">
					</div>

					<div>
						<label for="loginPassword">비밀번호</label>
						<input type="password" id="loginPassword" name="password">
					</div>

					<div>
						<input type="checkbox" id="loginSaveID" name="saveid">
						<label for="loginSaveID">로그인 상태 유지</label>
					</div>
					<div>
						<a href="../signUp/signUpPage.jsp">회원가입</a>
					</div>

					<button type="submit" class="btn-login" id="loginBtn">로그인</button>
				</form>
			</div>
		</div>
	</div>

<!-- 모달 bootstrap -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

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
						$('#loginBtn').prop('disabled', true);
					},
					success: function (res) {
						if (res.status === "SUCCESS") {
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
						$('#loginBtn').prop('disabled', false);
					}
				});
			});
		});
	</script>