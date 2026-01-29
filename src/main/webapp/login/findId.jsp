<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    /* [WHATFLIX Find ID Style] */
    .find-id-wrapper {
        animation: fadeIn 0.4s ease-out;
    }

    .find-title {
        display: block;
        font-size: 1.4rem;
        font-weight: 700;
        color: var(--text-white);
        margin-bottom: 25px;
        text-align: center;
    }

    /* 입력 폼 스타일 */
    .find-id-container label {
        display: block;
        margin-bottom: 8px;
        color: var(--text-gray);
        font-size: 0.9rem;
    }

    .find-id-container input {
        width: 100%;
        background-color: #222;
        border: 1px solid #333;
        color: white;
        padding: 12px 15px;
        border-radius: 6px;
        margin-bottom: 20px;
        transition: border-color 0.2s;
    }

    .find-id-container input:focus {
        outline: none;
        border-color: var(--primary-red);
    }

    .btn-find-submit {
        width: 100%;
        background-color: var(--primary-red);
        color: white;
        border: none;
        padding: 14px;
        border-radius: 6px;
        font-weight: 700;
        transition: background 0.2s;
    }

    .btn-find-submit:hover {
        background-color: var(--primary-red-hover);
    }

    /* 결과 화면 스타일 */
    .id-result-container {
        text-align: center;
    }

    #idMessage {
        display: block;
        color: var(--text-gray);
        margin-bottom: 20px;
        font-size: 1rem;
    }

    #idResultList {
        list-style: none;
        padding: 0;
        margin-bottom: 30px;
        background: rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        overflow: hidden;
    }

    #idResultList li {
        padding: 15px;
        border-bottom: 1px solid var(--border-glass);
        color: var(--primary-red);
        font-weight: 700;
        font-size: 1.1rem;
    }

    #idResultList li:last-child {
        border-bottom: none;
    }

    /* 결과 하단 버튼 그룹 */
    .result-button-group {
        display: flex;
        gap: 10px;
        justify-content: center;
    }

    .result-button-group a, 
    .result-button-group button {
        flex: 1;
        text-decoration: none;
        padding: 12px;
        border-radius: 6px;
        font-weight: 600;
        font-size: 0.9rem;
        cursor: pointer;
        transition: 0.2s;
    }

    #openLoginModal {
        background: var(--text-white);
        color: var(--bg-main);
        border: none;
    }

    #goToFindPwBtn {
        background: transparent;
        border: 1px solid #444;
        color: var(--text-white);
    }

    #goToFindPwBtn:hover {
        background: #333;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
</style>

<div class="find-id-wrapper">
    <!-- 1단계: 입력 폼 -->
    <div id="findIdStep1" class="find-id-container">
        <span class="find-title">아이디 찾기</span>
        <form action="findIdAction.jsp" method="post" id="findIdForm">
            <label for="nickname">등록된 닉네임</label>
            <input type="text" id="nickname" name="nickname" required placeholder="닉네임을 입력하세요">
            <button type="submit" class="btn-find-submit">아이디 찾기</button>
        </form>
    </div>

    <!-- 2단계: 결과 화면 -->
    <div class="id-result-container" id="findIdStep2" style="display: none;">
        <span class="find-title">조회 결과</span>
        <label id="idMessage"></label>
        
        <ul id="idResultList">
            <!-- AJAX 결과가 여기에 삽입됨 -->
        </ul>
        
        <div class="result-button-group">
            <a href="#" id="openLoginModal" data-bs-toggle="modal" data-bs-target="#loginModal">
                로그인하기
            </a>
            <button type="button" id="goToFindPwBtn">
                비밀번호 찾기
            </button>
        </div>
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
                        alert('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                        return;
                    } else if (res.status == 'SUCCESS') {
                        $('#idMessage').html(
                            '<strong style="color:white">' + res.nickname + '</strong>님으로 가입된 아이디는 총 <strong style="color:var(--primary-red)">' + res.count + '</strong>개 입니다.'
                        );
                        
                        $.each(res.idList, function(index, item){
                            $('#idResultList').append('<li>' + item + '</li>');
                        });
                        
                        $('#findIdStep1').hide();
                        $('#findIdStep2').fadeIn(300);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX 요청 중 오류 발생:', error);
                    alert('통신 오류가 발생했습니다.');
                }
            });
        });

        // 비밀번호 초기화 버튼 클릭 시 부모 페이지의 버튼 이벤트 트리거
        $('#goToFindPwBtn').on('click', function() {
            $('#resetPasswordBtn').trigger('click'); 
        });
    });
</script>
