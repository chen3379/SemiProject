<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.free.FreeBoardDao" %>
<%@ page import="board.review.ReviewBoardDao" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="member.MemberDto" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");
    
    JSONObject json = new JSONObject();
    
    // 세션 체크
    Object obj = session.getAttribute("memberInfo");
    if (obj == null) {
        json.put("status", "FAIL");
        json.put("message", "로그인이 필요합니다.");
        out.print(json.toString());
        return;
    }
    
    String type = request.getParameter("type"); // "free" or "review"
    String idxStr = request.getParameter("idx");
    
    if (type == null || idxStr == null) {
        json.put("status", "FAIL");
        json.put("message", "잘못된 요청입니다.");
        out.print(json.toString());
        return;
    }
    
    int boardIdx = Integer.parseInt(idxStr);
    
    try {
        MemberDao dao = new MemberDao();
        if ("free".equals(type)) {
            // FreeBoardDao의 deleteBoard를 MemberDao로 가져오는 대신 
            // MemberDao에 deleteFreeBoard(int board_idx)를 추가해야 할 수도 있지만,
            // 사용자의 요청은 "이 메서드(새로 만든 것들)"를 MemberDao에 넣으라는 것이었음.
            // 하지만 일관성을 위해 MemberDao를 사용하는 것이 좋음.
            // 일단 FreeBoardDao의 deleteBoard는 원래 있던 것이니 유지하되, 
            // MemberDao에서 호출하게 리팩토링할지 결정해야 함.
            // 사용자 요청에 맞춰 MemberDao에 deleteBoard도 추가하는 것이 깔끔할 듯.
            
            // [수정] 아래에서 MemberDao에 deleteBoard 추가 예정
            dao.deleteBoard(boardIdx); 
        } else if ("review".equals(type)) {
            dao.deleteReview(boardIdx);
        }
        
        json.put("status", "SUCCESS");
    } catch (Exception e) {
        json.put("status", "FAIL");
        json.put("message", e.getMessage());
    }
    
    out.print(json.toString());
%>
