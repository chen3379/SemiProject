<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="member.MemberDto"%>
<%@ page import="member.MemberDao"%>
<%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");

    Object obj = session.getAttribute("memberInfo");
    String roleType = null;

    if (obj != null) {
        MemberDto memberInfo = (MemberDto) obj;
        roleType = memberInfo.getRoleType();
    }

    JSONObject json = new JSONObject();

    if (roleType == null || Integer.parseInt(roleType) < 8) {
        json.put("status", "FORBIDDEN");
        json.put("message", "관리자 권한이 필요합니다.");
        out.print(json.toString()); // toJSONString() 대신 toString() 사용
        return;
    }

    String targetId = request.getParameter("id");
    MemberDao memberDao = new MemberDao();
    MemberDto targetDto = memberDao.selectOneMemberbyId(targetId);
    
    if (targetDto != null) {
        json.put("status", "SUCCESS");
        json.put("id", targetDto.getId());
        json.put("roleType", targetDto.getRoleType());
        json.put("status", targetDto.getStatus());
        json.put("joinType", targetDto.getJoinType());
        json.put("name", targetDto.getName());
        json.put("nickname", targetDto.getNickname());
        json.put("hp", targetDto.getHp());
        json.put("age", targetDto.getAge());
        json.put("gender", targetDto.getGender());
        json.put("addr", targetDto.getAddr());
        json.put("photo", targetDto.getPhoto());
    } else {
        json.put("status", "NOT_FOUND");
    }

    // 25라인 부근 에러 해결: toString()으로 변경
    out.print(json.toString());
%>
