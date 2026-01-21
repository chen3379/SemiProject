<%@ page import="member.AdminDao" %>
<%@ page import="member.MemberDto" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");
    
    JSONObject json = new JSONObject();
    
    // 1. 세션 체크 (어드민 전용)
    MemberDto loginInfo = (MemberDto) session.getAttribute("memberInfo");
    if (loginInfo == null || !("8".equals(loginInfo.getRoleType()) || "9".equals(loginInfo.getRoleType()))) {
        json.put("status", "FAIL");
        json.put("message", "관리자 권한이 필요합니다.");
        out.print(json.toString());
        return;
    }
    
    String type = request.getParameter("type");
    String idxStr = request.getParameter("idx");
    
    if (type == null || idxStr == null) {
        json.put("status", "FAIL");
        json.put("message", "잘못된 요청입니다.");
        out.print(json.toString());
        return;
    }
    
    int boardIdx = Integer.parseInt(idxStr);
    
    try {
        AdminDao adminDao = new AdminDao();
        if ("free".equals(type)) {
            adminDao.deleteFreeBoardAdmin(boardIdx);
        } else if ("review".equals(type)) {
            adminDao.deleteReviewBoardAdmin(boardIdx);
        }
        
        json.put("status", "SUCCESS");
    } catch (Exception e) {
        json.put("status", "FAIL");
        json.put("message", e.getMessage());
    }
    
    out.print(json.toString());
%>
