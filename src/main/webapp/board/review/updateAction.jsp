<%@page import="java.io.File"%>
<%@page import="board.review.ReviewBoardDao"%>
<%@page import="board.review.ReviewBoardDto"%>
<%@page import="member.MemberDto"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page contentType="text/html; charset=UTF-8" %>

<%

String loginId = (String) session.getAttribute("id");
MemberDto loginMember = (MemberDto) session.getAttribute("memberInfo");

if (loginId == null || loginMember == null) {
    response.sendError(401, "LOGIN_REQUIRED");
    return;
}

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
String title = multi.getParameter("title");
String content = multi.getParameter("content");
String genre = multi.getParameter("genre"); // 장르 사용 시
int is_spoiler = 0;
String spoilerParam = multi.getParameter("is_spoiler");

if (spoilerParam != null) {
    is_spoiler = Integer.parseInt(spoilerParam);
}
boolean isSpoiler = (is_spoiler == 1);
if (content == null) content = "";

/* 새로 업로드된 파일 */
String newFileName = multi.getFilesystemName("uploadFile");

ReviewBoardDao dao = new ReviewBoardDao();
ReviewBoardDto dto = dao.getBoard(board_idx);

if (dto == null) {
    response.sendError(404, "NOT_FOUND");
    return;
}


boolean isOwner = loginId.equals(dto.getId());
boolean isAdmin = "ADMIN".equals(loginMember.getRoleType());

if (!isOwner && !isAdmin) {
    response.sendError(403, "NO_PERMISSION");
    return;
}

String finalFileName = dto.getFilename(); // 기존 파일

if (newFileName != null) {
    finalFileName = newFileName;
}

dao.updateBoard(
	    board_idx,
	    title,
	    content,
	    genre,
	    isSpoiler,
	    finalFileName
	);

response.sendRedirect("detail.jsp?board_idx=" + board_idx);
%>
