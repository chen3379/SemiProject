<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<style>
/* 디자인 토큰 정의 */
:root {
	--alert-bg: #181818;
	--alert-red: #E50914;
	--alert-red-hover: #ff1f2a;
/* 	--alert-text: #e5e5e5; */
	--alert-text: #fff;
	--alert-shadow-red: rgba(229, 9, 20, 0.5);
	--alert-ease: cubic-bezier(0.25, 0.8, 0.25, 1); /* 부드럽고 고급스러운 움직임 */
}

/* 1. 배경 오버레이 */
#custom-alert-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.85); /* 더 진한 배경 */
	backdrop-filter: blur(8px); /* 블러 강화 */
	z-index: 99999;
	align-items: flex-start;
	padding-top: 100px; justify-content : center;
	opacity: 0;
	transition: opacity 0.4s var(--alert-ease);
	justify-content: center;
}

/* 2. 알림창 본체 (패널) */
.custom-alert-box {
	background: linear-gradient(180deg, #1f1f1f 0%, var(--alert-bg) 100%);
	/* 미세한 그라데이션 배경 */
	width: 420px;
	max-width: 92%;
	border-radius: 16px; /* 더 둥글게 */
	/* 깊이감 있는 그림자와 상단 미세 조명 효과 */
	box-shadow: 0 -1px 0 rgba(255, 255, 255, 0.1) inset, /* 상단 하이라이트 */
            0 20px 60px rgba(0, 0, 0, 0.9); /* 깊은 그림자 */
	border: none; /* 촌스러운 테두리 제거 */
	/* 초기 상태: 약간 아래에 있고 작음 */
	transform: translateY(10px) scale(0.95);
	transition: transform 0.4s var(--alert-ease);
	overflow: hidden;
	text-align: center;
}

/* 3. 헤더 */
.alert-header {
	padding: 20px 0 15px;
}

.alert-header h2 {
	color: var(--alert-red);
	font-family: 'Bebas Neue', sans-serif;
	/* 넷플릭스 스타일 폰트 권장 (없으면 기본폰트 적용됨) */
	font-size: 1.6rem;
	font-weight: 900;
	margin: 0;
	letter-spacing: 2px;
	text-transform: uppercase;
	/* 네온 사인 효과 */
	text-shadow: 0 0 20px var(--alert-shadow-red);
}

/* 4. 메시지 내용 */
.alert-body {
	padding: 0 40px 35px;
	color: var(--alert-text);
	font-size: 0.9rem;
	line-height: 1.7;
	font-weight: 400;
	word-break: keep-all;
	opacity: 0.9;
}

/* 5. 버튼 영역 */
.alert-footer {
	padding: 0 10px 8px;
}

/* 프리미엄 버튼 스타일 */
.btn-alert-ok {
	width: 20%;
	padding: 7px 0;
	background: linear-gradient(180deg, var(--alert-red) 0%, #B20710 100%);
	/* 입체감 있는 그라데이션 */
	color: white;
	border: none;
	font-size: 1rem;
	font-weight: 700;
	border-radius: 8px;
	cursor: pointer;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
	transition: all 0.3s var(--alert-ease);
	letter-spacing: 0.5px;
}

.btn-alert-ok:focus {
	outline: none;
	box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.4);
}

.btn-alert-ok:hover {
	background: linear-gradient(180deg, var(--alert-red-hover) 0%,
		var(--alert-red) 100%);
	box-shadow: 0 8px 25px var(--alert-shadow-red); /* 호버 시 붉은 빛 발산 */
	transform: translateY(-2px);
}

.btn-alert-ok:active {
	transform: translateY(1px);
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
}

/* 활성화 상태 (애니메이션 트리거) */
#custom-alert-overlay.active {
	display: flex;
	opacity: 1;
}

#custom-alert-overlay.active .custom-alert-box {
	/* 최종 상태: 정위치, 원래 크기 */
	transform: translateY(0) scale(1);
}
</style>

<div id="custom-alert-overlay">
	<div class="custom-alert-box">
		<div class="alert-header">
			<h2>WhatFlix</h2>
		</div>
		<div class="alert-body" id="custom-alert-msg"></div>
		<div class="alert-footer">
			<button class="btn-alert-ok" onclick="closeCustomAlert()">확인</button>
		</div>
	</div>
</div><script>
    /**
     * [핵심 변경 사항]
     * alert 함수가 이제 두 번째 인자로 'callback 함수'를 받습니다.
     * 사용법: alert("메시지", function() { 이동할 코드 });
     */
    
    // 콜백 함수를 저장할 변수
    let alertCallback = null;

    // window.alert 오버라이딩 (기존 호환성 유지 + 콜백 기능 추가)
    window.alert = function(message, callback) {
        openCustomAlert(message, callback);
    };

    function openCustomAlert(msg, callback) {
        // 콜백 함수가 있으면 저장해둠
        if (callback && typeof callback === 'function') {
            alertCallback = callback;
        } else {
            alertCallback = null;
        }

        if(msg) {
            msg = msg.replace(/\n/g, "<br>");
        }
        document.getElementById("custom-alert-msg").innerHTML = msg;
        
        const overlay = document.getElementById("custom-alert-overlay");
        overlay.classList.add("active");
        
        setTimeout(() => {
            document.querySelector(".btn-alert-ok").focus();
        }, 300);
    }

    function closeCustomAlert() {
        const overlay = document.getElementById("custom-alert-overlay");
        overlay.classList.remove("active");

        // [핵심] 창이 닫힐 때 저장해둔 콜백 함수가 있다면 실행!
        if (alertCallback) {
            alertCallback();
            alertCallback = null; // 실행 후 초기화
        }
    }
    
    /**
     * 확인 누르면 지정한 URL로 이동하는 전용 helper
     * 사용: alertMove("메시지", "이동할URL");
     */
    function alertMove(message, url) {
        alert(message, function () {
            location.href = url;
        });
    }

    // 엔터키/ESC키 처리
    document.addEventListener("keydown", function(e) {
        const overlay = document.getElementById("custom-alert-overlay");
        if (overlay.classList.contains("active")) {
            if (e.key === "Enter" || e.key === "Escape") {
                e.preventDefault();
                closeCustomAlert();
            }
        }
    });
</script>