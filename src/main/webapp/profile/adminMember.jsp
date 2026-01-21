<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="member.MemberDto" %>

<%-- 1. 데이터 로드 액션 포함 (검색/정렬 로직 처리) --%>
<jsp:include page="adminMemberAction.jsp" />

<%
    List<MemberDto> memberList = (List<MemberDto>) request.getAttribute("memberList");
    Integer totalMemberCount = (Integer) request.getAttribute("totalCount");
    String sortOrder = (String) request.getAttribute("sortOrder");
    String searchKeyword = request.getParameter("search"); // 검색어 유지용

    if (totalMemberCount == null) totalMemberCount = 0;
    if (sortOrder == null) sortOrder = "latest";
    if (searchKeyword == null) searchKeyword = "";
%>
<style>
    /* [WHATFLIX Admin - 통합 디자인 시스템] */
    .admin-section {
        animation: fadeInUp 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        padding-bottom: 15px;
    }

    .section-title { font-size: 1.4rem; font-weight: 700; color: #fff; margin: 0; }
    .section-count { color: #E50914; margin-left: 8px; }

    /* 컨트롤 바 (검색 및 버튼) */
    .admin-controls { display: flex; gap: 10px; align-items: center; }

    /* 입력창 스타일 통일 */
    .search-bar {
        background-color: rgba(255, 255, 255, 0.05) !important;
        border: 1px solid rgba(255, 255, 255, 0.1) !important;
        border-radius: 6px !important;
        padding: 8px 15px !important;
        color: #FFFFFF !important;
        font-size: 0.9rem !important;
        outline: none;
        width: 250px;
        transition: 0.2s;
    }

    .search-bar:focus {
        border-color: #E50914 !important;
        background-color: rgba(255, 255, 255, 0.08) !important;
    }

    /* 버튼 스타일 통일 */
    .sort-btn {
        background: rgba(255, 255, 255, 0.1);
        border: 1px solid rgba(255, 255, 255, 0.1);
        color: #fff;
        padding: 8px 16px;
        border-radius: 6px;
        font-size: 0.85rem;
        cursor: pointer;
        transition: 0.2s;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .sort-btn:hover { background: rgba(255, 255, 255, 0.2); }
    .sort-btn.active {
        background-color: #E50914 !important;
        border-color: #E50914;
        font-weight: 700;
    }

    /* 리스트 스타일 */
    .member-list-container { display: flex; flex-direction: column; gap: 12px; }

    .member-row {
        display: flex;
        align-items: center;
        background: #181818;
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 8px;
        padding: 12px 20px;
        transition: 0.2s;
        cursor: pointer;
    }

    .member-row:hover {
        background: rgba(255, 255, 255, 0.05);
        border-color: #E50914;
        transform: translateX(5px);
    }

    .member-thumb {
        width: 45px;
        height: 45px;
        border-radius: 50%;
        object-fit: cover;
        margin-right: 20px;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .member-main-info { flex: 2; display: flex; flex-direction: column; }
    .member-name-wrap { display: flex; align-items: center; gap: 8px; }
    .member-name { font-weight: 600; color: #fff; font-size: 1rem; }
    
    .role-badge {
        font-size: 0.65rem;
        padding: 1px 6px;
        border-radius: 4px;
        background: #E50914;
        color: #fff;
    }

    .member-sub-info { font-size: 0.85rem; color: #B3B3B3; margin-top: 2px; }

    .member-status-info {
        flex: 1;
        text-align: right;
        font-size: 0.85rem;
        color: #666;
        padding-right: 30px;
    }

    .edit-link-btn {
        background: rgba(255, 255, 255, 0.1);
        color: #fff;
        padding: 6px 14px;
        border-radius: 4px;
        font-size: 0.8rem;
        text-decoration: none;
    }
</style>
<div class="admin-section">
    <div class="section-header">
        <div class="section-title-wrap">
            <h2 class="section-title">회원 관리 <span class="section-count">(<%=totalMemberCount%>)</span></h2>
        </div>
        
        <div class="admin-controls">
            <div class="search-wrapper" style="position: relative;">
                <input type="text" id="memberSearch" class="search-bar" 
                       placeholder="닉네임 또는 아이디 검색" value="<%=searchKeyword%>"
                       onkeyup="if(window.event.keyCode==13){searchMember()}">
                <i class="bi bi-search" onclick="searchMember()" 
                   style="position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #777;"></i>
            </div>
            
            <button type="button" class="sort-btn <%= "latest".equals(sortOrder) ? "active" : "" %>" 
                    onclick="sortMembers('latest')">최신순</button>
            <button type="button" class="sort-btn <%= "name".equals(sortOrder) ? "active" : "" %>" 
                    onclick="sortMembers('name')">이름순</button>
        </div>
    </div>

    <div class="member-list-container">
    <%
        if (memberList != null && !memberList.isEmpty()) {
            String cp = pageContext.getServletContext().getContextPath();
            for (MemberDto m : memberList) {
                String photo = m.getPhoto();
    %>
                <!-- [수정됨] onclick 핸들러에 this를 넘기고, data-id 속성 추가 -->
                <div class="member-row" onclick="goToMemberEdit(this)" data-id="<%= m.getId() %>">
                    <img src="<%= (photo == null || photo.trim().isEmpty()) 
                                ? cp + "/profile_photo/default_photo.jpg" 
                                : cp + photo %>" 
                         class="member-thumb" 
                         onerror="this.src='<%=cp%>/profile_photo/default_photo.jpg'">

                    <div class="member-main-info">
                        <div class="member-name-wrap">
                            <span class="member-name"><%= m.getNickname() %></span> 
                            <% if("9".equals(m.getRoleType())) { %><span class="role-badge">ADMIN</span><% } %>
                        </div>
                        <div class="member-sub-info">
                            <%= m.getId() %> | <%= m.getHp() != null ? m.getHp() : "연락처 없음" %>
                        </div>
                    </div>

                    <div class="member-status-info">
                        <span style="color: #555;">가입일:</span> <%= m.getCreateDay().toString().substring(0, 10) %>
                    </div>

                    <div class="member-actions">
                        <span class="edit-link-btn">관리</span>
                    </div>
                </div>
    <% 
            }
        } else {
    %>
        <div class="text-center py-5 text-muted">조회된 회원이 없습니다.</div>
    <% } %>
    </div>
</div>

<script>
    // 검색 및 정렬 함수 (AJAX로 adminMember.jsp를 다시 로드)
    function searchMember() {
        let keyword = $('#memberSearch').val();
        $.ajax({
            type: "get",
            url: "adminMember.jsp",
            data: { search: keyword },
            success: function(res) { 
                $('#content-area').html(res); 
            }
        });
    }

    function sortMembers(sortType) {
        let keyword = $('#memberSearch').val();
        $.ajax({
            type: "get",
            url: "adminMember.jsp",
            data: { 
                sort: sortType,
                search: keyword
            },
            success: function(res) { 
                $('#content-area').html(res); 
            }
        });
    }

    // [수정됨] 상세 페이지 이동 함수: 클릭된 요소의 data-id를 읽어 파라미터로 전송
    function goToMemberEdit(element) {
        // 클릭된 HTML 요소에서 data-id 속성값을 가져옵니다.
        const memberId = $(element).data('id'); 

        if(!memberId) {
            alert("회원 ID를 찾을 수 없습니다.");
            return;
        }
        
        const targetUrl = "adminMemberEdit.jsp?id=" + encodeURIComponent(memberId);
        
        $('#content-area').fadeOut(150, function() {
            // URL 파라미터를 포함하여 비동기 로드 요청
            $(this).load(targetUrl, function() {
                $(this).fadeIn(150);
            });
        });
    }
</script>