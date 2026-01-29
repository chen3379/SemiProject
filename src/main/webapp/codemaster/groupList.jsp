<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//그룹코드 조회groupCode
	CodeDao dao=new CodeDao();

	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	//페이징에 필요한 변수들
	int totalCount=dao.getTotalCount(); //전체갯수
	int perPage=5; //한페이지에 보여질 글갯수
	int perBlock=5; //한블럭에 보여질 페이지갯수
	int startNum; //db에서 가져올 글의 시작번호
	int startPage; //각블럭당 보여질 시작페이지
	int endPage; ////각블럭당 보여질 끝페이지
	int currentPage; //현재페이지
	int totalPage; //총페이지

	//현재페이지 읽기,단 null일경우는 1로준다
	if(request.getParameter("currentPage")==null)
		  currentPage=1;
	else
		currentPage= Integer.parseInt(request.getParameter("currentPage")); 

	//총페이지구하기
		totalPage=totalCount/perPage+(totalCount%perPage==0?0:1); 

	//각블럭당 보여질 시작페이지
	startPage=(currentPage-1)/perBlock*perBlock+1;
	endPage=startPage+perBlock-1; 

	if(endPage>totalPage)
		  endPage=totalPage;

	//각페이지에서 보여질 시작번호
	startNum=(currentPage-1)*perPage;

	//페이지에서 보여질 글만 가져오기
	List<CodeDto> list=dao.getPagingList(startNum, perPage);
%>

