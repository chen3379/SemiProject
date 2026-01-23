<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>

<%
response.setHeader("Cache-Control", "no-store");

String uploadPath = application.getRealPath("/save/editor");
File dir = new File(uploadPath);
if (!dir.exists()) dir.mkdirs();

MultipartRequest multi = new MultipartRequest(
    request,
    uploadPath,
    10 * 1024 * 1024,
    "UTF-8",
    new DefaultFileRenamePolicy()
);

String fileName = multi.getFilesystemName("image");

if (fileName == null) {
    out.print("{\"error\":\"NO_FILE\"}");
    return;
}

String contentType = multi.getContentType("image");
if (contentType == null || !contentType.startsWith("image/")) {
    out.print("{\"error\":\"INVALID_TYPE\"}");
    return;
}

String lower = fileName.toLowerCase();
if (!(lower.endsWith(".png") || lower.endsWith(".jpg") || lower.endsWith(".jpeg")
      || lower.endsWith(".gif") || lower.endsWith(".webp"))) {
    out.print("{\"error\":\"NOT_IMAGE\"}");
    return;
}

String safeFileName = java.net.URLEncoder.encode(fileName, "UTF-8")
    .replaceAll("\\+", "%20");

String imageUrl = request.getContextPath() + "/save/editor/" + safeFileName;
out.print("{\"url\":\"" + imageUrl + "\"}");
%>
