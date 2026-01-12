<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="modal fade" id="loginModal" tabindex="-1" aria-hidden="true" >
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <!-- 닫기 버튼 (data-bs-dismiss 필수) -->
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>

            <div>
                <label for="id">이메일</label>
                <input type="text" id="id">
            </div>

            <div>
                <label for="pass">비밀번호</label>
                <input type="password" id="pass">
            </div>

            <div>
                <input type="checkbox" id="saveid">
                <label for="saveid">로그인 상태 유지</label>
            </div>

            <button type="button" onclick="submitLogin()">로그인</button>
        </div>
    </div>
</div>


<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
		
<script>
	function submitLogin() {
		var id = document.getElementById('id').value;
		var pass = document.getElementById('pass').value;

		if (!id || !pass) {
			alert('이메일과 비밀번호를 입력해주세요.');
			return;
		}

		$.ajax({

			url : '../login/loginAction.jsp',
			type : 'post',
			data : {
				'id' : id,
				'pass' : pass
				'saveid' : document.getElementById('saveid').checked
			},
			dataType : 'json',
			success : function(res) {

				if (res.status === "success") {
					location.reload();
				} else {
					alert("로그인 정보가 일치하지 않습니다.");
				}
			},
			error : function() {
				alert("서버 오류");
			}
		});
	}
</script>
