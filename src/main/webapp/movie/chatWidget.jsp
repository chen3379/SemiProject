<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
    /* [Design Token] Netflix-inspired Color Palette */
    :root {
        --netflix-black: #141414;
        --netflix-dark-gray: #181818;
        --netflix-light-gray: #2F2F2F;
        --netflix-red: #E50914;
        --netflix-red-hover: #C11119;
        --text-white: #FFFFFF;
        --text-sub: #B3B3B3;
        --shadow-elevation: 0 10px 30px rgba(0, 0, 0, 0.7);
    }

    /* 1. 둥둥 떠있는 버튼 (Floating Action Button) */
    #chat-fab {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 64px;
        height: 64px;
        background-color: var(--netflix-black); /* 배경은 검정 */
        border: 2px solid var(--netflix-red); /* 테두리로 레드 포인트 */
        border-radius: 50%;
        box-shadow: 0 4px 20px rgba(229, 9, 20, 0.4); /* 붉은 그림자 효과 */
        display: flex;
        justify-content: center;
        align-items: center;
        cursor: pointer;
        z-index: 9999;
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
    }

    #chat-fab:hover {
        transform: scale(1.1) rotate(10deg);
        background-color: var(--netflix-red);
        border-color: var(--netflix-red);
    }

    #chat-fab i {
        color: var(--netflix-red);
        font-size: 28px;
        transition: color 0.3s;
    }
    
    #chat-fab:hover i {
        color: white;
    }

    /* 2. 채팅창 본체 */
    #chat-box {
        position: fixed;
        bottom: 110px;
        right: 30px;
        width: 380px; /* 조금 더 넓게 */
        height: 600px; /* 조금 더 길게 */
        background-color: var(--netflix-black);
        border-radius: 12px;
        box-shadow: var(--shadow-elevation);
        display: flex;
        flex-direction: column;
        z-index: 9999;
        overflow: hidden;
        border: 1px solid #333;
        /* 애니메이션 효과 */
        animation: slideUp 0.3s ease-out;
    }
    
    @keyframes slideUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }

    /* 헤더 */
    .chat-header {
        background-color: #000000;
        flex-shrink: 0;
        padding: 16px 20px;
        border-bottom: 1px solid #333;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .chat-header span {
        font-family: 'Bebas Neue', sans-serif; /* 넷플릭스 느낌의 폰트가 없다면 기본값 사용 */
        color: var(--netflix-red);
        font-size: 1.2rem;
        font-weight: 900;
        letter-spacing: 1px;
        text-shadow: 0 0 10px rgba(229, 9, 20, 0.5);
    }

    .btn-close-custom {
        background: none;
        border: none;
        color: var(--text-sub);
        font-size: 1.2rem;
        cursor: pointer;
        transition: color 0.2s;
    }
    
    .btn-close-custom:hover {
        color: white;
    }

    /* 메시지 영역 */
    .chat-body {
        flex: 1;
        padding: 20px;
        overflow-y: auto;
        background-color: var(--netflix-black);
        font-size: 0.95rem;
        
        /* 스크롤바 커스텀 */
        scrollbar-width: thin;
        scrollbar-color: #444 #141414;
    }
    
    /* Webkit 스크롤바 (Chrome, Safari) */
    .chat-body::-webkit-scrollbar {
        width: 8px;
    }
    .chat-body::-webkit-scrollbar-track {
        background: var(--netflix-black);
    }
    .chat-body::-webkit-scrollbar-thumb {
        background-color: #444;
        border-radius: 4px;
    }

    /* 말풍선 공통 */
    .chat-message {
        margin-bottom: 18px;
        display: flex;
        flex-direction: column;
    }

    .message-content {
        max-width: 95%;
        padding: 12px 16px;
        border-radius: 8px;
        position: relative;
        line-height: 1.5;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }

    /* AI 메시지 (왼쪽) */
    .ai-message {
        align-items: flex-start;
    }

    .ai-message .message-content {
        background-color: var(--netflix-light-gray);
        color: var(--text-white);
        border-bottom-left-radius: 0; /* 각진 느낌 */
        border: 1px solid #444;
    }

    /* 사용자 메시지 (오른쪽) */
    .user-message {
        align-items: flex-end;
    }

    .user-message .message-content {
        background-color: var(--netflix-red);
        color: white;
        border-bottom-right-radius: 0;
        font-weight: 500;
    }

    /* 로딩 애니메이션 텍스트 */
    .loading-text {
        color: var(--text-sub);
        font-style: italic;
        font-size: 0.85rem;
    }

    /* 입력 영역 */
    .chat-footer {
        flex-shrink: 0;
        padding: 15px;
        background-color: #000;
        border-top: 1px solid #333;
        display: flex;
        gap: 10px;
    }

    /* 입력창 커스텀 */
    #chat-input {
        background-color: #333;
        border: 1px solid transparent;
        color: white;
        border-radius: 4px;
        padding: 10px 15px;
    }
    
    #chat-input::placeholder {
        color: #888;
    }
    
    #chat-input:focus {
        background-color: #444;
        border-color: #666;
        color: white;
        box-shadow: none;
        outline: none;
    }

    /* 전송 버튼 */
    .btn-send {
        background-color: transparent;
        color: var(--netflix-red);
        border: 1px solid var(--netflix-red);
        border-radius: 4px;
        padding: 0 20px;
        font-weight: bold;
        transition: all 0.2s;
        white-space: nowrap;
        flex-shrink: 0;
    }
    
    .btn-send:hover {
        background-color: var(--netflix-red);
        color: white;
    }
    
    /* (추가) 영화 카드가 채팅창에 뜰 경우를 대비한 스타일 */
    .chat-movie-card {
        background-color: #1f1f1f;
        border-radius: 6px;
        overflow: hidden;
        margin-top: 10px;
    }
    .chat-movie-card img {
        width: 100%;
        height: auto;
    }
    .chat-movie-info {
        padding: 10px;
        color: white;
    }
