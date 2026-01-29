<%@page import="org.json.simple.JSONObject"%><%@page import="member.MemberDto"%><%@page import="member.MemberDao"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%@page import="java.text.SimpleDateFormat"%><%
response.setContentType("application/json");
request.setCharacterEncoding("UTF-8");
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String nickname = request.getParameter("nickname");
    String loginId = session.getId();
    Object obj = session.getAttribute("memberInfo");
    MemberDto memberInfo = null;
    String loginNickname = null;
    if (obj !=null){
        memberInfo = (MemberDto) obj;
        loginNickname = memberInfo.getNickname();
    }

    JSONObject json = new JSONObject();

    

    try{
        MemberDao memberDao = new MemberDao();
        // 1. 닉네임으로 먼저 검색
        MemberDto memberDto = memberDao.selectOneMemberbyNickname(nickname);
        
        // 2. 닉네임으로 검색 안 되면 아이디로 검색 시도 (Robust Search)
        if (memberDto == null) {
            memberDto = memberDao.selectOneMemberbyId(nickname);
        }

        if (memberDto == null) {
            json.put("status", "NOT_FOUND");
        } else {
            json.put("status", "SUCCESS");
            json.put("photo", memberDto.getPhoto());
            json.put("nickname", memberDto.getNickname());
            json.put("id", memberDto.getId()); // 아이디 항상 반환
            json.put("createDay", sdf.format(memberDto.getCreateDay()));
            
            // matches id for isMine check
            if(loginId != null && loginId.equals(memberDto.getId())) {
                json.put("memberIdx", memberDto.getMemberIdx());
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