<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

/*
 * 테스트용 로그인 처리
 * DB에 존재하는 아이디로 변경해서 사용
 */
String testId = request.getParameter("id");
if (testId == null || testId.trim().equals("")) {
    testId = "hhkim";   // ⭐ DB에 있는 아이디
}

/* ===== 세션 세팅 ===== */
session.setAttribute("loginid", testId);     // 게시글/좋아요에서 쓰는 키
session.setAttribute("loginStatus", true);
session.setAttribute("roleType", "ADMIN");   // ADMIN / USER 테스트 가능

// 기존 비회원 UUID 있으면 제거
session.removeAttribute("guestUUID");

/* ===== 이동 ===== */
response.sendRedirect(request.getContextPath() + "/board/free/list.jsp");
%>
