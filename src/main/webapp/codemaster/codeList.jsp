<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String groupCode=request.getParameter("groupCode");
	String currentPage=request.getParameter("currentPage");

	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");

	//그룹코드 조회groupCode
	CodeDao dao=new CodeDao();
	List<CodeDto> groupList = dao.getGroupList();
	
	int totalCount = 0;
	
	CodeDto dtog = null;
	List<CodeDto> list = null;
	
	if(groupCode != null && !groupCode.equals("")){
	    dtog = dao.getGroup(groupCode);
	    list = dao.getCodeList(groupCode);
	    totalCount = list != null ? list.size() : 0;
	}
%>
<style>
    #code-list-container { color: var(--text-white, #fff); }
    #code-list-container .table { color: var(--text-white, #fff); border-color: var(--border-glass, rgba(255,255,255,0.1)); }
    #code-list-container .table-dark { --bs-table-bg: var(--bg-surface, #181818); }
    #code-list-container .form-select, #code-list-container .form-control { 
        background-color: var(--bg-surface, #181818); 
        border-color: var(--border-glass, rgba(255,255,255,0.1)); 
        color: var(--text-white, #fff); 
    }
    #code-list-container .btn-danger { background-color: var(--primary-red, #E50914); border-color: var(--primary-red, #E50914); }
    #code-list-container .caption-top { color: var(--text-gray, #B3B3B3) !important; }
</style>

<div id="code-list-container" class="container-fluid mt-3">
  <!-- 상단 버튼 -->
    <div class="row mb-3">
        <div class="col text-end">
            <button class="btn btn-danger me-2 ajax-inner-link"
                data-url="../codemaster/codeForm.jsp?groupCode=<%=groupCode%>">
                코드등록
            </button>
            <button class="btn btn-outline-light ajax-inner-link"
                data-url="../codemaster/groupList.jsp">
                그룹목록
            </button>
        </div>
    </div>

  <!-- 그룹 선택 -->
    <div class="row mb-3">
        <div class="col-md-4 col-12">
            <form id="group-select-form">
                <select name="groupCode" class="form-select" id="group-select">
                    <option value="">그룹을 선택하세요</option>
                    <% for (CodeDto g : groupList) {
                        String selected = g.getGroup_code().equals(groupCode) ? "selected" : "";
                    %>
                        <option value="<%=g.getGroup_code()%>" <%=selected%>>
                            <%=g.getGroup_code()%> [ <%=g.getGroup_name()%> ]
                        </option>
                    <% } %>
                </select>
            </form>
        </div>
    </div>
     <h5 class="fw-bold mb-3"><%=totalCount %>개의 코드가 있습니다</h5>
	<!-- 테이블 -->
	<div class="table-responsive">
	<table class="table table-dark table-hover align-middle text-center">
	  <caption class="caption-top fw-bold">
		그룹코드 :	<%= groupCode != null ? groupCode : "-" %>
		&nbsp;&nbsp;
		그룹명 :	[ <%= dtog != null ? dtog.getGroup_name() : "선택하세요" %> ]
	</caption>
		
	<thead class="table-light text-dark">
	<tr align="center">
	    <th>코드ID</th>
	    <th>코드명</th>
	    <th>표기</th>
	    <th>사용여부</th>
        <th>등록ID</th>
        <th>가입일</th>
        <th>수정ID</th>
        <th>수정일</th>
 		<th>처리</th>        
	</tr>
    </thead>
    <tbody>
<%
	if(groupCode == null || groupCode.equals("") || list == null){
		%>
		<tr>
		    <td colspan="9" class="py-4 text-muted">그룹을 선택하세요</td>
		</tr>
		<%
	}else if(totalCount == 0){
		%>
		<tr>
		    <td colspan="9" class="py-4 text-muted">등록된 코드가 없습니다</td>
		</tr>
	<%}else{
					
		for(CodeDto dto:list)
		{%>
			<tr align="center">
				<td><%=dto.getCode_id() %></td>
				<td><%=dto.getCode_name() %></td>
				<td><%=dto.getSort_order() %></td>
				<td>
                    <span class="badge <%= "Y".equals(dto.getUse_yn()) ? "bg-success" : "bg-secondary" %>">
                        <%= "Y".equals(dto.getUse_yn()) ? "사용" : "미사용" %>
                    </span>
                </td>
				<td><%=dto.getCreate_id() %></td>
				<td>
	        		<%= dto.getCreate_day() != null 
	            		? sdf.format(dto.getCreate_day()) : "-" %>
	    		</td>
				<td><%= dto.getUpdate_id() != null ? dto.getUpdate_id() : "-" %></td>
				<td>
	        		<%= dto.getUpdate_day() != null 
	            		? sdf.format(dto.getUpdate_day()) : "-" %>
	    		</td>
	    		
				<td>
                    <div class="d-flex justify-content-center gap-2">
                        <button type="button" class="btn btn-sm btn-outline-info ajax-inner-link"
                            data-url="../codemaster/codeUpdateForm.jsp?groupCode=<%=dto.getGroup_code()%>&codeId=<%=dto.getCode_id()%>">
                            수정
                        </button>
                        
                        <form action="../codemaster/codeDelete.jsp" method="post" class="ajax-del-form" style="display:inline;">
                            <input type="hidden" name="groupCode" value="<%=dto.getGroup_code()%>">
                            <input type="hidden" name="codeId" value="<%=dto.getCode_id()%>">
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
	</div>	
</div>

<script>
$(document).ready(function() {
    var $contentArea = $('#content-area');

    $('.ajax-inner-link').on('click', function(e) {
        e.preventDefault();
        var url = $(this).data('url');
        $contentArea.fadeOut(100, function() {
            $contentArea.load(url, function() {
                $contentArea.fadeIn(100);
            });
        });
    });

    $('#group-select').on('change', function() {
        var groupCode = $(this).val();
        var url = '../codemaster/codeList.jsp?groupCode=' + groupCode;
        $contentArea.load(url);
    });

    $('.ajax-del-form').on('submit', function(e) {
        e.preventDefault();
        if(!confirm('정말 삭제하시겠습니까?')) return;
        var $form = $(this);
        $.ajax({
            type: 'POST',
            url: $form.attr('action'),
            data: $form.serialize(),
            success: function() {
                $contentArea.load('../codemaster/codeList.jsp?groupCode=<%=groupCode%>');
            }
        });
    });
});
</script>



