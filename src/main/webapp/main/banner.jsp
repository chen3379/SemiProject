<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix</title>
<link href="main.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="/NLCHS/Content/js/owl.carousel-2.3.4-custom.js"></script>
<style type="text/css">
.container{
width: 400vw;
transition: transform 0.5s;
}
.inner {
width: 100vw;
float: left;
}
.inner img{
width: 100%;
}
</style>
</head>
<body style="margin: 0;">
<div style="overflow:hidden; ">
	<div class="container">
		<div class="inner">
			<img alt="" src="../save/아바타.png">
		</div>
		<div class="inner">
			<img alt="" src="../save/만약에우리.png">
		</div>
		<div class="inner">
			<img alt="" src="../save/주토피아2.png">
		</div>
		<div class="inner">
			<img alt="" src="../save/오세이사.png">
		</div>
	</div>
</div>
<button class="btn1">1</button>
<button class="btn2">2</button>
<button class="btn3">3</button>
<script type="text/javascript">
$(".btn2").click(function() {
	let moveX = -100;
	$(".container").css("transform", "translateX(${'moveX'}vw)");
})
</script>
</body>
</html>