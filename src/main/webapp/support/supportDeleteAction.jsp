<%@page import="member.MemberDao"%>
<%@page import="support.SupportDto"%>
<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="../common/customAlert.jsp" />
<%
request.setCharacterEncoding("UTF-8");

String loginId = (String)session.getAttribute("id");
if(loginId == null){
%>
<script>
openCustomAlert("로그인 후 이용 가능합니다", function() {
    location.href = "../login/loginForm.jsp";
});
</script>
<%
return;
}

int supportIdx = Integer.parseInt(request.getParameter("supportIdx"));

SupportDao dao = new SupportDao();
SupportDto dto = dao.getOneData(supportIdx);

// 이미 삭제된 글
if("1".equals(dto.getDeleteType())){
%>
<script>
openCustomAlert("이미 삭제된 글입니다", function() {
    location.href = "supportList.jsp";
});
</script>
<%
return;
}

// 권한 체크
String roleType = new MemberDao().getRoleType(loginId);
boolean isAdmin = ("3".equals(roleType) || "9".equals(roleType));

if(!isAdmin && !loginId.equals(dto.getId())){
%>
<script>
openCustomAlert("삭제 권한이 없습니다", function() {
    history.back();
});
</script>
<%
return;
}

// 삭제 처리
dao.deleteSupport(supportIdx);
%>

<script>
openCustomAlert("삭제되었습니다", function() {
    location.href = "supportList.jsp";
});
</script>