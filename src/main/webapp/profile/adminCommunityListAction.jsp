<%@ page import="java.util.List" %>
<%@ page import="board.free.FreeBoardDto" %>
<%@ page import="board.review.ReviewBoardDto" %>
<%@ page import="member.AdminDao" %>
<%@ page import="member.MemberDto" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 세션 체크 (어드민 전용)
    MemberDto loginInfo = (MemberDto) session.getAttribute("memberInfo");
    if (loginInfo == null || !("8".equals(loginInfo.getRoleType()) || "9".equals(loginInfo.getRoleType()))) {
        response.setStatus(403);
        return;
    }

    // 2. 검색어 처리
    String searchKeyword = request.getParameter("search");
    if (searchKeyword == null) searchKeyword = "";

    // 3. DAO 호출 (어드민용 메서드 사용)
    AdminDao adminDao = new AdminDao();
    List<FreeBoardDto> freeList = adminDao.getAllBoardListAdmin(searchKeyword);
    List<ReviewBoardDto> reviewList = adminDao.getAllReviewListAdmin(searchKeyword);

    // 4. 요청 속성 설정
    request.setAttribute("adminFreeList", freeList);
    request.setAttribute("adminReviewList", reviewList);
    request.setAttribute("searchKeyword", searchKeyword);
%>
