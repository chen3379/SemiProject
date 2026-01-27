<%@page import="config.SecretConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@page import="config.SecretConfig"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WHATFLIX - JOIN US</title>
    
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
	
    <style>
        /* [Core System] WHATFLIX Design Tokens */
        :root {
            --primary-red: #E50914;
            --primary-red-hover: #B20710;
            --bg-main: #141414;
            --bg-surface: #181818;
            --border-glass: rgba(255, 255, 255, 0.1);
            --text-white: #FFFFFF;
            --text-gray: #B3B3B3;
            --nav-height: 70px;
        }

        body {
            background-color: var(--bg-main);
            color: var(--text-white);
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            min-height: 100vh;
        }

        /* [Layout] 회원가입 전용 컨테이너 */
        .signup-container {
            max-width: 500px;
            margin: 100px auto;
            padding: 40px;
            animation: fadeInUp 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        .signup-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .signup-header h3 {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -1px;
        }

        /* [Selection Area] 버튼 스타일링 */
        #selection-area {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .btn-general-signup {
            width: 100%;
            background-color: var(--primary-red);
            color: white;
            border: none;
            padding: 15px;
            font-size: 1.1rem;
            font-weight: 700;
            border-radius: 4px;
            transition: all 0.3s;
            margin-bottom: 30px;
        }

        .btn-general-signup:hover {
            background-color: var(--primary-red-hover);
            transform: translateY(-2px);
        }

        .social-title {
            font-size: 0.9rem;
            color: var(--text-gray);
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
        }

        .social-title::after, .social-title::before {
            content: "";
            flex: 1;
            height: 1px;
            background-color: var(--border-glass);
        }

        .social-group {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 12px;
        }

        /* 소셜 버튼 공통 */
        .btn-load-form {
            padding: 12px;
            border: 1px solid var(--border-glass);
            background: var(--bg-surface);
            color: white;
            border-radius: 4px;
            font-weight: 600;
            transition: 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-load-form:hover {
            background: #252525;
            border-color: #555;
        }

        /* 소셜 포인트 컬러 (아이콘 느낌) */
        .btn-google:hover { border-color: #4285F4; color: #4285F4; }
        .btn-kakao:hover { border-color: #FEE500; color: #FEE500; }
        .btn-naver:hover { border-color: #03C75A; color: #03C75A; }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        #form-area {
            background: var(--bg-surface);
            padding: 30px;
            border-radius: 8px;
            border: 1px solid var(--border-glass);
        }
    </style>
</head>

<body>
    <header>
        <jsp:include page="../main/nav.jsp" />
        <jsp:include page="../login/loginModal.jsp" />
    </header>

    <main class="container">
        <div class="signup-container">
            <div id="selection-area">
                <div class="signup-header">
                    <h3>회원가입</h3>
                    <p class="text-muted small mt-2">WHATFLIX의 프리미엄 서비스를 시작해보세요.</p>
                </div>

                <button class="btn-load-form btn-general-signup" data-type="general">
                    <i class="bi bi-envelope-fill me-2"></i>이메일로 가입하기
                </button>

                <div class="social-title">소셜 계정으로 간편 가입</div>
                
                <div class="social-group">
                    <button class="btn-load-form btn-google" data-type="google">
                        <i class="bi bi-google"></i>구글
                    </button>
                  	<a href="<%=request.getContextPath()%>/login/kakaoLogin.jsp"
					   class="btn-load-form btn-kakao">
					   <i class="bi bi-chat-fill"></i>카카오
					</a>
                    <button class="btn-load-form btn-naver" data-type="naver">
                        <i class="bi bi-bootstrap-reboot"></i>네이버
                    </button>
                </div>
            </div>

            <!-- 폼이 동적으로 로드되는 영역 -->
            <div id="form-area" style="display: none;"></div>
        </div>
    </main>

    <footer>
        <jsp:include page="../main/footer.jsp" />
    </footer>

    <script>
        $(document).ready(function () {
            // 버튼 클릭 이벤트 바인딩
            $(document).on('click', '.btn-load-form', function () {
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
                beforeSend: function() {
                    // 로딩 피드백 (선택사항)
                },
                success: function (html) {
                    $('#selection-area').fadeOut(300, function() {
                        $('#form-area').html(html).fadeIn(400);
                        // 페이지 상단으로 스크롤
                        window.scrollTo({ top: 0, behavior: 'smooth' });
                    });
                },
                error: function (xhr) {
                    console.error("Form Load Error:", xhr.status);
                    alert('가입 양식을 불러오는 중 오류가 발생했습니다.');
                }
            });
        }
    </script>
</body>
</html>
