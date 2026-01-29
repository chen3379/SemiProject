<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="board.review.*" %>
<%@ page import="java.io.File" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

String loginId = (String) session.getAttribute("loginid");
if (loginId == null) {
    response.sendRedirect("../login/loginModal.jsp");
    return;
}

String uploadPath = application.getRealPath("/save");
File uploadDir = new File(uploadPath);
if (!uploadDir.exists()) uploadDir.mkdirs();

int maxSize = 10 * 1024 * 1024;

MultipartRequest multi = new MultipartRequest(
    request,
    uploadPath,
    maxSize,
    "UTF-8",
    new DefaultFileRenamePolicy()
);

String genre = multi.getParameter("genre");
String title = multi.getParameter("title");
String content = multi.getParameter("content");
String filename = multi.getFilesystemName("uploadFile");
boolean isSpoiler = "1".equals(multi.getParameter("is_spoiler"));

ReviewBoardDto dto = new ReviewBoardDto();
dto.setGenre_type(genre);
dto.setTitle(title);
dto.setContent(content);
dto.setId(loginId);
dto.setFilename(filename);
dto.setIs_spoiler_type(isSpoiler);

ReviewBoardDao dao = new ReviewBoardDao();
dao.insertBoard(dto);

response.sendRedirect("list.jsp");
%>
