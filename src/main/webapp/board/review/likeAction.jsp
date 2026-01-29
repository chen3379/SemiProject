<%@page import="board.like.ReviewLikeDao"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
JSONObject json = new JSONObject();

try {
    String loginId = (String) session.getAttribute("loginid");
    if (loginId == null) {
        json.put("status", "LOGIN_REQUIRED");
        out.print(json.toString());
        return;
    }

    int board_idx = Integer.parseInt(request.getParameter("board_idx"));

    ReviewLikeDao dao = new ReviewLikeDao();

    boolean liked;
    if (dao.isLiked(board_idx, loginId)) {
        dao.deleteLike(board_idx, loginId);
        liked = false;
    } else {
        dao.insertLike(board_idx, loginId);
        liked = true;
    }

    int count = dao.getLikeCount(board_idx);

    json.put("status", "SUCCESS");
    json.put("liked", liked);
    json.put("count", count);

} catch (Exception e) {
    e.printStackTrace();
    json.put("status", "ERROR");
} finally {
    out.print(json.toString());
    out.flush();
}
%>