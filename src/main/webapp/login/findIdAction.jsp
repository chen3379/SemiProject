<%@page import="java.sql.SQLException"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="member.MemberDao"%>
<%@page import="member.MemberDto"%><%
    request.setCharacterEncoding("UTF-8");
    String nickname = request.getParameter("nickname");
    JSONObject json = new JSONObject();

    try {
        MemberDao memberDao = new MemberDao();
        List<String> rawIdList = memberDao.getIdListByNickname(nickname);
        
        if (rawIdList == null || rawIdList.isEmpty()) {
            json.put("status", "NOT_FOUND");
        } else {
            json.put("status", "SUCCESS");
            json.put("nickname", nickname);
            json.put("count", rawIdList.size());
            JSONArray maskedIdList = new JSONArray(); 
            for (String id : rawIdList) {
                maskedIdList.add(maskEmail(id));
            }
            json.put("idList", maskedIdList);

        } 
    } catch (SQLException e) {
    System.err.println("[LOG] 아이디 조회 중 오류 발생: " + e.getMessage());
    e.printStackTrace();
    json.put("status", "DB_ERROR");
    
    } catch (Exception e) {
    System.err.println("[LOG] 알 수 없는 시스템 에러: " + e.getMessage());
    e.printStackTrace();
    json.put("status", "SYSTEM_ERROR");
    } finally {
        out.print(json.toString());
        out.flush(); 
    }

%>
<%!
    /**
     * 이메일 마스킹 처리 함수 (wha*******@naver.com)
     */
    private String maskEmail(String email) {
        if (email == null || !email.contains("@")) return email;
        String[] parts = email.split("@");
        String idPart = parts[0];
        String domain = parts[1];

        if (idPart.length() <= 3) {
            return idPart.replaceAll(".", "*") + "@" + domain;
        } else {
            // 앞 3글자만 노출하고 나머지는 별표 처리
            return idPart.substring(0, 3) + idPart.substring(3).replaceAll(".", "*") + "@" + domain;
        }
    }
%>