<%@ page import="member.MemberDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<style>
    .nav-container ul { list-style: none; padding: 0; margin: 0; }
    .menu-group { border-bottom: 1px solid #f0f0f0; }
    
    /* 주메뉴 스타일 */
    .nav-link {
        display: block;
        padding: 12px 15px;
        text-decoration: none;
        color: #333;
        font-weight: 500;
        cursor: pointer;
    }
    .nav-link:hover { background-color: #f8f9fa; }

    /* 하위 메뉴 스타일 (기본 숨김) */
    .sub-menu {
        display: none; 
        background-color: #fcfcfc;
        padding-bottom: 5px;
    }
    .sub-menu li a {
        display: block;
        padding: 10px 30px; /* 들여쓰기 */
        color: #666;
        font-size: 14px;
        text-decoration: none;
    }
    .sub-menu li a:hover { color: #000; background-color: #f1f1f1; }

    /* 화살표 애니메이션 */
    .arrow { float: right; font-size: 10px; transition: transform 0.3s; }
    .menu-group.active .arrow { transform: rotate(180deg); }
    
    hr { border: 0; border-top: 1px solid #eee; margin: 10px 0; }
</style>

<div class="nav-container">
    <hr>
    <ul>
        <% 
            Object obj = session.getAttribute("memberInfo");
            MemberDto member = null;
            if (obj != null) { member = (MemberDto) obj; }
        %>
        
        <li class="menu-group">
            <a href="#" class="nav-link ajax-nav-link" data-url="memberInfo.jsp?id=${sessionScope.memberInfo.id}">
                회원정보
            </a>
        </li>

        <li class="menu-group">
            <a href="#" class="nav-link menu-trigger">내 영화 <span class="arrow">▼</span></a>
            <ul class="sub-menu">
                <li><a href="#" class="nav-link ajax-nav-link" data-url="myRatings.jsp">별점 목록</a></li>
                <li><a href="#" class="nav-link ajax-nav-link" data-url="myWishlist.jsp">찜한 영화</a></li>
            </ul>
        </li>

        <li class="menu-group">
            <a href="#" class="nav-link menu-trigger">내 게시글 <span class="arrow">▼</span></a>
            <ul class="sub-menu">
                <li><a href="#" class="nav-link ajax-nav-link" data-url="myPosts.jsp">커뮤니티</a></li>
                <li><a href="#" class="nav-link ajax-nav-link" data-url="myComments.jsp">QnA</a></li>
            </ul>
        </li>

        <% 
            if (member != null) {
                String roleType = member.getRoleType();
                if ("8".equals(roleType) || "9".equals(roleType)) { 
        %>
        <li class="menu-group admin-menu">
            <hr>
            <a href="#" class="nav-link menu-trigger" style="color: #d9534f;">시스템 관리 <span class="arrow">▼</span></a>
            <ul class="sub-menu">
                <li><a href="#" class="nav-link ajax-nav-link" data-url="memberList.jsp">회원 관리</a></li>
                <li><a href="#" class="nav-link ajax-nav-link" data-url="movieList.jsp">영화 관리</a></li>
                <li><a href="#" class="nav-link ajax-nav-link" data-url="communityList.jsp">커뮤니티 관리</a></li>
                <li><a href="#" class="nav-link ajax-nav-link" data-url="qnaList.jsp">QnA 관리</a></li>
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
        
        // 클릭한 메뉴가 이미 열려있는지 확인
        var isOpen = $subMenu.is(':visible');

        // 모든 메뉴를 닫고 active 클래스 제거 (아코디언 기능)
        $('.sub-menu').slideUp(250);
        $('.menu-group').removeClass('active');

        // 클릭한 메뉴가 닫혀있었다면 열기
        if (!isOpen) {
            $subMenu.slideDown(250);
            $parent.addClass('active');
        }
    });

    // [B] AJAX 페이지 로드 로직 (통합 처리)
    // .ajax-nav-link 클래스를 가진 모든 링크에 적용
    $(document).on('click', '.ajax-nav-link', function (e) {
        e.preventDefault();
        var targetUrl = $(this).data('url');

        if (targetUrl && targetUrl.trim() !== "") {
            $contentArea.load(targetUrl, function (response, status, xhr) {
                if (status == "error") {
                    $contentArea.html("<div style='padding:20px;'>오류 발생: " + xhr.status + " " + xhr.statusText + "</div>");
                } else {
                    console.log(targetUrl + " 로드 완료");
                }
            });
        }
    });
});
</script>
