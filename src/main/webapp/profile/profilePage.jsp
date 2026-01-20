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
		<style>
			/* 좌우 배치를 위한 핵심 스타일 */
			.wrapper {
				display: flex;
				/* 자식 요소를 가로로 나열 */
				align-items: flex-start;
				/* 콘텐츠 높이가 달라도 위쪽 정렬 */
				gap: 20px;
				/* 좌우 간격 */
				padding: 20px;
			}

			#side-nav {
				flex: 0 0 250px;
				/* 사이드바 너비를 250px로 고정 */
			}

			#content-area {
				flex: 1;
				/* 남은 공간을 모두 차지 */
			}
		</style>
	</head>

	<body>
		<header>
			<jsp:include page="../main/nav.jsp" />
			<jsp:include page="../login/loginModal.jsp" />
			<jsp:include page="../profile/profileModal.jsp" />
		</header>

		<main>
			<div class="wrapper">
				<nav id="side-nav">
					<jsp:include page="profileNav.jsp" />
				</nav>


				<div id="content-area">
					<jsp:include page="memberInfo.jsp" />
				</div>
			</div>

			<div id="mainContentArea"></div>

		</main>

		<footer>
			<jsp:include page="../main/footer.jsp" />
		</footer>
	</body>

	</html>