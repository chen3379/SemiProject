<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
    <h2>현재 세션 정보 확인</h2>
    <p>로그인 ID: <%= session.getAttribute("id") %></p>
    <p>로그인 상태: <%= session.getAttribute("loginStatus") %></p>
    <p>세션 유지 시간: <%= session.getMaxInactiveInterval() %>초</p>
    <p>세션 고유 ID (쿠키값): <%= session.getId() %></p>
</body>
</html>