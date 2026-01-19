<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="member.MemberDao" %>
<%
request.setCharacterEncoding("UTF-8");
String id = request.getParameter("id");


MemberDao memberDao = new MemberDao();
Boolean isDuplicate = memberDao.isIdDuplicate(id);

JSONObject json = new JSONObject();
if (isDuplicate == null) {
    json.put("isDuplicate", null);
} else if (isDuplicate) {
    json.put("isDuplicate", true);
} else {
    json.put("isDuplicate", false);
}   

out.print(json.toString());
out.flush();
%>