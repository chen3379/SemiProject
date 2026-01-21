<%@page import="board.comment.ReviewCommentDao"%>
<%@page import="board.comment.ReviewCommentDto"%>
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
    String content = request.getParameter("content");

    ReviewCommentDto dto = new ReviewCommentDto();
    dto.setBoard_idx(board_idx);
    dto.setWriter_id(loginId);
    dto.setContent(content);
    dto.setCreate_id(loginId);

    new ReviewCommentDao().insertComment(dto);

    json.put("status", "SUCCESS");

} catch (Exception e) {
    e.printStackTrace();
    json.put("status", "ERROR");
} finally {
    out.print(json.toString());
    out.flush();
}
%>
