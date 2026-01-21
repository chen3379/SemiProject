<%@page import="java.io.File"%>
<%@page import="board.free.FreeBoardDao"%>
<%@page import="board.free.FreeBoardDto"%>
<%@page import="member.MemberDto"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
/* ======================
   1. 로그인 체크
   ====================== */
String loginId = (String) session.getAttribute("id");
MemberDto loginMember = (MemberDto) session.getAttribute("memberInfo");

if (loginId == null || loginMember == null) {
    response.sendError(401, "LOGIN_REQUIRED");
    return;
}

/* ======================
   2. multipart 처리
   ====================== */
String savePath = application.getRealPath("/save");
int maxSize = 10 * 1024 * 1024;

File dir = new File(savePath);
if (!dir.exists()) dir.mkdirs();

MultipartRequest multi = new MultipartRequest(
    request,
    savePath,
    maxSize,
    "UTF-8",
    new DefaultFileRenamePolicy()
);

int board_idx = Integer.parseInt(multi.getParameter("board_idx"));
String category = multi.getParameter("category");
String title = multi.getParameter("title");
String content = multi.getParameter("content");
if (content == null) content = "";

/* ======================
   3. 게시글 조회
   ====================== */
FreeBoardDao dao = new FreeBoardDao();
FreeBoardDto dto = dao.getBoard(board_idx);

/* ======================
   4. 권한 체크
   - 작성자 OR 관리자
   ====================== */
boolean isOwner = loginId.equals(dto.getId());
boolean isAdmin = "ADMIN".equals(loginMember.getRoleType());

if (!isOwner && !isAdmin) {
    response.sendError(403, "NO_PERMISSION");
    return;
}

/* ======================
   5. 수정 처리
   ====================== */
dao.updateBoard(board_idx, category, title, content);
response.sendRedirect("detail.jsp?board_idx=" + board_idx);
%>
