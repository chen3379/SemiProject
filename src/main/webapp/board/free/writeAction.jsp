<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="board.free.*" %>
<%@ page import="java.io.File" %>
<%
request.setCharacterEncoding("UTF-8");

String uploadPath = application.getRealPath("/save");

File uploadDir = new File(uploadPath);
if (!uploadDir.exists()) {
    uploadDir.mkdirs();
}
int maxSize = 10 * 1024 * 1024; // 10MB

MultipartRequest multi = new MultipartRequest(
    request,
    uploadPath,
    maxSize,
    "UTF-8",
    new DefaultFileRenamePolicy()
);

// ⭐ multipart에서는 이걸로 꺼내야 함
String category = multi.getParameter("category");
String title = multi.getParameter("title");
String content = multi.getParameter("content");

System.out.println("category=" + category);
System.out.println("title=" + title);
System.out.println("content=" + content);

FreeBoardDto dto = new FreeBoardDto();
dto.setCategory_type(category);
dto.setTitle(title);
dto.setContent(content);
dto.setId("guest");              // 임시
dto.setIs_spoiler_type(false);   // 기본값

FreeBoardDao dao = new FreeBoardDao();
dao.insertBoard(dto);

response.sendRedirect("list.jsp");
%>
