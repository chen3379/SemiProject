<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>WHATFLIX</title>

		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
	</head>

	<body>
		<header>
			<jsp:include page="../main/nav.jsp" />
			<jsp:include page="../login/loginModal.jsp" />
			<jsp:include page="../profile/profileModal.jsp" />
		</header>

		<main>
			<div class="container">
				<form id="searchForm">
					<input type="text" name="id" id="searchId" placeholder="아이디 입력">
					<button type="submit" id="btnSearch">프로필 검색</button>
				</form>
			</div>

			<div class="wrapper">
				<nav id="side-nav">
					<jsp:include page="profileNav.jsp" />
				</nav>


				<div id="content-area">
					<jsp:include page="profile-nav-list/memberInfo.jsp" />
				</div>
			</div>

			<script>
				$(document).ready(function () {

				})
			</script>
		</main>

		<footer>

		</footer>

	</html>