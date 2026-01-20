<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

// 로그인 체크
String id = (String)session.getAttribute("id");
if(id == null){
    out.print("{\"result\":\"NO_LOGIN\"}");
    return;
}

// 파라미터 받기
int supportIdx = Integer.parseInt(request.getParameter("supportIdx"));
String categoryType = request.getParameter("categoryType");
String title = request.getParameter("title");
String content = request.getParameter("content");
String secret = request.getParameter("secret");

// 최소 방어
if(categoryType == null || categoryType.trim().equals("")){
    categoryType = "2"; // 기타
}
if(secret == null){
    secret = "0";
}

// DAO 호출
SupportDao dao = new SupportDao();
boolean ok = dao.updateSupport(categoryType, title, content, secret, id, supportIdx);

// 결과 반환
out.print(ok ? "{\"result\":\"OK\"}" : "{\"result\":\"FAIL\"}");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
</head>
<body>

</body>
</html>