</style>

<div id="chat-fab" onclick="toggleChat()">
    <i class="bi bi-chat-fill"></i>
</div>

<div id="chat-box" style="display: none;">
    <div class="chat-header">
        <span>WHATFLIX AI</span>
        <button type="button" class="btn-close-custom" onclick="toggleChat()">
            <i class="bi bi-x-lg"></i>
        </button>
    </div>

    <div class="chat-body" id="chat-body">
        <div class="chat-message ai-message">
            <div class="message-content">
                <strong style="color: var(--netflix-red);">WhatFlix Bot</strong><br>
                안녕하세요! <br>오늘 어떤 분위기의 영화를 찾으시나요?
            </div>
        </div>
    </div>

    <div class="chat-footer">
        <input type="text" id="chat-input" class="form-control"
            placeholder="메시지를 입력하세요..." onkeypress="handleEnter(event)" autocomplete="off">
        <button type="button" class="btn btn-send" onclick="sendMessage()">
            전송
        </button>
    </div>
</div>

<script>
    // 채팅창 켜고 끄기
    function toggleChat() {
        $("#chat-box").fadeToggle("fast", function() {
            if ($("#chat-box").is(":visible")) {
                scrollToBottom();
                $("#chat-input").focus();
            }
        });
    }

    // 엔터키 처리
    function handleEnter(e) {
        if (e.keyCode === 13) {
            e.preventDefault();
            sendMessage();
        }
    }
    
    var isSending = false;

    // 메시지 전송
    function sendMessage() {
        if(isSending) return;
        var msg = $("#chat-input").val().trim();
        if (msg === "") return;
        
        isSending = true;

        // 1. 내 메시지 추가
        var userHtml = '<div class="chat-message user-message">'
                + '<div class="message-content">' + msg + '</div></div>';
        $("#chat-body").append(userHtml);
        $("#chat-input").val("");
        scrollToBottom();

        // 2. 로딩 표시 (Netflix Style)
        var loadingHtml = '<div class="chat-message ai-message" id="loading-msg">'
                + '<div class="message-content loading-text">'
                + '<span class="spinner-border spinner-border-sm text-danger" role="status" aria-hidden="true"></span>'
                + ' AI가 영화를 찾는 중...</div></div>';
        $("#chat-body").append(loadingHtml);
        scrollToBottom();

        // 3. 서버 전송
        $.ajax({
            type : "post",
            url : "movieChatAction.jsp",
            data : { msg : msg },
            success : function(response) {
                $("#loading-msg").remove();
                $("#chat-body").append(response);
                scrollToBottom();
                isSending = false;
                $("#chat-input").focus();
            },
            error : function() {
                $("#loading-msg").remove();
                $("#chat-body").append(
                        '<div class="chat-message ai-message"><div class="message-content">서버 연결에 실패했습니다.</div></div>');
                isSending = false;
            }
        });
    }

    function scrollToBottom() {
        var chatBody = document.getElementById("chat-body");
        chatBody.scrollTop = chatBody.scrollHeight;
    }
</script>