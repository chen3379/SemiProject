<%@page import="member.MemberDao"%>
<%@page import="movie.MovieReviewDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 로그인 id 
    String id = (String)session.getAttribute("id");
    Boolean loginStatus = (Boolean)session.getAttribute("loginStatus");

    if(loginStatus == null || !loginStatus || id == null){
        out.print("{\"status\":\"NO_LOGIN\"}");
        return;
    }

    int reviewIdx = Integer.parseInt(request.getParameter("review_idx"));
    String content = request.getParameter("content");

    if(content == null || content.trim().isEmpty()){
        out.print("{\"status\":\"EMPTY_CONTENT\"}");
        return;
    }

  //관리자 여부 체크(roleType이 3 또는 9)
  	boolean isAdmin = false;
  	MemberDao memberDao = new MemberDao();
  	String roleType = memberDao.getRoleType(id);
  	isAdmin = ("3".equals(roleType) || "9".equals(roleType));

    MovieReviewDao dao = new MovieReviewDao();
    boolean success;

    if(isAdmin){
        // 관리자: 작성자 상관없이 수정
        success = dao.updateReviewByAdmin(reviewIdx, content);
    } else {
        // 작성자 본인만
        success = dao.updateReview(reviewIdx, id, content);
    }

    out.print(success ? "{\"status\":\"OK\"}" : "{\"status\":\"FAIL\"}");
%>
