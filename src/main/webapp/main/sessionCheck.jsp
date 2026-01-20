<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
    .debug-console {
        background-color: #1e1e1e;
        color: #00ff00; /* 해커 느낌 */
        font-family: 'Consolas', 'Monaco', monospace;
        padding: 20px;
        border-radius: 8px;
        border: 1px solid #333;
        margin: 100px auto;
        max-width: 800px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.5);
    }
    .debug-console h2 {
        border-bottom: 1px solid #333;
        padding-bottom: 10px;
        margin-bottom: 20px;
        color: #fff;
        font-size: 1.2rem;
    }
    .debug-item {
        margin-bottom: 8px;
        display: flex;
        justify-content: space-between;
        border-bottom: 1px dashed #333;
        padding-bottom: 4px;
    }
    .debug-key { color: #569cd6; }
    .debug-val { color: #ce9178; }
</style>
<body>
    <div class="debug-console">
        <h2>🛠️ SESSION DEBUGGER</h2>
        <div class="debug-item"><span class="debug-key">memberInfo 객체</span> <span class="debug-val"><%= session.getAttribute("memberInfo") != null %></span></div>
        <div class="debug-item"><span class="debug-key">loginStatus</span> <span class="debug-val"><%= session.getAttribute("loginStatus") %></span></div>
        <div class="debug-item"><span class="debug-key">ID</span> <span class="debug-val"><%= session.getAttribute("id") %></span></div>
        <div class="debug-item"><span class="debug-key">Nickname</span> <span class="debug-val">${sessionScope.memberInfo.nickname}</span></div>
        <div class="debug-item"><span class="debug-key">GuestUUID</span> <span class="debug-val"><%= session.getAttribute("guestUUID") %></span></div>
        <div class="debug-item"><span class="debug-key">RoleType</span> <span class="debug-val">${sessionScope.memberInfo.roleType}</span></div>
        <div class="debug-item"><span class="debug-key">Time Left</span> <span class="debug-val"><%= session.getMaxInactiveInterval() %> sec</span></div>
        <div class="debug-item"><span class="debug-key">Session ID</span> <span class="debug-val"><%= session.getId() %></span></div>
        
        <div style="margin-top: 20px; text-align: right;">
            <a href="mainPage.jsp" style="color: #fff; text-decoration: underline;">Back to Main</a>
        </div>
    </div>
</body>
</html>