<%@page import="codemaster.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	// groupCode, 현재페이지
	String groupCode = request.getParameter("groupCode");
	String currentPageStr = request.getParameter("currentPage");

	int currentPage = 1;
	
	if(currentPageStr != null && !currentPageStr.equals("")) {
	    currentPage = Integer.parseInt(currentPageStr);
	}
	
	CodeDao dao = new CodeDao();
	
	if (groupCode != null && !groupCode.equals("")) {
		//delete 메서드 호출
		dao.deleteGroup(groupCode); // DAO 삭제 메서드
		
		 // 삭제 후 전체 카운트
	    int totalCount = dao.getTotalCount();
	    int perPage = 5; // 한 페이지에 보여줄 글 수
	    int totalPage = totalCount / perPage + (totalCount % perPage == 0 ? 0 : 1);

	    // 현재 페이지가 총 페이지보다 크면 마지막 페이지로 조정
	    if(currentPage > totalPage) {
	        currentPage = totalPage;
	    }
	    if(currentPage < 1) currentPage = 1; // 1보다 작을 수 없음

	}
	
	response.sendRedirect("../codemaster/groupList.jsp?currentPage="+currentPage);
	

%>