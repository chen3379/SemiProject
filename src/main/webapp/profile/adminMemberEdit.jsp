<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    /* [WHATFLIX Profile Edit Style - Admin Version] */
    .edit-content-wrapper {
        max-width: 700px; /* 기본 edit과 폭 동일하게 통일 */
        margin: 0 auto;
        animation: fadeInUp 0.6s var(--ease-smooth);
    }

    .edit-card {
        background: var(--bg-surface);
        border-radius: 16px;
        padding: 40px;
        border: 1px solid var(--border-glass);
    }

    .edit-header {
        margin-bottom: 30px;
        border-bottom: 1px solid var(--border-glass);
        padding-bottom: 15px;
    }

    .edit-header h2 {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-white);
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    /* 관리자 전용 배지 추가 */
    .admin-badge {
        font-size: 0.7rem;
        background: var(--primary-red);
        color: white;
        padding: 2px 8px;
        border-radius: 4px;
        vertical-align: middle;
    }

    /* 프로필 사진 편집 영역 */
    .photo-edit-section {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-bottom: 40px;
    }

    #photoPreview {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid var(--primary-red);
        margin-bottom: 15px;
        box-shadow: 0 0 20px rgba(229, 9, 20, 0.2);
    }

    /* 폼 그리드 레이아웃 */
    .edit-form-grid {
        display: grid;
        grid-template-columns: 120px 1fr;
        gap: 20px 0;
        align-items: center;
    }

    .edit-form-grid dt {
        color: var(--text-gray);
        font-size: 0.9rem;
        font-weight: 500;
    }

    .edit-form-grid dd { margin: 0; }

    .edit-input {
        width: 100%;
        background: #222;
        border: 1px solid #333;
        color: white;
        padding: 10px 15px;
        border-radius: 6px;
        transition: 0.2s;
    }

    .edit-input:focus {
        outline: none;
        border-color: var(--primary-red);
        background: #2a2a2a;
    }

    .edit-input[readonly] {
        background: #1a1a1a;
        color: var(--text-muted);
        border-color: transparent;
        cursor: not-allowed;
    }

    .edit-select {
        appearance: none;
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org' viewBox='0 0 16 16' fill='%23B3B3B3'%3e%3cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: right 1rem center;
        background-size: 16px 12px;
    }

    .form-section-title {
        grid-column: 1 / -1;
        font-size: 0.8rem;
        color: var(--primary-red);
        font-weight: 700;
        margin: 20px 0 10px 0;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .edit-btn-group {
        margin-top: 40px;
        display: flex;
        gap: 12px;
        justify-content: flex-end;
    }

    #submitBtn {
        background: var(--primary-red);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 6px;
        font-weight: 700;
        transition: 0.2s;
        cursor: pointer;
    }

    #cancelBtn {
        background: transparent;
        color: var(--text-white);
        border: 1px solid #444;
        padding: 12px 30px;
        border-radius: 6px;
        font-weight: 500;
        transition: 0.2s;
        cursor: pointer;
    }
</style>

<div class="edit-content-wrapper" data-context-path="${pageContext.request.contextPath}">
    <div class="edit-card shadow-lg">
        <div class="edit-header">
            <h2>회원 상세 관리 <span class="admin-badge">ADMIN</span></h2>
        </div>

        <form id="adminEditForm" enctype="multipart/form-data">
            <!-- 프로필 사진 섹션 -->
            <div class="photo-edit-section">
                <img id="photoPreview" src="${pageContext.request.contextPath}/profile_photo/default_photo.jpg" alt="프로필 사진" />
                <div class="file-input-wrapper">
                    <input type="file" id="photoInput" name="photoFile" accept="image/*" class="form-control form-control-sm bg-dark text-white border-secondary">
                </div>
            </div>

            <dl class="edit-form-grid">
                <!-- [계정 권한 설정] -->
                <div class="form-section-title">Account Security</div>
                
                <dt>아이디</dt>
                <dd><input type="text" id="memberId" name="id" class="edit-input" ></dd>

                <dt>권한 설정</dt>
                <dd>
                    <select id="memberRole" name="roleType" class="edit-input edit-select">
                        <option value="1">일반 회원</option>
                        <option value="8">부관리자</option>
                        <option value="9">최고관리자</option>
                    </select>
                </dd>

                <dt>계정 상태</dt>
                <dd>
                    <select id="memberStatus" name="status" class="edit-input edit-select">
                        <option value="active">활동 중</option>
                        <option value="suspended">이용 정지</option>
                        <option value="withdrawn">탈퇴</option>
                    </select>
                </dd>

                <dt>가입 경로</dt>
                <dd>
                    <select id="memberJoinType" name="joinType" class="edit-input edit-select">
                        <option value="normal">일반 가입</option>
                        <option value="kakao">카카오 소셜</option>
                        <option value="google">구글 소셜</option>
                    </select>
                </dd>

                <!-- [개인 신상 정보] -->
                <div class="form-section-title">Personal Details</div>

                <dt>이름</dt>
                <dd><input type="text" id="memberName" name="name" class="edit-input"></dd>

                <dt>닉네임</dt>
                <dd><input type="text" id="memberNickname" name="nickname" class="edit-input"></dd>

                <dt>연락처</dt>
                <dd><input type="text" id="memberHp" name="hp" class="edit-input"></dd>

                <dt>나이</dt>
                <dd><input type="number" id="memberAge" name="age" class="edit-input"></dd>

                <dt>성별</dt>
                <dd>
                    <select id="memberGender" name="gender" class="edit-input edit-select">
                        <option value="남">남성</option>
                        <option value="여">여성</option>
                    </select>
                </dd>

                <dt>주소</dt>
                <dd><input type="text" id="memberAddr" name="addr" class="edit-input"></dd>
            </dl>

            <div class="edit-btn-group">
                <button type="button" id="cancelBtn">취소/목록</button>
                <button type="submit" id="submitBtn">수정 사항 저장</button>
            </div>
        </form>
    </div>
