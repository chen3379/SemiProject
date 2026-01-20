<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
String otp = request.getParameter("otp");
String sessionOtp = (String) session.getAttribute("otp");

JSONObject json = new JSONObject();
if (otp == null || otp.trim().isEmpty()) {
    json.put("status", "SYSTEM_ERROR");
} else {
    try {
        if (sessionOtp == null) {
            json.put("status", "EXPIRED");
        } else if (!sessionOtp.equals(otp)) {
            json.put("status", "NOT_MATCH");
        } else {
            json.put("status", "SUCCESS");
        }
    } catch (Exception e) {
        json.put("status", "DB_ERROR");
    }
}
out.print(json.toString());
out.flush();
%>