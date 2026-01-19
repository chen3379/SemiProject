<!-- 
 회원가입 페이지 
 
-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WHATFLIX</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    </head>


    <body>
        <header>
            <jsp:include page="../main/nav.jsp" />
            <jsp:include page="../login/loginModal.jsp" />

        </header>
        <main>
            <div>
                <h3>회원가입</h3>
            </div>
            <div id="selection-area">
                <div>
                    <button class="btn-load-form" data-type="general">WHATFLIX 회원가입 하기</button>
                </div>
                <div>
                    <h3>소셜 계정으로 가입하기</h3>
                    <button class="btn-load-form" data-type="google">구글</button>
                    <button class="btn-load-form" data-type="kakao">카카오</button>
                    <button class="btn-load-form" data-type="naver">네이버</button>
                </div>
            </div>
            <div id="form-area" style="display: none;">

            </div>
            <!-- 일반 회원 가입 클릭시 폼 불러오기 -->
            <script>

                $(document).ready(function () {
                    
                    $('.btn-load-form').on('click', function () {
                        var type = $(this).data('type');
                        loadForm(type);
                    });
                });
                function loadForm(type) {
                    var url = '';
                    if (type === 'general') {
                        url = 'generalSignUpForm.jsp';
                    } else {
                        url = 'socialSignUpForm.jsp?provider=' + type;
                    }

                    $.ajax({
                        url: url,
                        type: 'GET',
                        dataType: 'html',
                        success: function (html) {
                            $('#selection-area').hide();
                            $('#form-area').html(html);
                            $('#form-area').show();
                        },
                        error: function () {
                            alert('error');
                        }
                    });
                }
            </script>
        </main>
        <footer>
            <jsp:include page="../main/footer.jsp"></jsp:include>
        </footer>
    </body>

    </html>