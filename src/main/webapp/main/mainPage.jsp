<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>WHATFLIX - Premium Movie Community</title>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

<style>
    /* [Core System] Design Tokens */
    :root {
        /* Layout Dimensions */
        --nav-height: 70px;
        --sidebar-width: 240px;
        
        /* Animation */
        --ease-spring: cubic-bezier(0.175, 0.885, 0.32, 1.275);
        --ease-smooth: cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    /* [Global Reset] */
    body {
        background-color: var(--bg-main);
        color: var(--text-white);
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
        overflow-x: hidden;
        margin: 0;
    }

    a { text-decoration: none; color: inherit; transition: color 0.2s; }
    ul { list-style: none; padding: 0; margin: 0; }

    /* [Layout System] Sticky Nav + Sidebar Grid */
    .app-container {
        display: grid;
        grid-template-columns: 1fr;
        min-height: 100vh;
        padding-top: var(--nav-height); /* Header 높이만큼 띄움 */
    }

    .main-content {
        padding: 40px 50px;
        min-width: 0; /* Grid overflow 방지 */
    }

    /* [Component] Section Headers (Movie & Community) */
    .content-section {
        margin-bottom: 60px;
        opacity: 0;
        animation: fadeInUp 0.6s var(--ease-smooth) forwards;
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }

    .section-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-white);
        letter-spacing: -0.5px;
    }

    .more-link {
        font-size: 0.9rem;
        color: var(--text-gray);
        display: flex;
        align-items: center;
        gap: 5px;
        transition: all 0.2s;
    }

    .more-link:hover {
        color: var(--text-white);
        transform: translateX(5px);
    }
    
    .more-link i { font-size: 0.8rem; }

    /* Animation Keyframes */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    /* Scrollbar Customization */
    ::-webkit-scrollbar { width: 8px; }
    ::-webkit-scrtllbar-track { background: var(--bg-main); }
    ::-webkit-scrollbar-thumb { background: #333; border-radius: 4px; }
    ::-webkit-scrollbar-thumb:hover { background: #555; }

    /* 모바일 대응 (반응형) */
    @media (max-width: 768px) {
        .app-container { grid-template-columns: 1fr; }
        .sidebar-container { display: none; } /* 모바일에서 사이드바 숨김 (또는 햄버거 메뉴로 변경) */
        .main-content { padding: 20px; }
    }
</style>
</head>

<body>
    <jsp:include page="nav.jsp" />
    <jsp:include page="../login/loginModal.jsp" />
    <jsp:include page="../profile/profileModal.jsp"/>

    <div class="app-container">
        <aside class="sidebar-container">
            <%-- <jsp:include page="sideBar.jsp" /> --%>
        </aside>

        <main class="main-content">
            <jsp:include page="movieSection.jsp" />
            <jsp:include page="communitySection.jsp" />
        </main>
    </div>

</body>
</html>