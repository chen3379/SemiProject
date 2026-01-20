<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
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
    MemberDto memberInfo = (MemberDto) obj;

    String savePath = request.getServletContext().getRealPath("/profile_photo"); 
    System.out.println("DEBUG: 실제 저장될 물리적 경로: " + savePath); // 콘솔 출력

    // 3. MultipartRequest 생성 (여기서 예외가 발생할 가능성이 높습니다.)
    MultipartRequest multi = null;
    int maxSize = 1024 * 1024 * 10; 
    String encoding = "UTF-8";

    try {
        multi = new MultipartRequest(request, savePath, maxSize, encoding, new DefaultFileRenamePolicy());
        //new File(savePath).mkdirs();
        System.out.println("DEBUG: 파일이 성공적으로 물리적 위치에 저장됨."); // 성공 시 출력
    } catch (Exception e) {
        System.err.println("DEBUG: 파일 업로드 중 치명적인 예외 발생!");
        e.printStackTrace(); // 서버 콘솔에 상세 오류 출력
        json.put("status", "FAIL");
        json.put("message", "파일 업로드 중 오류 발생: " + e.getMessage());
        out.print(json.toString());
        return;
    }

    // 4. 파라미터 수집 (multi 객체를 통해 받아야 함)
    String requestId = multi.getParameter("id");

    String sessionId = memberInfo.getId();

    if (requestId == null || !requestId.equals(sessionId)) {
        json.put("status", "FAIL");
        json.put("message", "권한이 없습니다.");
        out.print(json.toString());
        return;
    }

    String nickname = multi.getParameter("nickname");
    String name = multi.getParameter("name");
    String gender = multi.getParameter("gender");
    String ageStr = multi.getParameter("age");
    String hp = multi.getParameter("hp");
    String addr = multi.getParameter("addr");

    String fileName = multi.getFilesystemName("photoFile"); 
    String photoPath;
    
    if (fileName != null) {
        // 새로운 사진을 올린 경우
        photoPath = "/profile_photo/" + fileName;
    } else {
        // 사진을 새로 올리지 않은 경우 기존 사진 유지
        photoPath = memberInfo.getPhoto();
    }

    int age = 0;
    try {
        if(ageStr != null && !ageStr.isEmpty()) {
            age = Integer.parseInt(ageStr);
        }
    } catch(NumberFormatException e) {
    
    }

    MemberDto updateDto = new MemberDto();

    updateDto.setId(sessionId);
    updateDto.setNickname(nickname);
    updateDto.setName(name);
    updateDto.setGender(gender);
    updateDto.setAge(age);
    updateDto.setHp(hp);
    updateDto.setAddr(addr);
    updateDto.setPhoto(photoPath);

    MemberDao dao = new MemberDao();
    int result = dao.updateMember(updateDto);
    if (result > 0) {
        memberInfo.setNickname(nickname);
        memberInfo.setName(name);
        memberInfo.setGender(gender);
        memberInfo.setAge(age);
        memberInfo.setHp(hp);
        memberInfo.setAddr(addr);
        session.setAttribute("memberInfo", memberInfo);

        json.put("status", "SUCCESS");
    } else if (result == 0) {
        json.put("status", "FAIL");
        json.put("message", "0");
    } else {
        json.put("status", "FAIL");
        json.put("message", "-1");
    }
    out.print(json.toString());
%>
