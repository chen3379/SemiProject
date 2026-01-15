<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<body>
    <h2>현재 세션 정보 확인</h2>
    <p>memberInfo 객체 존재 여부 : <%= session.getAttribute("memberInfo") != null %></p>
    <p>loginStatus : <%= session.getAttribute("loginStatus") %></p>
    <p>id : <%= session.getAttribute("id") %></p>
    <p>nickname : ${sessionScope.memberInfo.nickname}</p>
    <p>guestUUID: <%= session.getAttribute("guestUUID") %></p>
    <p>saveid : <%= session.getAttribute("saveid") %></p>
    <p>roleType : ${sessionScope.memberInfo.roleType}</p>
    <p>세션 유지 시간 : <%= session.getMaxInactiveInterval() %>초</p>
    <p>세션 고유 ID (쿠키값) : <%= session.getId() %></p>
</body>
</html>