<style>
    /* AJAX로 로드될 때 부모에 영향 주지 않도록 범위 한정 */
    #group-list-container {
        color: var(--text-white, #fff);
    }
    #group-list-container .table { 
        color: var(--text-white, #fff); 
        border-color: var(--border-glass, rgba(255,255,255,0.1)); 
    }
    #group-list-container .table-dark { --bs-table-bg: var(--bg-surface, #181818); }
    #group-list-container .btn-danger { background-color: var(--primary-red, #E50914); border-color: var(--primary-red, #E50914); }
    #group-list-container .btn-danger:hover { background-color: var(--primary-red-hover, #B20710); border-color: var(--primary-red-hover, #B20710); }
    #group-list-container .caption-top { color: var(--text-gray, #B3B3B3) !important; }
    
    /* 페이징 스타일 */
    #group-list-container .pagination .page-link { 
        background-color: var(--bg-surface, #181818); 
        color: var(--text-white, #fff); 
        border-color: var(--border-glass, rgba(255,255,255,0.1)); 
    }
    #group-list-container .pagination .page-item.active .page-link { 
        background-color: var(--primary-red, #E50914); 
        border-color: var(--primary-red, #E50914); 
    }
    #group-list-container .pagination .page-link:hover {
        background-color: rgba(255,255,255,0.1);
        color: var(--primary-red, #E50914);
    }
</style>

<div id="group-list-container" class="container-fluid mt-3">

 	<!-- 상단 버튼 -->
	<div class="row mb-3">
    	<div class="col text-end">
        	<button type="button" class="btn btn-danger ajax-inner-link"
                data-url="../codemaster/groupForm.jsp">
            	등록
        	</button>
    	</div>
	</div>

    <h5 class="fw-bold mb-3"><%=totalCount %>개의 그룹이 있습니다</h5>

   <!-- 테이블 -->
   <div class="table-responsive">
       <table class="table table-dark table-hover align-middle text-center">
            <caption class="caption-top fw-bold">공통코드 관리</caption>
 
        <thead class="table-light text-dark">
		<tr align="center">
		    <th width="150">그룹코드</th>
		    <th width="280">그룹명</th>
 		    <th width="150">사용여부</th>
 		    <th class="d-none d-md-table-cell">가입일</th>
            <th class="d-none d-md-table-cell">생성자</th>
		    <th width="250">처리</th>
		</tr>
        </thead>
        <tbody>
		<%
    	if(totalCount==0){%>
	  	  <tr>
	  	     <td colspan="6" class="py-4 text-muted">등록된 그룹이 없습니다</td>
	  	  </tr>
    <%	}else{
		
		for(CodeDto dto:list)
		{%>
		<tr align="center">
		
			<td>
    		    <a href="#" class="ajax-inner-link text-decoration-none fw-bold" 
                   data-url="../codemaster/codeList.jsp?groupCode=<%=dto.getGroup_code()%>"
                   style="color:var(--primary-red, #E50914)">
                   <%=dto.getGroup_code()%>
                </a>
			</td>
			<td><%=dto.getGroup_name() %></td>
			<td>
                <span class="badge <%= "Y".equals(dto.getUse_yn()) ? "bg-success" : "bg-secondary" %>">
                    <%= "Y".equals(dto.getUse_yn()) ? "사용" : "미사용" %>
                </span>
            </td>
			
			 <td class="d-none d-md-table-cell">
                        <%=sdf.format(dto.getCreate_day())%>
                    </td>
                    <td class="d-none d-md-table-cell">
                        <%=dto.getCreate_id()%>
                    </td>
			<td>
    	      	<div class="d-flex justify-content-center gap-2">
 					<button type="button" class="btn btn-sm btn-outline-info ajax-inner-link"
						data-url="../codemaster/groupUpdateForm.jsp?groupCode=<%=dto.getGroup_code() %>&currentPage=<%=currentPage%>">수정</button>
						
					<form action="../codemaster/groupDelete.jsp" method="post" class="ajax-del-form" style="display:inline;">
					    <input type="hidden" name="groupCode" value="<%=dto.getGroup_code()%>">
					    <input type="hidden" name="currentPage" value="<%=currentPage%>">
					    <button type="submit" class="btn btn-sm btn-outline-danger">삭제</button>
					</form>
				</div>					
			</td>
		</tr>
		<%}
	}
%>
        </tbody>
	</table>
	
	 <!-- 페이지네이션 -->
    <nav class="mt-3">
        <ul class="pagination justify-content-center flex-wrap">

            <% if (startPage > 1) { %>
                <li class="page-item">
                    <a class="page-link ajax-page-link"
                       href="#" data-page="<%=startPage-1%>">이전</a>
                </li>
            <% } %>

            <% for (int pp = startPage; pp <= endPage; pp++) { %>
                <li class="page-item <%=pp == currentPage ? "active" : ""%>">
                    <a class="page-link ajax-page-link"
                       href="#" data-page="<%=pp%>"><%=pp%></a>
                </li>
            <% } %>

            <% if (endPage < totalPage) { %>
                <li class="page-item">
                    <a class="page-link ajax-page-link"
                       href="#" data-page="<%=endPage+1%>">다음</a>
                </li>
            <% } %>

        </ul>
    </nav>
</div>

<script>
    $(document).ready(function() {
        var $contentArea = $('#content-area');

        // [1] 페이징 클릭 이벤트
        $('.ajax-page-link').on('click', function(e) {
            e.preventDefault();
            var page = $(this).data('page');
            var url = '../codemaster/groupList.jsp?currentPage=' + page;
            
            $contentArea.fadeOut(100, function() {
                $contentArea.load(url, function() {
                    $contentArea.fadeIn(100);
                });
            });
        });

        // [2] 페이지 내부 링크 (등록, 수정, 상세 등)
        $('.ajax-inner-link').on('click', function(e) {
            e.preventDefault();
            var url = $(this).data('url');
            $contentArea.fadeOut(100, function() {
                $contentArea.load(url, function() {
                    $contentArea.fadeIn(100);
                });
            });
        });

        // [3] 삭제 폼 처리
        $('.ajax-del-form').on('submit', function(e) {
            e.preventDefault();
            if(!confirm('정말 삭제하시겠습니까?')) return;
            
            var $form = $(this);
            $.ajax({
                type: 'POST',
                url: $form.attr('action'),
                data: $form.serialize(),
                success: function() {
                    // 삭제 후 현재 페이지 다시 로드
                    $contentArea.load('../codemaster/groupList.jsp?currentPage=<%=currentPage%>');
                }
            });
        });
    });
</script>

