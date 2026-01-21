<%@ page import="member.MemberDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<style>
    /* [WHATFLIX Profile Side Navigation Update] */
    .nav-container {
        padding: 10px;
    }

    .nav-container ul { list-style: none; padding: 0; margin: 0; }
    
    .menu-group { 
        margin-bottom: 5px;
        border-radius: 8px;
        overflow: hidden;
    }
    
    /* 주메뉴 스타일 - 가독성 향상 */
    .nav-link {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 14px 18px;
        text-decoration: none;
        color: #FFFFFF !important; /* 순백색으로 가독성 확보 */
        font-weight: 600;
        font-size: 1rem;
        transition: all 0.2s ease;
        opacity: 0.85;
    }
    
    .nav-link:hover { 
        background-color: rgba(255, 255, 255, 0.1); 
        opacity: 1;
        color: var(--primary-red) !important;
    }

    /* 하위 메뉴 스타일 (기본 숨김) */
    .sub-menu {
        display: none; 
        background-color: rgba(255, 255, 255, 0.03); /* 약간 밝은 배경으로 구분 */
        padding: 5px 0;
    }

    .sub-menu li a {
        display: block;
        padding: 10px 45px; /* 더 깊은 들여쓰기 */
        color: var(--text-gray) !important;
        font-size: 0.9rem;
        text-decoration: none;
        transition: 0.2s;
    }

    .sub-menu li a:hover { 
        color: var(--primary-red) !important; 
        background-color: rgba(255, 255, 255, 0.05); 
    }

    /* 관리자 메뉴 전용 포인트 */
    .admin-menu .menu-trigger {
        color: var(--primary-red) !important;
        border-top: 1px solid var(--border-glass);
        margin-top: 15px;
        padding-top: 20px;
    }

    /* 화살표 애니메이션 */
    .arrow { 
        font-size: 0.7rem; 
        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        color: var(--text-muted);
    }
    .menu-group.active .arrow { transform: rotate(180deg); color: var(--primary-red); }
    
    hr { border: 0; border-top: 1px solid var(--border-glass); margin: 15px 0; opacity: 0.3; }
</style>

<div class="nav-container">
    <ul>
        <% 
            Object obj = session.getAttribute("memberInfo");
            MemberDto member = null;
            if (obj != null) { member = (MemberDto) obj; }
        %>
        
        <!-- [1] 회원정보 (단일 링크) -->
        <li class="menu-group">
            <a href="#" class="nav-link ajax-nav-link" data-url="memberInfo.jsp?id=${sessionScope.memberInfo.id}">
                <span><i class="bi bi-person-circle me-2"></i>회원정보</span>
            </a>
        </li>

        <!-- [2] 내 영화 (아코디언) -->
        <li class="menu-group">
            <a href="#" class="nav-link menu-trigger">
                <span><i class="bi bi-film me-2"></i>내 영화</span>
                <span class="arrow">▼</span>
            </a>
            <ul class="sub-menu">
                <li><a href="#" class="ajax-nav-link" data-url="myRating.jsp">별점 목록</a></li>
                <li><a href="#" class="ajax-nav-link" data-url="myWishlist.jsp">찜한 영화</a></li>
            </ul>
        </li>

        <!-- [3] 내 게시글 (아코디언) -->
        <li class="menu-group">
            <a href="#" class="nav-link menu-trigger">
                <span><i class="bi bi-chat-left-dots me-2"></i>내 게시글</span>
                <span class="arrow">▼</span>
            </a>
            <ul class="sub-menu">
                <li><a href="#" class="ajax-nav-link" data-url="myPost.jsp">커뮤니티</a></li>
                <li><a href="#" class="ajax-nav-link" data-url="myComment.jsp">QnA</a></li>
            </ul>
        </li>

        <% 
            if (member != null) {
                String roleType = member.getRoleType();
                // 8 또는 9 권한 관리자
                if ("8".equals(roleType) || "9".equals(roleType)) { 
        %>
        <!-- [4] 시스템 관리 (관리자 전용) -->
        <li class="menu-group admin-menu">
            <a href="#" class="nav-link menu-trigger">
                <span><i class="bi bi-gear-fill me-2"></i>시스템 관리</span>
                <span class="arrow">▼</span>
            </a>
            <ul class="sub-menu">
                <li><a href="#" class="ajax-nav-link" data-url="adminMember.jsp">회원 관리</a></li>
                <li><a href="#" class="ajax-nav-link" data-url="adminMovieList.jsp">영화 관리</a></li>
                <li><a href="#" class="ajax-nav-link" data-url="adminCommunityList.jsp">커뮤니티 관리</a></li>
                <li><a href="#" class="ajax-nav-link" data-url="adminQnaList.jsp">QnA 관리</a></li>
            </ul>
        </li>
        <% 
                } 
            } 
        %>
    </ul>
</div>

<script>
$(document).ready(function () {
    var $contentArea = $('#content-area');

    // [A] 아코디언 토글 로직
    $('.menu-trigger').on('click', function (e) {
        e.preventDefault();
        var $parent = $(this).closest('.menu-group');
        var $subMenu = $parent.find('.sub-menu');
        
        var isOpen = $subMenu.is(':visible');

        // 다른 열려있는 메뉴 닫기 (아코디언 애니메이션 최적화)
        $('.sub-menu').not($subMenu).slideUp(250);
        $('.menu-group').not($parent).removeClass('active');

        if (!isOpen) {
            $subMenu.slideDown(250);
            $parent.addClass('active');
        } else {
            $subMenu.slideUp(250);
            $parent.removeClass('active');
        }
    });

    // [B] AJAX 페이지 로드 로직
    $(document).on('click', '.ajax-nav-link', function (e) {
        e.preventDefault();
        var targetUrl = $(this).data('url');

        // 클릭된 링크 강조 효과
        $('.ajax-nav-link').css('color', '');
        $(this).css('color', 'var(--primary-red)');

        if (targetUrl && targetUrl.trim() !== "") {
            $contentArea.fadeOut(150, function() {
                $contentArea.load(targetUrl, function (response, status, xhr) {
                    if (status == "error") {
                        $contentArea.html("<div class='p-4 text-danger'>오류 발생: " + xhr.status + "</div>");
                    }
                    $contentArea.fadeIn(150);
                });
            });
        }
    });
});
</script>
