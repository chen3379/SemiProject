<%@page import="support.SupportDto"%>
<%@page import="support.FaqDto"%>
<%@page import="java.util.List"%>
<%@page import="support.FaqDao"%>
<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
SupportDao sDao = new SupportDao();
FaqDao fDao = new FaqDao();

String status = request.getParameter("status"); // 관리자만 사용
String order = request.getParameter("order");   // 최신/오래된순

List<FaqDto> faqList = fDao.getActiveFaq();
List<SupportDto> list = sDao.getList(status, order);
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