<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="board.free.*" %>
<%@ page import="java.io.File" %>

<%
request.setCharacterEncoding("UTF-8");

/* ===== 로그인 체크 ===== */
String loginId = (String) session.getAttribute("loginid");
if (loginId == null) {
    response.sendRedirect(request.getContextPath() + "/login/login.jsp");
    return;
}

/* ===== 파일 업로드 설정 ===== */
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

/* ===== multipart 파라미터 ===== */
String category = multi.getParameter("category");
String title = multi.getParameter("title");
String content = multi.getParameter("content");
out.print("<pre>");
out.print("category = " + category + "\n");
out.print("title = " + title + "\n");
out.print("content = " + content + "\n");
out.print("</pre>");

String uploadFileName = multi.getFilesystemName("uploadFile");
/* ===== DTO ===== */
FreeBoardDto dto = new FreeBoardDto();
dto.setCategory_type(category);
dto.setTitle(title);
dto.setContent(content);
dto.setId(loginId);           
dto.setIs_spoiler_type(false);
dto.setFilename(uploadFileName);

FreeBoardDao dao = new FreeBoardDao();
dao.insertBoard(dto);

response.sendRedirect("list.jsp");
%>
