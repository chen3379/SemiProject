
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@page import="member.MemberDao"%>
<%@page import="member.MemberDto"%>
<%
response.setContentType("application/json");
request.setCharacterEncoding("UTF-8");
JSONObject json = new JSONObject();

String inputId = request.getParameter("id");
String inputPassword = request.getParameter("password");
String saveId = request.getParameter("saveid");
MemberDao memberDao = new MemberDao();


if (inputId == null || inputPassword == null || inputId.trim().isEmpty() || inputPassword.trim().isEmpty()) {
    json.put("status", "FAIL");
    out.print(json.toString());
    return; 
}

try {

String dbHashedPassword = memberDao.getHashedPassword(inputId);

	// BCrypt.checkpw(pw, hashedPw) : 입력된 비밀번호와 데이터베이스에 저장된 해시된 비밀번호가 일치하는지 확인
	if (dbHashedPassword != null && BCrypt.checkpw(inputPassword, dbHashedPassword)) {
		MemberDto memberDto = memberDao.selectOneMemberbyId(inputId);
		session.setAttribute("id", inputId);
	 	session.setAttribute("loginid", inputId);  
		session.setAttribute("saveId", (saveId != null ? "true" : "false"));
		session.setAttribute("loginStatus", true);
		session.setAttribute("memberInfo", memberDto);
		session.setMaxInactiveInterval(60 * 60 * 8);

		session.removeAttribute("guestUUID");

		json.put("status", "SUCCESS");
	} else {
		json.put("status", "FAIL");
	}
}
catch (Exception e) {
    e.printStackTrace();
    json.put("status", "ERROR");
}
out.print(json.toString());
out.flush();
%>