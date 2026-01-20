<%@page import="member.MemberDao"%>
<%@page import="org.json.simple.JSONObject"%><%@ page import="org.mindrot.jbcrypt.BCrypt" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
    request.setCharacterEncoding("UTF-8");

    String password = request.getParameter("password");
    String id = session.getAttribute("id").toString();

    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    JSONObject json = new JSONObject();
    try {
        MemberDao memberDAO = new MemberDao();
        int result = memberDAO.updatePassword(id, hashedPassword);

        if (result > 0) {
            json.put("status", "SUCCESS");
        } else if (result == 0) {
            json.put("status", "DB_ERROR");
        } else {
            json.put("status", "DB_ERROR");
        }
    } catch (Exception e) {
        e.printStackTrace();
        json.put("status", "SYSTEM_ERROR");
    } finally {
        session.removeAttribute("otp");
        session.removeAttribute("id"); 
        out.print(json.toString());
        out.flush();
    }
%>