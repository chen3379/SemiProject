<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WHATFLIX - MY PROFILE</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <style>
        /* [Core System] WHATFLIX Design Tokens */
        :root {
            --primary-red: #E50914;
            --bg-main: #141414;
            --bg-surface: #181818;
            --border-glass: rgba(255, 255, 255, 0.1);
            --text-white: #FFFFFF;
            --text-gray: #B3B3B3;
            --nav-height: 70px;
            --sidebar-width: 280px; /* 프로필용 사이드바는 조금 더 넓게 설정 */
        }

        body {
            background-color: var(--bg-main);
            color: var(--text-white);
            font-family: 'Pretendard', sans-serif;
            margin: 0;
            overflow-x: hidden;
        }

        /* [Layout System] 메인 페이지와 동일한 구조 유지 */
        .app-container {
            display: grid;
            grid-template-columns: var(--sidebar-width) 1fr;
            min-height: 100vh;
            padding-top: var(--nav-height);
        }

        /* 좌측 사이드바 영역 */
        #side-nav {
            border-right: 1px solid var(--border-glass);
            padding: 40px 20px;
            background-color: var(--bg-main);
        }

        /* 우측 콘텐츠 영역 */
        #content-area {
            padding: 40px 60px;
            background-color: var(--bg-main);
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 하단 여백용 컨테이너 */
        #mainContentArea {
            padding: 0 60px 60px 60px;
        }

        /* 모바일 대응 */
        @media (max-width: 992px) {
            .app-container {
                grid-template-columns: 1fr;
            }
            #side-nav {
                border-right: none;
                border-bottom: 1px solid var(--border-glass);
                padding: 20px;
            }
            #content-area {
                padding: 30px 20px;
            }
        }
    </style>
</head>

<body>
    <!-- 공용 컴포넌트 포함 -->
    <header>
        <jsp:include page="../main/nav.jsp" />
        <jsp:include page="../login/loginModal.jsp" />
        <jsp:include page="../profile/profileModal.jsp" />
    </header>

    <!-- WHATFLIX 레이아웃 컨테이너 -->
    <div class="app-container">
        <!-- 좌측 프로필 네비게이션 -->
        <aside id="side-nav">
            <jsp:include page="profileNav.jsp" />
        </aside>

        <!-- 우측 상세 정보 콘텐츠 -->
        <main id="content-area">
            <jsp:include page="memberInfo.jsp" />
            
            <!-- 추가 동적 콘텐츠 영역 -->
            <div id="mainContentArea"></div>
        </main>
    </div>

    <footer>
        <jsp:include page="../main/footer.jsp" />
    </footer>
</body>
</html>

