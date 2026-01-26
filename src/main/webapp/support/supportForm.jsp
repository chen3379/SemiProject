<%@page import="member.MemberDao"%>
<%@page import="support.SupportDao"%>
<%@page import="support.SupportDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

//로그인 여부 확인
String id = (String)session.getAttribute("id");
boolean isLogin = (id != null);
String roleType = isLogin ? new MemberDao().getRoleType(id) : null;
boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

if(id == null){
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
    if(!id.equals(dto.getId()) && !isAdmin){
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
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/support.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
</head>
<body>

<div class="support-container">

    <!-- 헤더 -->
    <div class="support-header">
        <h2>고객지원 문의</h2>
        <span>문의 내용을 자세히 작성해주세요</span>
    </div>

    <!-- 폼 카드 -->
    <div class="support-form">

        <form id="supportForm">

            <% if(isUpdate){ %>
                <input type="hidden" id="supportIdx" value="<%= supportIdxStr %>">
            <% } %>

            <!-- 문의 유형 -->
            <div class="form-group">
                <label>문의 유형</label>
                <select name="categoryType" id="categoryType" class="form-select">
                    <option value="0" <%= (isUpdate && "0".equals(dto.getCategoryType())) ? "selected" : "" %>>
                        회원정보
                    </option>
                    <option value="1" <%= (isUpdate && "1".equals(dto.getCategoryType())) ? "selected" : "" %>>
                        신고
                    </option>
                    <option value="2" <%= (!isUpdate || "2".equals(dto.getCategoryType())) ? "selected" : "" %>>
                        기타
                    </option>
                </select>
            </div>

            <!-- 제목 -->
            <div class="form-group">
                <label>제목</label>
                <input type="text"
                       name="title"
                       id="title"
                       class="form-control"
                       placeholder="제목을 입력하세요"
                       value="<%= isUpdate ? dto.getTitle() : "" %>"
                       required>
            </div>

            <!-- 내용 -->
            <div class="form-group">
                <label>내용</label>
                <textarea name="content"
                		  rows="10"
                          id="content"
                          class="form-control content-area"
                          placeholder="문의 내용을 입력하세요"
                          required><%= isUpdate ? dto.getContent() : "" %></textarea>
            </div>

            <!-- 비밀글 -->
            <div class="form-check">
                <input type="checkbox" name="secret" id="secret" value="1" class="form-check-input" <%= (isUpdate &&  dto != null && "1".equals(dto.getSecretType())) ? "checked" : "" %>>
                <label for="secret" class="form-check-label">
                    비밀글로 작성
                </label>
            </div>

            <!-- 버튼 -->
            <div class="form-actions">
                <button type="button" class="btn-submit" onclick="saveSupport()"><%= isUpdate ? "수정" : "등록" %></button>
                <button type="button" class="btn-cancel" onclick="history.back()">뒤로가기</button>
            </div>

        </form>

    </div>
</div>


<script type="text/javascript">

	var isUpdate = <%= isUpdate %>;
	
	function saveSupport(){
	
	  var supportIdx = $("#supportIdx").val();
	  var categoryType = $("#categoryType").val();
	  var title = $("#title").val();
	  var content = $("#content").val();
	  var secret = $("#secret").is(":checked") ? "1" : "0";
	
	  if(title.trim() === "" || content.trim() === ""){
	    alert("제목과 내용을 입력하세요");
	    return;
	  }
	
	  $.ajax({
	    url : isUpdate ? "supportUpdateAction.jsp" : "supportInsertAction.jsp",
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
	    	
	    	console.log("서버응답:", res);
	    	  if(res.result === "OK"){
	    	    alert(isUpdate ? "문의글이 수정되었습니다" : "문의글이 등록되었습니다");

	    	    if(isUpdate){
	    	      location.href = "supportDetail.jsp?supportIdx=" + supportIdx;
	    	    } else {
	    	      location.href = "supportList.jsp";
	    	    }

	    	  } else if(res.result === "NO_LOGIN"){
	    	    alert("로그인이 필요합니다");
	    	    location.href = "../login/loginForm.jsp";
	    	  } else {
	    	    alert("처리에 실패했습니다");
	    	  }
	    	}
	  });
	}
</script>

<jsp:include page="../common/customAlert.jsp" />

</body>
</html>