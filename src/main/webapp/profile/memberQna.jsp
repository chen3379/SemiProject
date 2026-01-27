<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="support.SupportDto" %>
<%@ page import="support.SupportAdminDto" %>
<%@ page import="support.SupportAdminDao" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%-- 1. 데이터 로드 액션 포함 --%>
<jsp:include page="memberQnaAction.jsp" />

<%
    List<SupportDto> qnaList = (List<SupportDto>) request.getAttribute("userQnaList");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SupportAdminDao adminDao = new SupportAdminDao();
%>

<style>
    .qna-management-section {
        animation: fadeInUp 0.5s ease-out;
    }

    .qna-header {
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    }

    .qna-title { font-size: 1.4rem; font-weight: 700; color: #fff; margin: 0; }

    .qna-list { 
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .qna-item {
        background: #181818;
        border: 1px solid rgba(255, 255, 255, 0.05);
        border-radius: 8px;
        padding: 20px;
        transition: 0.2s;
    }

    .qna-item:hover {
        border-color: rgba(255, 255, 255, 0.2);
    }

    .qna-main {
        display: flex;
        justify-content: space-between;
        align-items: center;
        cursor: pointer;
    }

    .qna-info { flex: 1; }
    
    .qna-badge-row {
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
    .status-pending { background: rgba(255, 193, 7, 0.1); color: #ffc107; border: 1px solid rgba(255, 193, 7, 0.2); }
    .status-complete { background: rgba(40, 167, 69, 0.1); color: #28a745; border: 1px solid rgba(40, 167, 69, 0.2); }
    .secret-badge { background: rgba(229, 9, 20, 0.1); color: #E50914; border: 1px solid rgba(229, 9, 20, 0.2); }

    .qna-item-title { 
        font-size: 1.1rem; 
        color: #fff; 
        font-weight: 600; 
        margin: 0;
    }

    .qna-meta { 
        font-size: 0.85rem; 
        color: #666; 
        margin-top: 8px; 
    }

    .qna-content-box {
        margin-top: 20px;
        padding: 15px;
        background: rgba(255, 255, 255, 0.03);
        border-radius: 6px;
        display: none;
    }

    .question-box { margin-bottom: 15px; }
    .answer-box { 
        padding-top: 15px;
        border-top: 1px solid rgba(255, 255, 255, 0.05);
        color: #ddd;
    }
    
    .answer-header {
        display: flex;
        align-items: center;
        gap: 8px;
        color: #28a745;
        font-weight: 700;
        margin-bottom: 10px;
        font-size: 0.9rem;
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

    .qna-item.open .toggle-icon {
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

<div class="qna-management-section">
    <div class="qna-header">
        <h2 class="qna-title">내 QnA 관리</h2>
    </div>

    <div class="qna-list">
        <% if(qnaList == null || qnaList.isEmpty()) { %>
            <div class="empty-state">작성한 문의 내역이 없습니다.</div>
        <% } else { 
            for(SupportDto dto : qnaList) { 
                SupportAdminDto answer = adminDao.getAdminAnswer(dto.getSupportIdx());
        %>
            <div class="qna-item" id="qna-<%=dto.getSupportIdx()%>">
                <div class="qna-main" onclick="toggleQna(<%=dto.getSupportIdx()%>)">
                    <div class="qna-info">
                        <div class="qna-badge-row">
                            <span class="badge-qna category-badge">
                                <%= "0".equals(dto.getCategoryType()) ? "회원정보" :
                                    "1".equals(dto.getCategoryType()) ? "신고" : "기타" %>
                            </span>
                            <% if("1".equals(dto.getStatusType())) { %>
                                <span class="badge-qna status-complete">답변완료</span>
                            <% } else { %>
                                <span class="badge-qna status-pending">답변대기</span>
                            <% } %>
                            <% if("1".equals(dto.getSecretType())) { %>
                                <span class="badge-qna secret-badge"><i class="bi bi-lock-fill me-1"></i>비밀글</span>
                            <% } %>
                        </div>
                        <h4 class="qna-item-title"><%=dto.getTitle()%></h4>
                        <div class="qna-meta">
                            <span>작성일 <%=sdf.format(dto.getCreateDay())%></span> • 
                            <span>조회 <%=dto.getReadcount()%></span>
                        </div>
                    </div>
                    <div class="toggle-icon">
                        <i class="bi bi-chevron-down fs-4"></i>
                    </div>
                </div>
                
                <div class="qna-content-box" id="content-<%=dto.getSupportIdx()%>">
                    <div class="question-box">
                        <pre><%=dto.getContent()%></pre>
                    </div>
                    
                    <% if(answer != null) { %>
                        <div class="answer-box">
                            <div class="answer-header">
                                <i class="bi bi-arrow-return-right"></i>
                                <span>관리자 답변</span>
                                <span style="font-size: 0.8rem; font-weight: 400; color: #666; margin-left: auto;">
                                    <%=sdf.format(answer.getCreateDay())%>
                                </span>
                            </div>
                            <pre><%=answer.getContent()%></pre>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } } %>
    </div>
</div>

<script>
    function toggleQna(idx) {
        let $item = $('#qna-' + idx);
        let $content = $('#content-' + idx);
        
        if($item.hasClass('open')) {
            $content.slideUp(200);
            $item.removeClass('open');
        } else {
            // 다른 것 닫기 (선택사항)
            // $('.qna-item.open .qna-content-box').slideUp(200);
            // $('.qna-item.open').removeClass('open');
            
            $content.slideDown(200);
            $item.addClass('open');
            
            // 조회수 증가 (필요시 AJAX)
        }
    }
</script>
