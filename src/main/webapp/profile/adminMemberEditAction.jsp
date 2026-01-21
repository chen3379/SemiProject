<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="member.AdminDao" %>
<%@ page import="member.MemberDto" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%
    // 서버 로그 시작 알림 (Console 확인용)
    System.out.println("========== [AdminMemberEditAction] 시작 ==========");
    
    String realPath = request.getServletContext().getRealPath("/profile_photo");
    File saveDir = new File(realPath);
    if(!saveDir.exists()) {
        System.out.println("[Log] 경로가 없어 폴더를 생성합니다: " + realPath);
        saveDir.mkdirs();
    }

    int uploadSize = 1024 * 1024 * 5;
    
    try {
        MultipartRequest multi = new MultipartRequest(request, realPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());
        
        AdminDao dao = new AdminDao();
        MemberDto dto = new MemberDto();

        // 파라미터 로깅
        String id = multi.getParameter("id");
        System.out.println("[Log] 수정한 대상 ID: " + id);
        
        dto.setId(id);
        dto.setRoleType(multi.getParameter("roleType"));
        dto.setStatus(multi.getParameter("status"));
        dto.setJoinType(multi.getParameter("joinType"));
        dto.setName(multi.getParameter("name"));
        dto.setNickname(multi.getParameter("nickname"));
        dto.setHp(multi.getParameter("hp"));
        dto.setGender(multi.getParameter("gender"));
        dto.setAddr(multi.getParameter("addr"));

        String ageStr = multi.getParameter("age");
        int age = (ageStr != null && !ageStr.trim().isEmpty()) ? Integer.parseInt(ageStr) : 0;
        dto.setAge(age);

        String photoFile = multi.getFilesystemName("photoFile");
        if (photoFile != null) {
            String dbPath = "/profile_photo/" + photoFile;
            dto.setPhoto(dbPath);
            System.out.println("[Log] 새 프로필 사진 업로드됨: " + dbPath);
        } else {
            System.out.println("[Log] 사진 변경 없음 (기존 유지)");
        }

        // 5. DAO 업데이트 실행 및 결과 로그
        boolean success = dao.updateMemberByAdminFull(dto);
        System.out.println("[Log] DB 업데이트 성공 여부: " + success);
        
        if (success) {
            out.print("{\"status\": \"SUCCESS\"}");
        } else {
            // 실패 원인은 대부분 SQL 쿼리 혹은 데이터 타입 불일치입니다.
            System.out.println("[Error] DB 업데이트 실패: 쿼리 실행 결과가 false입니다.");
            out.print("{\"status\": \"FAIL\", \"message\": \"DB 업데이트 실패 (콘솔 로그 확인)\"}");
        }
        
    } catch (Exception e) {
        System.out.println("[Critical Error] 액션 실행 중 예외 발생!");
        e.printStackTrace(); // 서버 콘솔(Log)에 상세 에러(StackTrace)를 뿌립니다.
        out.print("{\"status\": \"FAIL\", \"message\": \"" + e.getMessage().replace("\"", "'") + "\"}");
    }
    
    System.out.println("========== [AdminMemberEditAction] 종료 ==========");
%>
