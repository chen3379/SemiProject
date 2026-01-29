<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String groupCode=request.getParameter("groupCode");
	String currentPage=request.getParameter("currentPage");

	//그룹명 조회
	CodeDao dao=new CodeDao();
	CodeDto dto=dao.getGroup(groupCode);
%>
<style>
    #code-form-container { color: var(--text-white, #fff); }
    #code-form-container .table { color: var(--text-white, #fff); border-color: var(--border-glass, rgba(255,255,255,0.1)); }
    #code-form-container .table-dark { --bs-table-bg: var(--bg-surface, #181818); }
    #code-form-container .btn-danger { background-color: var(--primary-red, #E50914); border-color: var(--primary-red, #E50914); }
    #code-form-container .form-control, #code-form-container .form-select { 
        background-color: var(--bg-surface, #181818); 
        border-color: var(--border-glass, rgba(255,255,255,0.1)); 
        color: var(--text-white, #fff); 
    }
    #code-form-container .readonly-input { background-color: rgba(255,255,255,0.05) !important; color: var(--text-gray, #B3B3B3) !important; }
</style>

<div id="code-form-container" class="container-fluid mt-4">
	<form id="code-add-form" action="../codemaster/codeAction.jsp" method="post">
    <div class="card bg-dark border-secondary mx-auto" style="max-width: 600px;">
        <div class="card-header border-secondary">
            <h5 class="mb-0 text-white">코드 등록</h5>
        </div>
        <div class="card-body">
            <table class="table table-dark table-bordered align-middle">
                <tr>
                    <th width="120" class="table-light text-dark">그룹코드</th>
                    <td>
                        <input type="text" name="groupCode"  
                        value="<%=groupCode%>"
                        readonly class="form-control readonly-input">
                    </td>
                </tr>	    
                <tr>
                    <th class="table-light text-dark">그룹명</th>
                    <td>
                        <input type="text" name="groupName"  
                        value="<%=dto.getGroup_name() %>"
                        readonly class="form-control readonly-input">		
                    </td>
                </tr>
                <tr>
                    <th class="table-light text-dark">코드ID</th>
                    <td>
                        <input type="text" name="codeId"  class="form-control" required>			
                    </td>
                </tr>
                <tr>
                    <th class="table-light text-dark">코드명</th>
                    <td>
                        <input type="text" name="codeName"  class="form-control" required>			
                    </td>
                </tr>
                <tr>
                    <th class="table-light text-dark">표기순서</th>
                    <td>
                        <input type="number" name="sortOrder" class="form-control"
                           required min="1" max="10" step="1">
                    </td>
                </tr>	
                <tr>
                    <th class="table-light text-dark">사용여부</th>
                    <td>
                        <select name="useYn" class="form-select" required>
                            <option value="Y">사용</option>
                            <option value="N">미사용</option>
                        </select>
                    </td>
                </tr>		
            </table>
            <div class="text-center mt-3 gap-2 d-flex justify-content-center">
                <button type="submit" class="btn btn-danger px-4">코드등록</button>
                <button type="reset" class="btn btn-outline-secondary px-4">초기화</button>
                <button type="button" class="btn btn-outline-light px-4 ajax-inner-link"
                    data-url="../codemaster/codeList.jsp?groupCode=<%=groupCode%>">목록</button>
            </div>
        </div>
    </div>
	</form>
</div>

<script>
$(document).ready(function() {
    var $contentArea = $('#content-area');

    $('.ajax-inner-link').on('click', function(e) {
        e.preventDefault();
        var url = $(this).data('url');
        $contentArea.load(url);
    });

    $('#code-add-form').on('submit', function(e) {
        e.preventDefault();
        var $form = $(this);
        $.ajax({
            type: 'POST',
            url: $form.attr('action'),
            data: $form.serialize(),
            success: function() {
                alert('등록되었습니다.');
                $contentArea.load('../codemaster/codeList.jsp?groupCode=<%=groupCode%>');
            }
        });
    });
});
</script>
