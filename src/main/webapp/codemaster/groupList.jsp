<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gamja+Flower&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>List title here</title>
</head>
<%
	//그룹코드 조회groupCode
	CodeDao dao=new CodeDao();

	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	//페이징에 필요한 변수들
	int totalCount=dao.getTotalCount(); //전체갯수
	int perPage=5; //한페이지에 보여질 글갯수
	int perBlock=5; //한블럭에 보여질 페이지갯수
	int startNum; //db에서 가져올 글의 시작번호(mysql이므로 첫글이 0,오라클은 1)
	int startPage; //각블럭당 보여질 시작페이지
	int endPage; ////각블럭당 보여질 끝페이지
	int currentPage; //현재페이지
	int totalPage; //총페이지

	int no; //각페이지당 출력할 시작번호

	//현재페이지 읽기,단 null일경우는 1로준다
	if(request.getParameter("currentPage")==null)
		  currentPage=1;
	else
		currentPage= Integer.parseInt(request.getParameter("currentPage")); 

	//총페이지구하기
	//총페이지갯수/한페이지에 보여질 갯수로 나눔(7/5=1)
	//나머지가 1이라도 있으면 무조건 1페이지 추가(1+1=2페이지 필요)
		totalPage=totalCount/perPage+(totalCount%perPage==0?0:1); 

	//각블럭당 보여질 시작페이지
	//perBlock=5일경우 현재페이지 1~5일경우는 시작페이지1,끝5
	//만약 현재페이지가 13 시작:11  끝:15
	startPage=(currentPage-1)/perBlock*perBlock+1;
	endPage=startPage+perBlock-1; 

	//총페이지갯수가 23일경우 마지막 25가 아니라 23
	if(endPage>totalPage)
		  endPage=totalPage;

	//각페이지에서 보여질 시작번호(5개의 글을 한페이지)
	//예: 1페이지->0  2페이지: 5  3페이지:10.. 
	startNum=(currentPage-1)*perPage;

	no=totalCount-(currentPage-1)*perPage;

	//페이지에서 보여질 글만 가져오기
	List<CodeDto> list=dao.getPagingList(startNum, perPage);
	
%>
<body>

<div class="container-fluid mt-3">

 	<!-- 상단 버튼 -->
	<div class="row mb-3">
    	<div class="col text-end">
        	<button type="button" class="btn btn-warning"
                onclick="location.href='../codemaster/groupForm.jsp'">
            	등록
        	</button>
    	</div>
	</div>

    <h5 class="fw-bold"><%=totalCount %>개의 그룹이 있습니다</h5>

   <!-- 테이블 -->
   <div class="table-responsive">
       <table class="table table-bordered align-middle text-center">
            <caption class="caption-top fw-bold">공통코드 관리</caption>
 
		<tr class="table-secondary" align="center">
		    <th width="150">그룹코드</th>
		    <th width="280">그룹명</th>
 		    <th width="150">사용여부</th>
 		    <th class="d-none d-md-table-cell">가입일</th>
            <th class="d-none d-md-table-cell">생성자</th>
		    <th width="250">처리</th>
		</tr>
		<%
    	if(totalCount==0){%>
	  	  <tr>
	  	     <td colspan="6"><b>등록된 그룹이 없습니다</b></td>
	  	  </tr>
    <%	}else{
		
		for(CodeDto dto:list)
		{%>
		<tr align="center">
		
			<td>
    		    <a href="../codemaster/codeList.jsp?groupCode=<%=dto.getGroup_code()%>"><%=dto.getGroup_code()%></a>
			</td>
			<td><%=dto.getGroup_name() %></td>
			<td><%=dto.getUse_yn() %></td>
			
			 <td class="d-none d-md-table-cell">
                        <%=sdf.format(dto.getCreate_day())%>
                    </td>
                    <td class="d-none d-md-table-cell">
                        <%=dto.getCreate_id()%>
                    </td>
			<%-- <td><%=sdf.format(dto.getCreate_day()) %></td>
			<td><%=dto.getCreate_id() %></td>
			 --%>
			<td>
    	      	<div style="float: center;">
 					<button type="button" class="btn btn-outline-info"
						onclick="location.href='../codemaster/groupUpdateForm.jsp?groupCode=<%=dto.getGroup_code() %>&currentPage=<%=currentPage%>'">수정</button>&nbsp;&nbsp;
						
					<form action="../codemaster/groupDelete.jsp" method="post" style="display:inline;"
					      onsubmit="return confirm('정말 삭제하시겠습니까?');">
					    <input type="hidden" name="groupCode" value="<%=dto.getGroup_code()%>">
					    <input type="hidden" name="currentPage" value="<%=currentPage%>">
					    <button type="submit" class="btn btn-danger">삭제</button>
					</form>
				</div>					
			</td>
		</tr>
		<%}
	}
%>
	</table>
	
	 <!-- 페이지네이션 -->
    <nav class="mt-3">
        <ul class="pagination justify-content-center flex-wrap">

            <% if (startPage > 1) { %>
                <li class="page-item">
                    <a class="page-link"
                       href="../codemaster/groupList.jsp?currentPage=<%=startPage-1%>">이전</a>
                </li>
            <% } %>

            <% for (int pp = startPage; pp <= endPage; pp++) { %>
                <li class="page-item <%=pp == currentPage ? "active" : ""%>">
                    <a class="page-link"
                       href="../codemaster/groupList.jsp?currentPage=<%=pp%>"><%=pp%></a>
                </li>
            <% } %>

            <% if (endPage < totalPage) { %>
                <li class="page-item">
                    <a class="page-link"
                       href="../codemaster/groupList.jsp?currentPage=<%=endPage+1%>">다음</a>
                </li>
            <% } %>

        </ul>
    </nav>
    
</div>

</body>
</html>