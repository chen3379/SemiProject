<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
    /* 1. 배경 오버레이 (화면 전체 어둡게) */
    #custom-alert-overlay {
        display: none; /* 기본 숨김 */
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.7); /* 넷플릭스 특유의 진한 어둠 */
        backdrop-filter: blur(5px); /* 고급스러운 블러 처리 */
        z-index: 99999; /* 무조건 최상단 */
        align-items: center;
        justify-content: center;
        opacity: 0;
        transition: opacity 0.3s ease;
    }

    /* 2. 알림창 본체 */
    .custom-alert-box {
        background-color: #141414; /* 넷플릭스 배경색 */
        width: 400px;
        max-width: 90%;
        border-radius: 8px;
        box-shadow: 0 15px 40px rgba(0,0,0,0.8);
        border: 1px solid #333;
        transform: scale(0.8);
        transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        overflow: hidden;
        text-align: center;
    }

    /* 3. 헤더 (로고 느낌) */
    .alert-header {
        padding: 20px 0 10px;
    }
    .alert-header h2 {
        color: #E50914; /* 넷플릭스 레드 */
        font-size: 1.2rem;
        font-weight: 900;
        margin: 0;
        letter-spacing: 1px;
    }

    /* 4. 메시지 내용 */
    .alert-body {
        padding: 10px 30px 30px;
        color: #fff;
        font-size: 1rem;
        line-height: 1.6;
        word-break: keep-all;
        color: #cccccc;
    }

    /* 5. 확인 버튼 영역 */
    .alert-footer {
        padding: 0 0 25px;
    }
    
    .btn-alert-ok {
        background-color: #E50914;
        color: white;
        border: none;
        padding: 10px 40px;
        font-size: 0.95rem;
        font-weight: bold;
        border-radius: 4px;
        cursor: pointer;
        transition: background 0.2s;
    }

    .btn-alert-ok:hover {
        background-color: #C11119;
    }
    
    .btn-alert-ok:focus {
        outline: 2px solid white;
        outline-offset: 2px;
    }

    /* 활성화 클래스 */
    #custom-alert-overlay.active {
        display: flex;
        opacity: 1;
    }
    
    #custom-alert-overlay.active .custom-alert-box {
        transform: scale(1);
    }
</style>

<div id="custom-alert-overlay">
    <div class="custom-alert-box">
        <div class="alert-header">
            <h2>WHATFLIX</h2>
        </div>
        <div class="alert-body" id="custom-alert-msg">
            </div>
        <div class="alert-footer">
            <button class="btn-alert-ok" onclick="closeCustomAlert()">확인</button>
        </div>
    </div>
</div>

<script>
    /**
     * [핵심] 브라우저 기본 alert() 함수 덮어쓰기 (Override)
     * 이제 어디서든 alert('메시지')를 호출하면 이 함수가 실행됩니다.
     */
    window.alert = function(message) {
        openCustomAlert(message);
    };

    // 알림창 열기
    function openCustomAlert(msg) {
        // 메시지 줄바꿈 처리 (\n -> <br>)
        if(msg) {
            msg = msg.replace(/\n/g, "<br>");
        }
        document.getElementById("custom-alert-msg").innerHTML = msg;
        
        // CSS 애니메이션 활성화
        const overlay = document.getElementById("custom-alert-overlay");
        overlay.classList.add("active");
        
        // 버튼에 포커스 (엔터 치면 바로 닫히게)
        setTimeout(() => {
            document.querySelector(".btn-alert-ok").focus();
        }, 100);
    }

    // 알림창 닫기
    function closeCustomAlert() {
        const overlay = document.getElementById("custom-alert-overlay");
        overlay.classList.remove("active");
    }

    // 엔터키나 ESC키로 닫기 지원
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