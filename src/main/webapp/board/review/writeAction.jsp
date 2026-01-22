<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="board.review.*" %>
<%@ page import="java.io.File" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

/* ===== 로그인 체크 ===== */
String loginId = (String) session.getAttribute("loginid");
if (loginId == null) {
    response.sendRedirect("../login/loginModal.jsp");
    return;
}

/* ===== 파일 업로드 설정 ===== */
String uploadPath = application.getRealPath("/save");
File uploadDir = new File(uploadPath);
if (!uploadDir.exists()) uploadDir.mkdirs();

int maxSize = 10 * 1024 * 1024;

/* ===== multipart 처리 ===== */
MultipartRequest multi = new MultipartRequest(
    request,
    uploadPath,
    maxSize,
    "UTF-8",
    new DefaultFileRenamePolicy()
);

/* ===== 파라미터 ===== */
String genre = multi.getParameter("genre");   // 영화 장르
String title = multi.getParameter("title");
String content = multi.getParameter("content");
String filename = multi.getFilesystemName("uploadFile");

/* ===== DTO ===== */
ReviewBoardDto dto = new ReviewBoardDto();
dto.setGenre_type(genre);
dto.setTitle(title);
dto.setContent(content);
dto.setId(loginId);
dto.setFilename(filename);

/* ===== DB 저장 ===== */
ReviewBoardDao dao = new ReviewBoardDao();
dao.insertBoard(dto);

/* ===== 이동 ===== */
response.sendRedirect("list.jsp");
%>
