<%@page import="member.MemberDao"%>
<%@page import="movie.MovieRatingStatDao"%>
<%@page import="movie.MovieRatingDao"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="movie.MovieReviewDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	JSONObject json = new JSONObject();
	
	String movieIdxStr  = request.getParameter("movie_idx");
	String reviewIdxStr = request.getParameter("review_idx");
	
	if(movieIdxStr == null || reviewIdxStr == null){
	  json.put("status", "FAIL");
	  json.put("msg", "param missing");
	  out.print(json.toString());
	  return;
	}
	
	//로그인한 사용자 id 가져오기
	String id = (String)session.getAttribute("id");
	if(id == null){
		  json.put("status","FAIL");
		  json.put("message","LOGIN_REQUIRED");
		  out.print(json.toString());
		  return;
		}
	
	int movieIdx  = Integer.parseInt(movieIdxStr);
	int reviewIdx = Integer.parseInt(reviewIdxStr);
	
	//관리자 여부 체크(roleType이 3 또는 9)
	boolean isAdmin = false;
	MemberDao memberDao = new MemberDao();
	String roleType = memberDao.getRoleType(id);
	isAdmin = ("3".equals(roleType) || "9".equals(roleType));
	
	MovieReviewDao dao = new MovieReviewDao();
	
	//작성자 id 불러오기
	String writerId = dao.getReviewWriterId(reviewIdx);
	
	//리뷰삭제
	boolean ok = false;
	
	if(isAdmin){
		ok = dao.deleteReviewByAdmin(reviewIdx);
	}else{
		ok = dao.deleteReview(reviewIdx, id);
	}
	
	if(!ok){
	  json.put("status","FAIL");
	  json.put("message","삭제 권한이 없거나 이미 삭제된 글입니다.");
	  out.print(json.toString());
	  return;
	}
	
	//별점도 삭제
	MovieRatingDao ratingDao = new MovieRatingDao();
	
	if(writerId != null){
	    ratingDao.deleteRating(movieIdx, writerId);
	}
	
	//별점통계도 삭제
	MovieRatingStatDao statDao = new MovieRatingStatDao();
	statDao.refreshStat(movieIdx);
	
	json.put("status", "OK");
	out.print(json.toString());
	return;
%>