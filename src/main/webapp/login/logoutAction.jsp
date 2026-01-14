<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 보안을 위한 브라우저 캐시 방지 (로그아웃 후 뒤로가기 방지)

    // no-cache : 재검증 없이 캐시 사용 불가 명령
    // no-store : 서버에 이 페이지의 내용을 저장하지 않게 명령
    // must-revalidate : 캐시된 페이지가 있더라도 반드시 서버에서 재검증 후 사용 명령
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    // Pragma: no-cache : HTTP 1.0 호환용
    response.setHeader("Pragma", "no-cache"); 
    // setDateHeader("Expires", 0) : Proxy 서버에서 즉시 만료된 페이지로 인식, 저장 불가
    response.setDateHeader("Expires", 0); 

    // 2. 세션 무효화 (모든 세션 데이터 삭제 및 세션 ID 파기)
    // session.removeAttribute("loginStatus") 보다 전체 무효화가 더 안전합니다.
    
    session.invalidate();

    // 3. 로그아웃 완료 알림 및 메인 페이지로 이동
%>
<script>
    alert("로그아웃 되었습니다.");
    // location.replace() : 브라우저 히스토리에 남지 않아 보안에 더 좋습니다.
    location.replace("../main/mainPage.jsp");
</script>