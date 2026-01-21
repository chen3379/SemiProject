<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="member.MemberDto" %>

<%-- 1. 데이터 로드 액션 포함 (검색/정렬 로직 처리) --%>
<jsp:include page="adminMemberAction.jsp" />

<%
    List<MemberDto> memberList = (List<MemberDto>) request.getAttribute("memberList");
    Integer totalMemberCount = (Integer) request.getAttribute("totalCount");
    String sortOrder = (String) request.getAttribute("sortOrder");

    if (totalMemberCount == null) totalMemberCount = 0;
    if (sortOrder == null) sortOrder = "latest";
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

<div class="member-list-container">
<%
    if (memberList != null && !memberList.isEmpty()) {
        String cp = pageContext.getServletContext().getContextPath();
        for (MemberDto m : memberList) {
            String photo = m.getPhoto();
%>
            <!-- 1. onclick 경로를 확실하게 지정하고 cursor style 추가 -->
            <div class="member-row" 
                 onclick="goToMemberEdit('<%= m.getId() %>')" 
                 style="min-height: 60px; padding: 8px 20px; cursor: pointer;">
                
                <!-- 썸네일 -->
                <img src="<%= (photo == null || photo.trim().isEmpty()) 
                            ? cp + "/profile_photo/default_photo.jpg" 
                            : cp + photo %>" 
                     class="member-thumb" 
                     style="width: 40px; height: 40px; margin-right: 15px; pointer-events: none;"
                     onerror="this.src='${pageContext.request.contextPath}/profile_photo/default_photo.jpg'">

                <div class="member-main-info" style="flex: 1.5; pointer-events: none;">
                    <div class="member-name-wrap">
                        <span class="member-name" style="font-size: 0.95rem;"><%= m.getNickname() %></span> 
                        <% if("9".equals(m.getRoleType())) { %><span class="role-badge">ADMIN</span><% } %>
                    </div>
                    <div class="member-sub-info" style="font-size: 0.8rem; color: #777;">
                        <%= m.getId() %> | <%= m.getHp() != null ? m.getHp() : "연락처 없음" %>
                    </div>
                </div>

                <div class="member-status-info" style="flex: 1; text-align: center; font-size: 0.8rem; pointer-events: none;">
                    <span style="color: #555;">가입일:</span> <%= m.getCreateDay().toString().substring(0, 10) %>
                </div>

                <div class="member-actions" style="margin-left: auto;">
                    <!-- 버튼 클릭 시에도 부모 이벤트가 실행되도록 stopPropagation 없이 유지 -->
                    <span class="edit-link-btn" style="padding: 4px 12px; font-size: 0.75rem;">관리</span>
                </div>
            </div>
<% 
        }
    } 
%>
</div>

<script>
    // [중요] 상세 정보 수정 이동 함수 재확인
    function goToMemberEdit(memberId) {
        if(!memberId) {
            alert("회원 ID가 없습니다.");
            return;
        }

        // adminMemberEdit.jsp 가 맞는지 파일명 재확인 필수
        const targetUrl = "adminMemberEdit.jsp?id=" + memberId;
        
        console.log("Navigating to: " + targetUrl); // 디버깅용

        // 1. 페이드아웃 효과와 함께 로드
        $('#content-area').fadeOut(150, function() {
            $(this).load(targetUrl, function(response, status, xhr) {
                if (status == "error") {
                    console.error("Load Error: " + xhr.status + " " + xhr.statusText);
                    alert("페이지를 불러오는데 실패했습니다.");
                    $(this).show(); // 에러 시 다시 보이기
                } else {
                    $(this).fadeIn(150);
                    // 2026년형: 주소창 파라미터 업데이트 (필요 시)
                    window.history.pushState(null, null, "?menu=adminMemberEdit&id=" + memberId);
                }
            });
        });
    }

    // 검색 및 정렬 함수 파일명 확인 (adminMember.jsp가 리스트를 그려주는 파일이 맞는지 확인)
    function searchMember() {
        let keyword = $('#memberSearch').val();
        $.ajax({
            type: "get",
            url: "adminMember.jsp", // 리스트를 다시 그려주는 JSP 파일명
            data: { search: keyword },
            success: function(res) { 
                $('#content-area').html(res); 
            }
        });
    }

    function sortMembers(sortType) {
        $.ajax({
            type: "get",
            url: "adminMember.jsp",
            data: { sort: sortType },
            success: function(res) { 
                $('#content-area').html(res); 
            }
        });
    }
</script>
