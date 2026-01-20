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
        <div class="member-photo">
            <label for="photo">프로필 사진</label>
            <div class="preview-container" style="margin-top: 10px;">
                <img id="preview" src="" alt="기본 프로필" />
            </div>
        </div>

        <div class="private-info">   
            <dl>
            <dt>회원번호</dt>
            <dd><span id="memberIdx"></span></dd>
            <dt>아이디</dt>
            <dd><span id="memberId"></span></dd>
            <dt>닉네임</dt>
            <dd><span id="memberNickname"></span></dd>
            <dt>이름</dt>
            <dd><span id="memberName"></span></dd>
            <dt>성별</dt>
            <dd><span id="memberGender"></span></dd>
            <dt>나이</dt>
            <dd><span id="memberAge"></span></dd>
            <dt>전화번호</dt>
            <dd><span id="memberHp"></span></dd>
            <dt>이메일</dt>
            <dd><span id="memberEmail"></span></dd>
            <dt>주소</dt>
            <dd><span id="memberAddr"></span></dd>
            <dt>가입일</dt>
            <dd><span id="memberCreateDay"></span></dd>
        </dl>
        </div>
        <div>
            <button type="button" class="btn btn-primary">회원정보 수정</button>
            <button type="button" class="btn btn-danger">탈퇴</button>
        </div>

        <script>

            $(document).ready(function() {
                $.ajax({
                    url: "memberProfileAction",
                    type: "post",
                    success: function(data) {
                        
                    }
                })
            })
        </script>
    </body>

    </html>