<%@page import="support.SupportDao"%>
<%@page import="support.SupportDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String loginId = (String)session.getAttribute("id");
if(loginId == null){
%>
<script>
alert("로그인 후 이용 가능합니다");
location.href = "../login/loginForm.jsp";
</script>
<%
return;
}

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

<h2>고객지원 문의</h2>

<form id="supportForm">

  <!-- 문의 유형 선택 -->
  <label>문의 유형</label><br>
  <select name="categoryType" id="categoryType">
    <option value="0">회원정보</option>
    <option value="1">신고</option>
    <option value="2">기타</option>
  </select>
  <br><br>
  
  <label>제목</label><br>
  <input type="text" name="title" id="title" placeholder="제목" required><br><br>

  <label>내용</label><br>
  <textarea name="content" id="content" rows="6" cols="50"
    placeholder="문의 내용을 입력하세요" required></textarea><br><br>

  <label>
    <input type="checkbox" name="secret" id="secret" value="1"> 비밀글
  </label><br><br>

  <button type="button" onclick="saveSupport()">등록</button>
  <button type="button" onclick="history.back()">뒤로가기</button>
</form>

<script type="text/javascript">

function saveSupport(){

	  var title = $("#title").val();
	  var content = $("#content").val();
	  var secret = $("#secret").is(":checked") ? "1" : "0";

	  if(title.trim()=="" || content.trim()==""){
	    alert("제목과 내용을 입력하세요");
	    return;
	  }

	  $.ajax({
	    url : "supportInsertAction.jsp",
	    type : "post",
	    dataType : "json",
	    data : {
	      title : title,
	      content : content,
	      secret : secret
	    },
	    success : function(res){
	      if(res.result == "OK"){
	        alert("문의글이 등록되었습니다");
	        location.href = "supportList.jsp";
	      } else if(res.result == "NO_LOGIN"){
	        alert("로그인이 필요합니다");
	        location.href = "../login/loginForm.jsp";
	      } else {	  
	        alert("등록 실패");
	      }
	    },
	    error : function(){
	      alert("서버 오류");
	    }
	  });
	}

</script>

</body>
</html>