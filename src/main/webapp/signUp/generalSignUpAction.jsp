<%@page import="org.json.simple.JSONObject"%>
<%@page import="member.MemberDao"%>
<%@page import="member.MemberDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<%
response.setContentType("application/json");
request.setCharacterEncoding("UTF-8");

String inputNickname = request.getParameter("nickname");
String inputId = request.getParameter("id");
String inputPassword = request.getParameter("password");

JSONObject json = new JSONObject();

if (inputNickname == null || inputId == null || inputPassword == null || inputNickname.trim().isEmpty() || inputId.trim().isEmpty() || inputPassword.trim().isEmpty()) {
    json.put("status", "FAIL");
    out.print(json.toString());
    return; 
}

try {

// BCrypt를 사용하여 비밀번호 해싱 
String hashedPassword = BCrypt.hashpw(inputPassword, BCrypt.gensalt());

MemberDto memberDto = new MemberDto();
memberDto.setId(inputId);
memberDto.setPassword(hashedPassword); 
memberDto.setNickname(inputNickname);

MemberDao memberDao = new MemberDao();

String result = memberDao.insertMember(memberDto);

if ("SUCCESS".equals(result)) {
     
     json.put("status", "SUCCESS");
} else if ("DUPLICATE".equals(result)) {
    
    json.put("status", "DUPLICATE");
    json.put("id", inputId);
} else if ("FAIL".equals(result)) {
     
     json.put("status", "FAIL");
     json.put("id", inputId);
} else {
     
     json.put("status", "ERROR");
}
}catch (Exception e) {
    e.printStackTrace();
     
     json.put("status", "ERROR");
}

out.print(json.toString());
out.flush();
%>