</div>

<script>
$(document).ready(function () {
    const urlParams = new URLSearchParams(window.location.search);
    const targetId = urlParams.get('id');
    console.log("조회할 대상 ID:", targetId);
    const cp = "${pageContext.request.contextPath}";
    
    // 1. 정보 불러오기 (초기 데이터 세팅)
    if (targetId) {
        $.ajax({
            url: "adminMemberInfoAction.jsp",
            type: "post",
            data: { id: targetId },
            dataType: "json",
            success: function (data) {
                if (data) {
                    $('#memberId').val(data.id);
                    $('#memberRole').val(data.roleType);
                    $('#memberStatus').val(data.status);
                    $('#memberJoinType').val(data.joinType);
                    $('#memberName').val(data.name);
                    $('#memberNickname').val(data.nickname);
                    $('#memberHp').val(data.hp);
                    $('#memberAge').val(data.age);
                    $('#memberGender').val(data.gender);
                    $('#memberAddr').val(data.addr);
                    
                    // 사진 경로 처리
                    let imgSrc = (data.photo && data.photo.trim() !== "") 
                                 ? cp + data.photo 
                                 : cp + "/profile_photo/default_photo.jpg";
                    $('#photoPreview').attr('src', imgSrc);
                }
            }, error: function (xhr, status, error) {
                console.log("상태 코드: " + xhr.status);
                console.log("서버 응답: " + xhr.responseText); // 서버에서 보낸 에러 메시지 확인 가능
                alert('서버와 통신 중 오류가 발생했습니다.');
            }
        });
    }

    // 2. 사진 미리보기 로직
    $('#photoInput').on('change', function() {
        if (this.files && this.files[0]) {
            let reader = new FileReader();
            reader.onload = function(e) {
                $('#photoPreview').attr('src', e.target.result);
            }
            reader.readAsDataURL(this.files[0]);
        }
    });

    // 3. 수정 사항 저장 (폼 제출 이벤트) - 이 부분이 핵심입니다!
    $('#adminEditForm').on('submit', function (e) {
        e.preventDefault(); // 폼의 기본 제출 동작(새로고침)을 반드시 막아야 함

        let formData = new FormData(this); // 파일 포함 모든 데이터 수집

        $.ajax({
            url: "adminMemberEditAction.jsp", // 수정 처리 액션 파일
            type: "post",
            data: formData,
            processData: false,
            contentType: false,
            dataType: "json",
            beforeSend: function() {
                $('#submitBtn').prop('disabled', true).text('저장 중...');
            },
            success: function (res) {
                if (res.status === "SUCCESS") {
                    alert('회원 정보가 성공적으로 수정되었습니다.');
                    // 수정 완료 후 리스트로 돌아가기 (사이드바의 리스트 메뉴 강제 클릭 효과)
                    $('.ajax-nav-link[data-url="adminMember.jsp"]').trigger('click');
                } else {
                    alert('수정 실패: ' + (res.message || '알 수 없는 오류'));
                }
            },
            error: function () {
                alert('서버와 통신 중 오류가 발생했습니다.');
            },
            complete: function() {
                $('#submitBtn').prop('disabled', false).text('수정 사항 저장');
            }
        });
    });

    // 4. 취소 버튼 로직
    $('#cancelBtn').on('click', function () {
        if(confirm('수정을 취소하고 목록으로 돌아가시겠습니까?')) {
            $('.ajax-nav-link[data-url="adminMember.jsp"]').trigger('click');
        }
    });
});

</script>
