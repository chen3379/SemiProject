<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="support.SupportDto" %>
<%@ page import="support.SupportAdminDto" %>
<%@ page import="support.SupportAdminDao" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%-- 1. 데이터 로드 액션 포함 --%>
<jsp:include page="adminQnaListAction.jsp" />

<%
    List<SupportDto> qnaList = (List<SupportDto>) request.getAttribute("adminQnaList");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SupportAdminDao adminDao = new SupportAdminDao();
%>

<style>
    .admin-qna-section {
        animation: fadeInUp 0.5s ease-out;
    }

    .admin-qna-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .admin-qna-title { font-size: 1.4rem; font-weight: 700; color: #fff; margin: 0; }

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

    .admin-qna-list { 
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .admin-qna-item {
        background: #181818;
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        padding: 20px;
        transition: 0.2s;
    }

    .admin-qna-item:hover {
        border-color: rgba(255, 255, 255, 0.2);
    }

    .admin-qna-main {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .admin-qna-clickable {
        flex: 1;
        cursor: pointer;
    }

    .admin-qna-info { flex: 1; }
    
    .admin-qna-badge-row {
        display: flex;
        gap: 8px;
        margin-bottom: 8px;
    }

    .badge-qna {
        font-size: 0.7rem;
        padding: 2px 8px;
        border-radius: 4px;
        font-weight: 700;
        text-transform: uppercase;
    }

    .category-badge { background: rgba(255, 255, 255, 0.1); color: #bbb; }
    .status-pending { background: rgba(229, 9, 20, 0.1); color: #E50914; border: 1px solid rgba(229, 9, 20, 0.2); }
    .status-complete { background: rgba(40, 167, 69, 0.1); color: #28a745; border: 1px solid rgba(40, 167, 69, 0.2); }
    .author-badge { background: rgba(0, 123, 255, 0.1); color: #007bff; border: 1px solid rgba(0, 123, 255, 0.2); }

    .admin-qna-item-title { 
        font-size: 1.1rem; 
        color: #fff; 
        font-weight: 600; 
        margin: 0;
    }

    .admin-qna-meta { 
        font-size: 0.85rem; 
        color: #666; 
        margin-top: 8px; 
    }

    .admin-qna-content-box {
        margin-top: 20px;
        padding: 20px;
        background: rgba(255, 255, 255, 0.03);
        border-radius: 6px;
        display: none;
    }

    .admin-question-box { margin-bottom: 20px; padding-bottom: 20px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); }
    
    .admin-answer-box { 
        color: #ddd;
    }

    .answer-textarea {
        width: 100%;
        background: #111;
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 4px;
        color: #fff;
        padding: 12px;
        font-size: 0.95rem;
        resize: vertical;
        margin-bottom: 12px;
        outline: none;
    }

    .answer-textarea:focus {
        border-color: #E50914;
    }

    .btn-save-answer {
        background: #E50914;
        color: #fff;
        border: none;
        padding: 8px 16px;
        border-radius: 4px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
    }

    .btn-save-answer:hover {
        background: #b20710;
    }

    .empty-state {
        text-align: center;
        padding: 50px 0;
        color: #666;
    }

    .toggle-icon {
        color: #666;
        transition: 0.3s;
    }

    .admin-qna-item.open .toggle-icon {
        transform: rotate(180deg);
        color: #E50914;
    }
    
    pre {
        white-space: pre-wrap;
        font-family: inherit;
        font-size: 0.95rem;
        margin-bottom: 0;
    }
</style>

<div class="admin-qna-section">
    <div class="admin-qna-header">
        <h2 class="admin-qna-title">QnA 관리 (관리자)</h2>
        
        <div class="search-container">
            <i class="bi bi-search search-icon"></i>
            <input type="text" id="adminQnaSearch" class="search-input" 
                   placeholder="글 제목 또는 내용 검색" value="<%=searchKeyword%>"
                   onkeyup="if(window.event.keyCode==13){searchAdminQna()}">
        </div>
    </div>

    <div class="admin-qna-list">
        <% if(qnaList == null || qnaList.isEmpty()) { %>
            <div class="empty-state">문의 내역이 없습니다.</div>
        <% } else { 
            for(SupportDto dto : qnaList) { 
                SupportAdminDto answer = adminDao.getAdminAnswer(dto.getSupportIdx());
        %>
            <div class="admin-qna-item" id="admin-qna-<%=dto.getSupportIdx()%>">
                <div class="admin-qna-main">
                    <div class="admin-qna-clickable" data-idx="<%=dto.getSupportIdx()%>" onclick="toggleAdminQna(this)">
                        <div class="admin-qna-info">
                            <div class="admin-qna-badge-row">
                                <span class="badge-qna category-badge">
                                    <%= "0".equals(dto.getCategoryType()) ? "회원정보" :
                                        "1".equals(dto.getCategoryType()) ? "신고" : "기타" %>
                                </span>
                                <span class="badge-qna author-badge"><%=dto.getId()%></span>
                                <% if("1".equals(dto.getStatusType())) { %>
                                    <span class="badge-qna status-complete">답변완료</span>
                                <% } else { %>
                                    <span class="badge-qna status-pending">답변대기</span>
                                <% } %>
                                <% if("1".equals(dto.getSecretType())) { %>
                                    <i class="bi bi-lock-fill text-danger ms-1"></i>
                                <% } %>
                            </div>
                            <h4 class="admin-qna-item-title"><%=dto.getTitle()%></h4>
                            <div class="admin-qna-meta">
                                <span>작성일 <%=sdf.format(dto.getCreateDay())%></span> • 
                                <span>조회 <%=dto.getReadcount()%></span>
                            </div>
                        </div>
                    </div>
                    <div class="admin-qna-actions d-flex align-items-center gap-3">
                        <a href="../support/supportDetail.jsp?supportIdx=<%=dto.getSupportIdx()%>" 
                           class="btn-detail-link" title="상세보기" 
                           style="color: var(--primary-red); font-size: 1.2rem;">
                            <i class="bi bi-box-arrow-up-right"></i>
                        </a>
                        <div class="toggle-icon" data-idx="<%=dto.getSupportIdx()%>" onclick="toggleAdminQna(this)">
                            <i class="bi bi-chevron-down fs-4" style="cursor: pointer;"></i>
                        </div>
                    </div>
                </div>
                
                <div class="admin-qna-content-box" id="admin-content-<%=dto.getSupportIdx()%>">
                    <div class="admin-question-box">
                        <div class="text-muted small mb-2">질문 내용</div>
                        <pre><%=dto.getContent()%></pre>
                    </div>
                    
                    <div class="admin-answer-box">
                        <div class="text-muted small mb-2">관리자 답변</div>
                        <textarea id="answer-text-<%=dto.getSupportIdx()%>" class="answer-textarea" rows="4" placeholder="답변을 입력하세요"><%=answer != null ? answer.getContent() : ""%></textarea>
                        <div class="text-end">
                            <button class="btn-save-answer" onclick="saveAdminAnswer(<%=dto.getSupportIdx()%>)">
                                <%=answer != null ? "답변 수정" : "답변 등록"%>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        <% } } %>
    </div>
</div>

<script>
    function toggleAdminQna(element) {
        let idx = $(element).data('idx');
        let $item = $('#admin-qna-' + idx);
        let $content = $('#admin-content-' + idx);
        
        if($item.hasClass('open')) {
            $content.slideUp(200);
            $item.removeClass('open');
        } else {
            $content.slideDown(200);
            $item.addClass('open');
        }
    }

    function searchAdminQna() {
        let keyword = $('#adminQnaSearch').val();
        let $contentArea = $('#content-area');
        
        $contentArea.fadeOut(150, function() {
            $(this).load('adminQnaList.jsp?search=' + encodeURIComponent(keyword), function() {
                $(this).fadeIn(150);
            });
        });
    }

    function saveAdminAnswer(idx) {
        let content = $('#answer-text-' + idx).val();
        if(!content.trim()) {
            alert('답변 내용을 입력해 주세요.');
            return;
        }

        $.ajax({
            url: 'adminQnaAnswerAction.jsp',
            type: 'post',
            data: { supportIdx: idx, content: content },
            dataType: 'json',
            success: function(res) {
                if(res.status === 'SUCCESS') {
                    alert('답변이 저장되었습니다.');
                    searchAdminQna(); // 새로고침
                } else {
                    alert('저장 실패: ' + res.message);
                }
            },
            error: function() {
                alert('저장 중 오류가 발생했습니다.');
            }
        });
    }
</script>
