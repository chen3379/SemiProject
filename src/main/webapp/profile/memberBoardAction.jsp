<%@page import="member.MemberDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.free.FreeBoardDao" %>
<%@ page import="board.review.ReviewBoardDao" %>
<%@ page import="board.free.FreeBoardDto" %>
<%@ page import="board.review.ReviewBoardDto" %>
<%@ page import="java.util.List" %>
<%@ page import="member.MemberDto" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    // 세션에서 로그인 정보 가져오기
    Object obj = session.getAttribute("memberInfo");
    if (obj == null) {
        response.sendError(403, "로그인이 필요합니다.");
        return;
    }
    MemberDto member = (MemberDto) obj;
    String memberId = member.getId();
    
    // 검색어 파라미터
    String search = request.getParameter("search");
    
    MemberDao memberDao = new MemberDao();
    
    List<FreeBoardDto> freeList = memberDao.getBoardListById(memberId, search);
    List<ReviewBoardDto> reviewList = memberDao.getReviewListById(memberId, search);
    
    request.setAttribute("freeBoardList", freeList);
    request.setAttribute("reviewBoardList", reviewList);
    request.setAttribute("searchKeyword", search != null ? search : "");
%>
