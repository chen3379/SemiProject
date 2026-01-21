<%@page import="support.SupportDao"%>
<%@page import="support.SupportDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

//로그인 여부 확인
String loginId = (String)session.getAttribute("id");
String roleType = (String)session.getAttribute("roleType");
boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

if(loginId == null){
%>
<script>
alert("로그인 후 이용 가능합니다");
location.href = "../login/loginForm.jsp";
</script>
<%
return;
}

// 수정시 폼에 수정할 내용 뜨도록 하기
String supportIdxStr = request.getParameter("supportIdx");
boolean isUpdate = (supportIdxStr != null);

SupportDto dto = null;

if(isUpdate){
    int supportIdx = Integer.parseInt(supportIdxStr);
    SupportDao dao = new SupportDao();
    dto = dao.getOneData(supportIdx);
    
 	// 수정 권한 체크
    if(!loginId.equals(dto.getId()) && !isAdmin){
%>
<script>
alert("수정 권한이 없습니다");
history.back();
</script>
<%
        return;
    }
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

  <% if(isUpdate){ %>
    <input type="hidden" id="supportIdx" value="<%= supportIdxStr %>">
  <% } %>

  <!-- 문의 유형 선택 -->
  <label>문의 유형</label><br>
  <select name="categoryType" id="categoryType">
    <option value="0" <%= (isUpdate && "0".equals(dto.getCategoryType())) ? "selected" : "" %>>회원정보</option>
    <option value="1" <%= (isUpdate && "1".equals(dto.getCategoryType())) ? "selected" : "" %>>신고</option>
    <option value="2" <%= (!isUpdate || "2".equals(dto.getCategoryType())) ? "selected" : "" %>>기타</option>
  </select>
  <br><br>
  
  <label>제목</label><br>
  <input type="text" name="title" id="title" value="<%= isUpdate ? dto.getTitle() : "" %>" placeholder="제목" required><br><br>

  <label>내용</label><br>
  <textarea name="content" id="content" rows="6" cols="50" placeholder="문의 내용을 입력하세요" required>
  <%= isUpdate ? dto.getContent() : "" %></textarea><br><br>

  <label>
    <input type="checkbox" name="secret" id="secret" value="1" <%= (isUpdate && "1".equals(dto.getSecretType())) ? "checked" : "" %>>비밀글
  </label><br><br>

  <button type="button" onclick="saveSupport()"><%= isUpdate ? "수정" : "등록" %></button>
  <button type="button" onclick="history.back()">뒤로가기</button>
</form>

<script type="text/javascript">

function saveSupport(){
	  
	  var supportIdx = $("#supportIdx").val();
	  var categoryType = $("#categoryType").val();
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
	      supportIdx : supportIdx,
	      categoryType : categoryType,
	      title : title,
	      content : content,
	      secret : secret
	    },
	    success : function(res){
	      if(res.result == "OK"){
	    	alert(isUpdate ? "문의글이 수정되었습니다" : "문의글이 등록되었습니다");
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