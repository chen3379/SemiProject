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


        <div class="photo-upload">
            <label for="photo">프로필 사진</label>
            <input type="file" id="photo" accept="image/*" onchange="previewImage(this)">
            <div class="preview-container" style="margin-top: 10px;">
                <img id="preview" src="https://ui-avatars.com/api/?color=random&?background=random" alt="기본 프로필" />
            </div>
        </div>
        <div>
            <label for="name">이름</label>
            <input type="text" id="name">
        </div>
        <div>
            <label for="nickname">닉네임</label>
            <input type="text" id="nickname">
        </div>
        <div>
            <label for="email">이메일</label>
            <input type="email" id="email">
        </div>
        <div>
            <label for="hp">전화번호</label>
            <input type="text" id="hp">
        </div>
        <div>
            <label for="addr">주소</label>
            <input type="text" id="addr">
        </div>

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