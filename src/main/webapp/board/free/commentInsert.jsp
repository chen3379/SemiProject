<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.comment.*" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
request.setCharacterEncoding("UTF-8");
JSONObject json = new JSONObject();

/* ===== 로그인 체크 ===== */
String loginId = (String) session.getAttribute("loginid");
if (loginId == null) {
    json.put("status", "LOGIN_REQUIRED");
    out.print(json.toString());
    return;
}

try {
    int board_idx = Integer.parseInt(request.getParameter("board_idx"));
    String content = request.getParameter("content");

    int parent_comment_idx = 0;
    if (request.getParameter("parent_comment_idx") != null) {
        parent_comment_idx = Integer.parseInt(request.getParameter("parent_comment_idx"));
    }

    FreeCommentDto dto = new FreeCommentDto();
    dto.setBoard_idx(board_idx);
    dto.setWriter_id(loginId);        
    dto.setContent(content);
    dto.setParent_comment_idx(parent_comment_idx);
    dto.setCreate_id(loginId);

    new FreeCommentDao().insertComment(dto);

    json.put("status", "SUCCESS");

} catch (Exception e) {
    e.printStackTrace();
    json.put("status", "ERROR");
}

out.print(json.toString());
out.flush();
%>
