<%@ page import="support.SupportAdminDao" %>
<%@ page import="support.SupportAdminDto" %>
<%@ page import="support.SupportDao" %>
<%@ page import="member.MemberDto" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");
    
    JSONObject json = new JSONObject();
    
    // 1. admin session check
    MemberDto loginInfo = (MemberDto) session.getAttribute("memberInfo");
    if (loginInfo == null || !("8".equals(loginInfo.getRoleType()) || "9".equals(loginInfo.getRoleType()))) {
        json.put("status", "FAIL");
        json.put("message", "관리자 권한이 필요합니다.");
        out.print(json.toString());
        return;
    }
    
    String idxStr = request.getParameter("supportIdx");
    String content = request.getParameter("content");
    
    if (idxStr == null || content == null || content.trim().isEmpty()) {
        json.put("status", "FAIL");
        json.put("message", "잘못된 요청입니다.");
        out.print(json.toString());
        return;
    }
    
    int supportIdx = Integer.parseInt(idxStr);
    String adminId = loginInfo.getId();
    
    try {
        SupportAdminDao adminDao = new SupportAdminDao();
        SupportAdminDto existingAnswer = adminDao.getAdminAnswer(supportIdx);
        
        if (existingAnswer == null) {
            // Insert new answer
            boolean success = adminDao.insertAdmin(supportIdx, adminId, content);
            if (success) {
                json.put("status", "SUCCESS");
            } else {
                json.put("status", "FAIL");
                json.put("message", "답변 등록 중 오류가 발생했습니다.");
            }
        } else {
            // Update existing answer
            adminDao.updateAdmin(supportIdx, content);
            json.put("status", "SUCCESS");
        }
    } catch (Exception e) {
        json.put("status", "FAIL");
        json.put("message", e.getMessage());
    }
    
    out.print(json.toString());
%>
