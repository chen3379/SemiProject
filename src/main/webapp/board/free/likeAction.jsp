<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="board.like.FreeLikeDao" %>

<%
JSONObject json = new JSONObject();

String loginId = (String) session.getAttribute("loginid");
int board_idx = Integer.parseInt(request.getParameter("board_idx"));

if (loginId == null) {
    json.put("status", "LOGIN_REQUIRED");
    out.print(json.toString());
    return;
}

FreeLikeDao likeDao = new FreeLikeDao();

// 이미 좋아요 했는지
boolean isLiked = likeDao.isLiked(board_idx, loginId);

if (isLiked) {
    likeDao.deleteLike(board_idx, loginId);
} else {
    likeDao.insertLike(board_idx, loginId);
}

// 최신 상태
int count = likeDao.getLikeCount(board_idx);

json.put("status", "SUCCESS");
json.put("liked", !isLiked);
json.put("count", count);

out.print(json.toString());
out.flush();
%>
