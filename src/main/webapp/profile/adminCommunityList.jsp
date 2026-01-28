<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="board.free.FreeBoardDto" %>
<%@ page import="board.review.ReviewBoardDto" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%-- 1. 데이터 로드 액션 포함 --%>
<jsp:include page="adminCommunityListAction.jsp" />

<%
    List<FreeBoardDto> freeList = (List<FreeBoardDto>) request.getAttribute("adminFreeList");
    List<ReviewBoardDto> reviewList = (List<ReviewBoardDto>) request.getAttribute("adminReviewList");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>

<style>
    .board-management-section {
        animation: fadeInUp 0.5s ease-out;
    }

    .board-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .board-title { font-size: 1.4rem; font-weight: 700; color: #fff; margin: 0; }

    /* Search Bar */
    .search-container {
        position: relative;
        width: 300px;
    }

    .search-input {
        width: 100%;
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 20px;
        padding: 8px 15px 8px 40px;
        color: #fff;
        font-size: 0.9rem;
        outline: none;
        transition: 0.3s;
    }

    .search-input:focus {
        border-color: #E50914;
        background: rgba(255, 255, 255, 0.08);
    }

    .search-icon {
        position: absolute;
        left: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: #777;
    }

    /* Tabs */
    .nav-tabs {
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        gap: 10px;
    }

    .nav-link {
        color: #B3B3B3 !important;
        border: none !important;
        padding: 10px 20px !important;
        font-weight: 600;
        transition: 0.3s;
    }

    .nav-link:hover { color: #fff !important; }

    .nav-link.active {
        background: transparent !important;
        color: #E50914 !important;
        border-bottom: 2px solid #E50914 !important;
    }

    /* List Style */
    .post-list { 
        margin-top: 20px;
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .post-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: #181818;
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        padding: 15px 20px;
        transition: 0.2s;
    }

    .post-item:hover {
        background: rgba(255, 255, 255, 0.03);
        border-color: rgba(255, 255, 255, 0.2);
        transform: translateX(5px);
    }

    .post-info { flex: 1; }
    .post-category { 
        font-size: 0.75rem; 
        color: #E50914; 
        font-weight: 700; 
        margin-bottom: 4px;
        display: block;
    }
    .post-title { 
        font-size: 1rem; 
        color: #fff; 
        font-weight: 500; 
        text-decoration: none; 
    }
    .post-meta { 
        font-size: 0.8rem; 
        color: #666; 
        margin-top: 5px; 
    }
    .author-badge {
        display: inline-block;
        padding: 2px 8px;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 12px;
        margin-left: 10px;
        font-size: 0.75rem;
        color: #bbb;
    }

    .post-actions {
        display: flex;
        gap: 8px;
    }

    .btn-action {
        padding: 6px 12px;
        border-radius: 4px;
        font-size: 0.8rem;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
        text-decoration: none;
    }

    .btn-delete {
        background: rgba(229, 9, 20, 0.1);
        color: #E50914;
        border: 1px solid rgba(229, 9, 20, 0.2);
    }

    .btn-delete:hover { background: #E50914; color: #fff; }

    .empty-state {
        text-align: center;
        padding: 50px 0;
        color: #666;
    }
</style>
<jsp:include page="../common/customConfirm.jsp" />
<div class="board-management-section">
    <div class="board-header">
        <h2 class="board-title">커뮤니티 관리 (관리자)</h2>
        
        <div class="search-container">
            <i class="bi bi-search search-icon"></i>
            <input type="text" id="adminPostSearch" class="search-input" 
                   placeholder="글 제목 또는 내용 검색" value="<%=searchKeyword%>"
                   onkeyup="if(window.event.keyCode==13){searchAdminPosts()}">
        </div>
    </div>

    <!-- Tab Menu -->
    <ul class="nav nav-tabs" id="adminBoardTabs" role="tablist">
        <li class="nav-item">
            <button class="nav-link active" id="admin-free-tab" data-bs-toggle="tab" data-bs-target="#admin-free-posts" type="button">자유게시판 (<%=freeList.size()%>)</button>
        </li>
        <li class="nav-item">
            <button class="nav-link" id="admin-review-tab" data-bs-toggle="tab" data-bs-target="#admin-review-posts" type="button">리뷰게시판 (<%=reviewList.size()%>)</button>
        </li>
    </ul>

    <div class="tab-content" id="adminBoardTabsContent">
        <!-- Free Board Posts -->
        <div class="tab-pane fade show active" id="admin-free-posts" role="tabpanel">
            <div class="post-list">
                <% if(freeList.isEmpty()) { %>
                    <div class="empty-state">검색 결과가 없습니다.</div>
                <% } else { 
                    for(FreeBoardDto dto : freeList) { %>
                    <div class="post-item">
                        <div class="post-info">
                            <span class="post-category"><%=dto.getCategory_type()%></span>
                            <a href="../board/free/detail.jsp?board_idx=<%=dto.getBoard_idx()%>" target="_blank" class="post-title"><%=dto.getTitle()%></a>
                            <span class="author-badge"><%=dto.getId()%></span>
                            <div class="post-meta">
                                <span>조회 <%=dto.getReadcount()%></span> • 
                                <span>작성일 <%=sdf.format(dto.getCreate_day())%></span>
                            </div>
                        </div>
                        <div class="post-actions">
                            <button onclick="deleteAdminPost('free', <%=dto.getBoard_idx()%>)" class="btn-action btn-delete">강제 삭제</button>
                        </div>
                    </div>
                <% } } %>
            </div>
        </div>

        <!-- Review Board Posts -->
        <div class="tab-pane fade" id="admin-review-posts" role="tabpanel">
            <div class="post-list">
                <% if(reviewList.isEmpty()) { %>
                    <div class="empty-state">검색 결과가 없습니다.</div>
                <% } else { 
                    for(ReviewBoardDto dto : reviewList) { %>
                    <div class="post-item">
                        <div class="post-info">
                            <span class="post-category">[<%=dto.getGenre_type()%>]</span>
                            <a href="../board/review/detail.jsp?board_idx=<%=dto.getBoard_idx()%>" target="_blank" class="post-title"><%=dto.getTitle()%></a>
                            <span class="author-badge"><%=dto.getId()%></span>
                            <div class="post-meta">
                                <span>조회 <%=dto.getReadcount()%></span> • 
                                <span>작성일 <%=sdf.format(dto.getCreate_day())%></span>
                            </div>
                        </div>
                        <div class="post-actions">
                            <button onclick="deleteAdminPost('review', <%=dto.getBoard_idx()%>)" class="btn-action btn-delete">강제 삭제</button>
                        </div>
                    </div>
                <% } } %>
            </div>
        </div>
    </div>
</div>

<script>
    // 검색 함수
    function searchAdminPosts() {
        let keyword = $('#adminPostSearch').val();
        let $contentArea = $('#content-area');
        
        $contentArea.fadeOut(150, function() {
            $(this).load('adminCommunityList.jsp?search=' + encodeURIComponent(keyword), function() {
                $(this).fadeIn(150);
            });
        });
    }

    // 삭제 함수
    function deleteAdminPost(type, idx) {
        openCustomConfirm('관리자 권한으로 이 게시글을 강제 삭제하시겠습니까?', function(confirmed){
            if(!confirmed) return;
        
            $.ajax({
                url: 'adminCommunityDeleteAction.jsp',
                type: 'post',
                data: { type: type, idx: idx },
                dataType: 'json',
                success: function(res) {
                    if(res.status === 'SUCCESS') {
                        alert('게시글이 삭제되었습니다.');
                        searchAdminPosts();
                    } else {
                        alert('삭제 실패: ' + res.message);
                    }
                },
                error: function() {
                    alert('서버 통신 중 오류가 발생했습니다.');
                }
            });
        });
    }
</script>

