<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WHATFLIX</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <style>
            .photo-upload {
                margin-top: 15px;
                margin-bottom: 20px;
            }

            .preview-container {
                display: flex;
                justify-content: center;
                align-items: center;
            }
        </style>
    </head>

    <body>

        <form action="">
        <div class="photo-upload">
            <label for="photo">프로필 사진</label>
            <input type="file" id="photo" accept="image/*" onchange="previewImage(this)">
            <div class="preview-container" style="margin-top: 10px;">
                <img id="preview" src="https://ui-avatars.com/api/?
                color=random&
                background=random&
                name=${sessionScope.memberInfo.nickname}" alt="기본 프로필" />
            </div>
        </div>
        <dl>
            <dt>회원번호</dt>
            <dd><span>${sessionScope.memberInfo.memberIdx}</span></dd>
            <dt>아이디</dt>
            <dd id="memberId">
                <span>${sessionScope.memberInfo.id}</span>
            </dd>
            <dt>비밀번호</dt>
            <dd>
                <input type="password" value="" id="memberPassword" required>
            </dd>
            <dt>닉네임</dt>
            <dd>
                <input type="text" value="${sessionScope.memberInfo.nickname}" id="memberNickname">
            </dd>
            <dt>이름</dt>
            <dd>
                <input type="text" value="${sessionScope.memberInfo.name}" id="memberName">
            </dd>
            <dt>성별</dt>
            <dd>
                <input type="text" value="${sessionScope.memberInfo.gender}" id="memberGender">
            </dd>
            <dt>나이</dt>
            <dd>
                <input type="text" value="${sessionScope.memberInfo.age}" id="memberAge">
            </dd>
            <dt>전화번호</dt>
            <dd>
                <input type="text" value="${sessionScope.memberInfo.hp}" id="memberHp">
            </dd>
            <dt>주소</dt>
            <dd>    
                <input type="text" value="${sessionScope.memberInfo.addr}" id="memberAddr">
            </dd>
            <dt>가입일</dt>
            <dd>
                <span>${sessionScope.memberInfo.createDay}</span>
            </dd>
        </dl>
        </form>
        <!-- 프로필 사진 미리보기 js -->
        <script>
            function previewImage(input) {
                var preview = document.getElementById('preview');
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                    }
                    reader.readAsDataURL(input.files[0]);
                } else {
                    preview.src = "";
                    preview.style.display = 'none';
                }
            }
        </script>
        
    </body>

    </html>