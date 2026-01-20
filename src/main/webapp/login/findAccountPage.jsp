<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WHATFLIX - Account Support</title>

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

        /* [Layout] 중앙 정렬 컨테이너 */
        .account-support-wrapper {
            max-width: 600px;
            margin: 120px auto;
            padding: 20px;
            animation: fadeInUp 0.6s ease-out;
        }

        .support-header {
            text-align: center;
            margin-bottom: 50px;
        }

        .support-header h2 {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: -1.5px;
            margin-bottom: 10px;
        }

        .support-header p {
            color: var(--text-gray);
            font-size: 1rem;
        }

        /* [Button Container] 선택 카드 스타일 */
        .button-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .support-card-btn {
            background: var(--bg-surface);
            border: 1px solid var(--border-glass);
            border-radius: 12px;
            padding: 40px 20px;
            color: var(--text-white);
            text-align: center;
            transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            cursor: pointer;
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }

        .support-card-btn i {
            font-size: 2.5rem;
            color: var(--text-gray);
            transition: color 0.3s;
        }

        .support-card-btn span {
            font-size: 1.1rem;
            font-weight: 600;
        }

        .support-card-btn:hover {
            transform: translateY(-8px);
            background: #222;
            border-color: var(--primary-red);
        }

        .support-card-btn:hover i {
            color: var(--primary-red);
        }

        /* 동적 콘텐츠 영역 */
        #contentArea {
            background: var(--bg-surface);
            border-radius: 16px;
            padding: 40px;
            border: 1px solid var(--border-glass);
            display: none; /* JS에서 로드 시 노출 */
            animation: fadeIn 0.4s ease-in;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        /* 모바일 대응 */
        @media (max-width: 576px) {
            .button-container { grid-template-columns: 1fr; }
            .support-header h2 { font-size: 1.8rem; }
        }
    </style>
</head>

<body>
    <header>
        <jsp:include page="../main/nav.jsp" />
        <jsp:include page="../login/loginModal.jsp" />
        <jsp:include page="../profile/profileModal.jsp" />
    </header>

    <main class="container">
        <div class="account-support-wrapper">
            <div id="main-view">
                <div class="support-header">
                    <h2>로그인에 문제가 있나요?</h2>
                    <p>도움이 필요한 항목을 선택해 주세요.</p>
                </div>

                <div class="button-container" id="buttonContainer">
                    <button type="button" id="findIdBtn" class="support-card-btn">
                        <i class="bi bi-person-badge"></i>
                        <span>아이디 찾기</span>
                    </button>
                    
                    <button type="button" id="resetPasswordBtn" class="support-card-btn">
                        <i class="bi bi-shield-lock"></i>
                        <span>비밀번호 초기화</span>
                    </button>
                </div>
            </div>

            <!-- AJAX로 로드되는 실제 폼 영역 -->
            <div class="content-area" id="contentArea"></div>
        </div>
    </main>

    <script>
        $(document).ready(function () {
            // 아이디 찾기 로드 로직 보존
            $('#findIdBtn').on('click', function (e) {
                e.preventDefault();
                $('#contentArea').load('../login/findId.jsp', function() {
                    $("#main-view").fadeOut(200, function() {
                        $('#contentArea').fadeIn(300);
                    });
                });
            });

            // 비밀번호 초기화 로드 로직 보존
            $('#resetPasswordBtn').on('click', function (e) {
                e.preventDefault();
                $('#contentArea').load('../login/resetPassword.jsp', function() {
                    $("#main-view").fadeOut(200, function() {
                        $('#contentArea').fadeIn(300);
                    });
                });
            });
        });
    </script>
</body>
</html>
