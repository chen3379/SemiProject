<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>WHATFLIX</title>

		<link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
	</head>

	<body>
		<header>
			<jsp:include page="nav.jsp" />
			<jsp:include page="../login/loginModal.jsp" />
			<jsp:include page="../profile/profileModal.jsp" />

		</header>
		<main>
			<jsp:include page="sideBar.jsp" />
			<jsp:include page="movieSection.jsp" />
			<jsp:include page="communitySection.jsp" />
		</main>
		<footer>
			<jsp:include page="footer.jsp"></jsp:include>
		</footer>


	</body>

	</html>