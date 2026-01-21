<%@page import="org.json.simple.JSONObject"%><%@page import="member.MemberDto"%><%@page import="member.MemberDao"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@page import="java.text.SimpleDateFormat"%><%
    response.setContentType("application/json");
    request.setCharacterEncoding("UTF-8");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    String id = request.getParameter("id");
    
    Object obj = session.getAttribute("memberInfo");
    MemberDto memberInfo = null;
    String loginId = null;
    
    if (obj != null) {
        memberInfo = (MemberDto) obj;
        loginId = memberInfo.getId();
    }
    
    JSONObject json = new JSONObject();
    try{
        if (obj == null) {
            json.put("status", "GUEST");
            out.print(json.toString());
            out.flush();
            return;
        }
        MemberDao memberDao = new MemberDao();
        MemberDto memberDto = memberDao.selectOneMemberbyId(id);
        if (memberDto == null) {
            json.put("status", "NOT_FOUND");
        } else {
            json.put("status", "SUCCESS");
            json.put("photo", memberDto.getPhoto());
            json.put("nickname", memberDto.getNickname());
            json.put("createDay", sdf.format(memberDto.getCreateDay()));
        
        if(loginId.equals(id)) {
            json.put("memberIdx", memberDto.getMemberIdx());
            json.put("id", memberDto.getId());
            json.put("name", memberDto.getName());
            json.put("gender", memberDto.getGender());
            json.put("age", memberDto.getAge());
            json.put("hp", memberDto.getHp());
            json.put("addr", memberDto.getAddr());
            json.put("isMine", true);
        } else {
            json.put("isMine", false);
        } 
    }
} catch (Exception e) {
    e.printStackTrace();
    json.put("status", "ERROR");
}
    out.print(json.toString());
    out.flush();
%>