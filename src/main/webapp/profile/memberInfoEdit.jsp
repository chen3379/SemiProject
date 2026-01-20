<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <div class="container">
        <form id="editForm" enctype="multipart/form-data">
            
            <div>
                <img id="photoPreview" src="default_profile.png" alt="프로필 사진" 
                style="width:150px; height:150px; object-fit:cover;" />
                <br>
                <input type="file" id="photoInput" name="photoFile" accept="image/*">
            </div>

            <dl>
                <dt>아이디</dt>
                <dd><input type="text" id="memberId" name="id" readonly></dd>
                <dt>닉네임</dt>
                <dd><input type="text" id="memberNickname" name="nickname" required></dd>
                <dt>이름</dt>
                <dd><input type="text" id="memberName" name="name"></dd>
                <dt>성별</dt>
                <dd>
                    <select id="memberGender" name="gender" class="form-select">
                        <option value="남">남</option>
                        <option value="여">여</option>
                    </select>
                </dd>
                <dt>나이</dt>
                <dd><input type="number" id="memberAge" name="age"></dd>
                <dt>전화번호</dt>
                <dd><input type="text" id="memberHp" name="hp"></dd>
                <dt>주소</dt>
                <dd><input type="text" id="memberAddr" name="addr"></dd>

            </dl>

            <div class="btn-group">
                <button type="submit" id="editBtn">수정 완료</button>
                <button type="button" id="cancelBtn">취소</button>
            </div>
        </form>
    </div>

    <script>
        var urlParams = new URLSearchParams(window.location.search);
        var targetId = urlParams.get('id');

        $(document).ready(function () {

            $('#photoInput').change(function(e) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#photoPreview').attr('src', e.target.result);
                }
                reader.readAsDataURL(e.target.files[0]);
            });

            if (!targetId) {
                alert('잘못된 접근입니다.');
                location.href = 'profilePage.jsp';
                return;
            }

            // 초기 데이터
            $.ajax({
                url: "memberInfoAction.jsp",
                type: "post",
                data: { id: targetId },
                dataType: "json",
                success: function (data) {
                    if (data && data.isMine) {
                        $('#photoPreview').attr('src', data.photo);
                        $('#memberId').val(data.id);
                        $('#memberNickname').val(data.nickname);
                        $('#memberName').val(data.name);
                        $('#memberGender').val(data.gender);
                        $('#memberAge').val(data.age);
                        $('#memberHp').val(data.hp);
                        $('#memberAddr').val(data.addr);
                    } else {
                        alert('권한이 없거나 정보를 불러올 수 없습니다.');
                        location.href = 'profilePage.jsp';
                    }
                },
                error: function () {
                    alert('데이터 통신 오류.');
                }
            });

            // 폼 제출 이벤트
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
                    success: function (res) {
                        if (res.status === "SUCCESS") {
                            alert('회원정보가 수정되었습니다.');
                            location.href = "profilePage.jsp?id=" + targetId;
                        } else {
                            alert('수정에 실패했습니다: ' + (res.message || '알 수 없는 오류'));
                        }
                    },
                    error: function () {
                        alert('데이터 통신 오류.');
                    }
                });
            });
        });
    </script>
    <script>
        $('#cancelBtn').click(function () {
            location.href = "profilePage.jsp?id=" + targetId;
        });
    </script>