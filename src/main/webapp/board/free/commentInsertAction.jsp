<%@page import="board.comment.FreeCommentDao"%>
<%@page import="board.comment.FreeCommentDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int board_idx = Integer.parseInt(request.getParameter("board_idx"));
String content = request.getParameter("content");
String loginId = (String) session.getAttribute("loginid");

int parent = request.getParameter("parent_comment_idx") == null
        ? 0
        : Integer.parseInt(request.getParameter("parent_comment_idx"));

FreeCommentDto dto = new FreeCommentDto();
dto.setBoard_idx(board_idx);
dto.setWriter_id(loginId);
dto.setContent(content);
dto.setParent_comment_idx(parent);
dto.setCreate_id(loginId);

FreeCommentDao dao = new FreeCommentDao();
dao.insertComment(dto);

response.sendRedirect("detail.jsp?board_idx=" + board_idx);
%>