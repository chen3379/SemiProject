<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<style>
    /* [WHATFLIX Profile Edit Style] */
    .edit-content-wrapper {
        max-width: 700px;
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

    /* 커스텀 파일 업로드 버튼 */
    .file-input-wrapper {
        position: relative;
        overflow: hidden;
        display: inline-block;
    }

    #photoInput {
        font-size: 0.8rem;
        color: var(--text-gray);
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

    .edit-form-grid dd {
        margin: 0;
    }

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

    /* 성별 선택 Select 박스 */
    .edit-select {
        appearance: none;
        background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org' viewBox='0 0 16 16' fill='%23B3B3B3'%3e%3cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3e%3c/svg%3e");
        background-repeat: no-repeat;
        background-position: right 1rem center;
        background-size: 16px 12px;
    }

    /* 버튼 그룹 */
    .edit-btn-group {
        margin-top: 40px;
        display: flex;
        gap: 12px;
        justify-content: flex-end;
    }

    #editBtn {
        background: var(--primary-red);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 6px;
        font-weight: 700;
        transition: 0.2s;
    }

    #editBtn:hover { background: var(--primary-red-hover); }

    #cancelBtn {
        background: transparent;
        color: var(--text-white);
        border: 1px solid #444;
        padding: 12px 30px;
        border-radius: 6px;
        font-weight: 500;
        transition: 0.2s;
    }

    #cancelBtn:hover { background: #333; }
</style>

<div class="edit-content-wrapper" data-context-path="${pageContext.request.contextPath}">
    <div class="edit-card shadow-lg">
        <div class="edit-header">
            <h2>회원정보 수정</h2>
        </div>

        <form id="editForm" enctype="multipart/form-data">
            <!-- 프로필 사진 섹션 -->
            <div class="photo-edit-section">
                <img id="photoPreview" src="default_profile.png" alt="프로필 사진 미리보기" />
                <div class="file-input-wrapper">
                    <input type="file" id="photoInput" name="photoFile" accept="image/*" class="form-control form-control-sm bg-dark text-white border-secondary">
                </div>
            </div>

            <!-- 정보 입력 그리드 -->
            <dl class="edit-form-grid">
                <dt>아이디</dt>
                <dd><input type="text" id="memberId" name="id" class="edit-input" readonly></dd>

                <dt>닉네임</dt>
                <dd><input type="text" id="memberNickname" name="nickname" class="edit-input" placeholder="닉네임을 입력하세요" required></dd>

                <dt>이름</dt>
                <dd><input type="text" id="memberName" name="name" class="edit-input" placeholder="성함"></dd>

                <dt>성별</dt>
                <dd>
                    <select id="memberGender" name="gender" class="edit-input edit-select">
                        <option value="남">남성</option>
                        <option value="여">여성</option>
                    </select>
                </dd>

                <dt>나이</dt>
                <dd><input type="number" id="memberAge" name="age" class="edit-input" placeholder="나이"></dd>

                <dt>전화번호</dt>
                <dd><input type="text" id="memberHp" name="hp" class="edit-input" placeholder="010-0000-0000"></dd>

                <dt>주소</dt>
                <dd><input type="text" id="memberAddr" name="addr" class="edit-input" placeholder="주소를 입력하세요"></dd>
            </dl>

            <div class="edit-btn-group">
                <button type="button" id="cancelBtn">취소</button>
                <button type="submit" id="editBtn">수정 완료</button>
            </div>
        </form>
    </div>
</div>

<script>
    var urlParams = new URLSearchParams(window.location.search);
    var targetId = urlParams.get('id');

    $(document).ready(function () {
        // 사진 미리보기 로직 유지
        $('#photoInput').change(function(e) {
            if (this.files && this.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#photoPreview').attr('src', e.target.result);
                }
                reader.readAsDataURL(this.files[0]);
            }
        });

        if (!targetId) {
            alert('잘못된 접근입니다.');
            location.href = 'profilePage.jsp';
            return;
        }

        // 초기 데이터 로드 로직 유지
        $.ajax({
            url: "memberInfoAction.jsp",
            type: "post",
            data: { id: targetId },
            dataType: "json",
            success: function (data) {
                if (data && data.isMine) {
                    const contextPath = $('.edit-content-wrapper').data('context-path');
                    $('#photoPreview').attr('src', contextPath + data.photo);
                    $('#memberId').val(data.id);
                    $('#memberNickname').val(data.nickname);
                    $('#memberName').val(data.name);
                    $('#memberGender').val(data.gender);
                    $('#memberAge').val(data.age);
                    $('#memberHp').val(data.hp);
                    $('#memberAddr').val(data.addr);
                } else {
                    alert('권한이 없거나 정보를 불러올 수 없습니다.');
                    location.href = 'profilePage.jsp?id=' + targetId;
                }
            },
            error: function () {
                alert('데이터 로드 실패: 서버 통신 오류');
            }
        });

        // 폼 제출 로직 유지
        $('#editForm').submit(function (e) {
            e.preventDefault();
            var formData = new FormData(this);

            $.ajax({
                url: "memberInfoEditAction.jsp",
                type: "post",
                data: formData,
                processData: false,
                contentType: false,
                dataType: "json",
                beforeSend: function() {
                    $('#editBtn').prop('disabled', true).text('저장 중...');
                },
                success: function (res) {
                    if (res.status === "SUCCESS") {
                        alert('회원정보가 성공적으로 수정되었습니다.');
                        location.href = "profilePage.jsp?id=" + targetId;
                    } else {
                        alert('수정 실패: ' + (res.message || '알 수 없는 오류'));
                    }
                },
                error: function () {
                    alert('통신 오류가 발생했습니다.');
                },
                complete: function() {
                    $('#editBtn').prop('disabled', false).text('수정 완료');
                }
            });
        });

        $('#cancelBtn').click(function () {
            location.href = "profilePage.jsp?id=" + targetId;
        });
    });
</script>
