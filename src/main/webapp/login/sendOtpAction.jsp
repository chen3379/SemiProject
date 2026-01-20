<%@page import="member.MemberDao"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String id = request.getParameter("id");

JSONObject json = new JSONObject();
if (id == null || id.trim().isEmpty()) {
    json.put("status", "SYSTEM_ERROR");
} else {

    try {
        MemberDao memberDao = new MemberDao();
        String result = memberDao.IsIdExist(id);
        if (result.equals("SUCCESS")) {
            String otp = memberDao.createOtp();
            session.setAttribute("otp", otp);
            session.setAttribute("id", id);
            session.setMaxInactiveInterval(5 * 60);
            json.put("status", "SUCCESS");
        } else {
            json.put("status", "NOT_FOUND");
        }
    } catch (Exception e) {
        json.put("status", "DB_ERROR");
    } 
}
out.print(json.toString());
out.flush();
%>