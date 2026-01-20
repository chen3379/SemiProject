<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>WhatFlix</title>
<link href="main.css" rel="stylesheet">
<style type="text/css">
.container{
width: 300vw;
transform : translate(-100vw); 
}
.inner {
width: 100vw;
float: left;
}
.inner img{
width: 50%;
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
<button class="버튼1">1</button>
<button class="버튼2">2</button>
<button class="버튼3">3</button>
<script type="text/javascript">
$(".버튼1").click(function() {
	$(".container").css("transform","translate(-100px)")
})
</script>
</body>
</html>