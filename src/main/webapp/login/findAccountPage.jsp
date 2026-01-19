<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WHATFLIX</title>

        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </head>

    <body>
        <header>
            <jsp:include page="../main/nav.jsp" />
            <jsp:include page="../login/loginModal.jsp" />
            <jsp:include page="../profile/profileModal.jsp" />

        </header>
        <main>
            <div class="button-container" id="buttonContainer">
                    <div>
                        <button type="button" id="findIdBtn">아이디 찾기</button>
                    </div>
                    <div>
                        <button type="button" id="resetPasswordBtn">비밀번호 초기화</button>
                    </div>
                </div>
            <div class="content-area" id="contentArea">
            </div>
        </main>
        <script>
            $(document).ready(function () {
                $('#findIdBtn').on('click', function (e) {
                    e.preventDefault();
                    $('#contentArea').load('../login/findId.jsp');
                    $("#buttonContainer").hide();
                });
                $('#resetPasswordBtn').on('click', function (e) {
                    e.preventDefault();
                    $('#contentArea').load('../login/resetPassword.jsp');
                    $("#buttonContainer").hide();
                });
            });
        </script>
    </body>

    </html>