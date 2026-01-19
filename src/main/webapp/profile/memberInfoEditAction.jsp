<%@page import="member.MemberDao"%>
<%@page import="member.MemberDto"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json");

    JSONObject json = new JSONObject();

    Object obj = session.getAttribute("memberInfo");
    if (obj == null) {
        json.put("status", "FAIL");
        json.put("message", "로그인이 필요합니다.");
        out.print(json.toString());
        return;
    }

    MemberDto loginMember = (MemberDto) obj;
    String id = request.getParameter("id");

        if (id == null || !id.equals(loginMember.getId())) {
        json.put("status", "FAIL");
        json.put("message", "권한이 없습니다.");
        out.print(json.toString());
        return;
    }

    String nickname = request.getParameter("nickname");
    String name = request.getParameter("name");
    String gender = request.getParameter("gender");
    String ageStr = request.getParameter("age");
    String hp = request.getParameter("hp");
    String addr = request.getParameter("addr");

    int age = 0;
    try {
        if(ageStr != null && !ageStr.isEmpty()) {
            age = Integer.parseInt(ageStr);
        }
    } catch(NumberFormatException e) {
    
    }

    MemberDto updateDto = new MemberDto();
    updateDto.setId(id);
    updateDto.setNickname(nickname);
    updateDto.setName(name);
    updateDto.setGender(gender);
    updateDto.setAge(age);
    updateDto.setHp(hp);
    updateDto.setAddr(addr);
    updateDto.setPhoto(loginMember.getPhoto());

    MemberDao dao = new MemberDao();
    int result = dao.updateMember(updateDto);
    if (result > 0) {
        json.put("status", "SUCCESS");
        loginMember.setNickname(nickname);
        loginMember.setName(name);
        loginMember.setGender(gender);
        loginMember.setAge(age);
        loginMember.setHp(hp);
        loginMember.setAddr(addr);
        session.setAttribute("memberInfo", loginMember);
    } else {
        json.put("status", "FAIL");
        json.put("message", "DB 업데이트 실패");
    }

    out.print(json.toString());
%>
