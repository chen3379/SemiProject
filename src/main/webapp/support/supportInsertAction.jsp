<%@page import="support.SupportDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

String id = (String)session.getAttribute("id");
String supportIdxStr = request.getParameter("supportIdx");
int supportIdx = Integer.parseInt(supportIdxStr);
String categoryType = request.getParameter("categoryType");
String title = request.getParameter("title");
String content = request.getParameter("content");
String secret = request.getParameter("secret");

if(categoryType == null || title == null || content == null ||
   title.trim().isEmpty() || content.trim().isEmpty()){
    out.print("{\"result\":\"FAIL\"}");
    return;
}

SupportDao dao = new SupportDao();

if(supportIdxStr == null || supportIdxStr.equals("")){
    // 등록
    dao.insertSupport(categoryType, title, content, id, secret);
    out.print("{\"result\":\"OK\"}");
    
} else {
    // 수정
    dao.updateSupport(supportIdx, title, content);
    out.print("{\"result\":\"OK\",\"supportIdx\":\"" + supportIdx + "\"}");
}
return;
%>