<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
/* 1. 둥둥 떠있는 버튼 (Floating Action Button) */
#chat-fab {
	position: fixed;
	bottom: 30px;
	right: 30px;
	width: 60px;
	height: 60px;
	background-color: #ff2f6e; /* 왓챠 핑크 */
	border-radius: 50%;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
	display: flex;
	justify-content: center;
	align-items: center;
	cursor: pointer;
	z-index: 9999;
	transition: transform 0.2s;
}

#chat-fab:hover {
	transform: scale(1.1);
}

#chat-fab i {
	color: white;
	font-size: 28px;
}

/* 2. 채팅창 본체 (숨김 상태가 기본) */
#chat-box {
	position: fixed;
	bottom: 100px;
	right: 30px;
	width: 350px;
	height: 500px;
	background-color: white;
	border-radius: 15px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
	display: flex;
	flex-direction: column;
	z-index: 9999;
	overflow: hidden;
	border: 1px solid #eee;
}

/* 헤더 */
.chat-header {
	background-color: #ff2f6e;
	flex-shrink: 0;
	color: white;
	padding: 15px;
	font-weight: bold;
	display: flex;
	justify-content: space-between;
	align-items: center;
	color: white;
}

/* 메시지 영역 */
.chat-body {
	flex: 1;
	padding: 15px;
	overflow-y: auto;
	background-color: #f9f9f9;
	font-size: 14px;
	scrollbar-width: thin;
	scrollbar-color: #ccc #f9f9f9;
}

/* 입력 영역 */
.chat-footer {
	flex-shrink: 0;
	padding: 10px;
	border-top: 1px solid #eee;
	display: flex;
	gap: 5px;
	background-color: white;
	padding: 10px;
}

/* 말풍선 스타일 */
.chat-message {
	margin-bottom: 15px;
	display: flex;
	flex-direction: column;
}

.ai-message {
	align-items: flex-start;
}

.user-message {
	align-items: flex-end;
}

.message-content {
	max-width: 80%;
	padding: 10px 14px;
	border-radius: 15px;
	position: relative;
}

.ai-message .message-content {
	background-color: #eee;
	color: #333;
	border-bottom-left-radius: 2px;
}

.user-message .message-content {
	background-color: #ff2f6e;
	color: white;
	border-bottom-right-radius: 2px;
}
</style>

<div id="chat-fab" onclick="toggleChat()">
	<i class="bi bi-chat-dots-fill"></i>
</div>

<div id="chat-box" style="display: none;">
	<div class="chat-header">
		<span>WhatFlix AI bot</span>
		<button type="button" class="btn-close btn-close-white"
			onclick="toggleChat()"></button>
	</div>

	<div class="chat-body" id="chat-body">
		<div class="chat-message ai-message">
			<div class="message-content">
				<strong>WhatFlix AI bot:</strong><br>
				안녕하세요!<br> 기분이나 상황을 말해주시면 어울리는 영화를 추천해드릴게요.
			</div>
		</div>
	</div>

	<div class="chat-footer">
		<input type="text" id="chat-input" class="form-control"
			placeholder="예: 우울할 때 볼만한 영화..." onkeypress="handleEnter(event)">
		<button type="button" style="min-width: 80px; white-space: nowrap;"
			class="btn btn-primary" onclick="sendMessage()">전송</button>
	</div>
</div>

<script>

	// 채팅창 켜고 끄기
	function toggleChat() {
		$("#chat-box").fadeToggle("fast", function() {
			// 켜질 때 스크롤 맨 아래로, 입력창 포커스
			if ($("#chat-box").is(":visible")) {
				scrollToBottom();
				$("#chat-input").focus();
			}
		});
	}

	// 엔터키 처리 전용 함수
    function handleEnter(e) {
        if (e.keyCode === 13) {
            e.preventDefault(); // 엔터키의 기본 동작(줄바꿈/제출) 막기
            sendMessage();      // 전송 함수 호출
        }
    }
    // '락(Lock)' 확인
    var isSending = false;
	// 메시지 전송
	function sendMessage() {
		if(isSending) return;
		var msg = $("#chat-input").val().trim();
		if (msg === "")
			return;
		
		isSending = true; //락 걸기

		// 1. 내 메시지 화면에 추가
		var userHtml = '<div class="chat-message user-message">'
				+ '<div class="message-content">' + msg + '</div></div>';
		$("#chat-body").append(userHtml);
		$("#chat-input").val(""); // 입력창 비우기
		scrollToBottom();

		// 2. 로딩 표시 (점점점...)
		var loadingHtml = '<div class="chat-message ai-message" id="loading-msg">'
				+ '<div class="message-content">Thinking... 🤔</div></div>';
		$("#chat-body").append(loadingHtml);
		scrollToBottom();

		// 3. 서버(AJAX)로 전송
		$
				.ajax({
					type : "post",
					url : "movieChatAction.jsp", // 백엔드 파일 경로 (prompt 처리)
					data : {
						msg : msg
					},
					success : function(response) {
						$("#loading-msg").remove(); // 로딩 제거
						$("#chat-body").append(response); // AI 답변(영화카드 포함) 추가
						scrollToBottom();
						
						// 전송 끝날 시 락 해제
						isSending = false;
						$("#chat-input").focus();
					},
					error : function() {
						$("#loading-msg").remove();
						$("#chat-body")
								.append(
										'<div class="chat-message ai-message"><div class="message-content">서버 오류가 발생했습니다</div></div>');
						isSending = false;
					}
				});
	}

	// 스크롤 맨 아래로 내리기
	function scrollToBottom() {
		var chatBody = document.getElementById("chat-body");
		chatBody.scrollTop = chatBody.scrollHeight;
	}
	



</script>