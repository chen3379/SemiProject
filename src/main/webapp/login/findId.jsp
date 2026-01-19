<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div id="findIdStep1" class="find-id-container">
    <b>닉네임으로 Id 찾기</b>
    <form action="findIdAction.jsp" method="post" id="findIdForm">
        <label for="nickname">닉네임</label>
        <input type="text" id="nickname" name="nickname" required>
        <button type="submit">아이디 찾기</button>
    </form>
</div>

<div class="id-result-container" id="findIdStep2" style="display: none;">
    <label id="idMessage"></label>
    <ul id="idResultList">
        
    </ul>
    <div class="button-container">
    <ul>
        <li><a href="#" id="openLoginModal" data-bs-toggle="modal"
				data-bs-target="#loginModal">로그인</a></li>
        <li>
            <button type="button" id="goToFindPwBtn">비밀번호 </button>
        </li>
    </ul>
</div>
</div>

<script>
    $(document).ready(function () {
        $('#findIdForm').on('submit', function (e) {
            e.preventDefault();
            $('#idResultList').empty();
            $('#idMessage').text('');
            $.ajax({
                url: 'findIdAction.jsp',
                type: 'post',
                data: $('#findIdForm').serialize(),
                success: function (res) {
                    if (res.status == 'NOT_FOUND') {
                        alert('해당 닉네임으로 가입된 아이디가 없습니다.');
                        return;
                    } else if (res.status == 'SYSTEM_ERROR' || res.status == 'DB_ERROR') {
                        alert('오류가 발생했습니다. 다시 시도해주세요');
                        return;
                    } else if (res.status == 'SUCCESS') {
                        $('#idMessage').text(res.nickname + '님으로 가입된 아이디는 총 ' + res.count + '개 입니다.');
                        $('#idResultList').empty();
                        $.each(res.idList, function(index, item){
                            $('#idResultList').append('<li>' + item + '</li>');
                        });
                        $('#findIdStep1').hide();
                        $('#findIdStep2').show();
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX 요청 중 오류 발생:', error);
                    alert('오류가 발생했습니다. 다시 시도해주세요');
                }
            });
        });

        $('#goToFindPwBtn').on('click', function() {
            $('#findPasswordBtn').trigger('click'); 
        });
    });
</script>