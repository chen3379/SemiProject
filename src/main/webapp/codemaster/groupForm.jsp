<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//프로젝트의 경로
	String root=request.getContextPath();
%>
<style>
    #group-form-container { color: var(--text-white, #fff); }
    #group-form-container .table { color: var(--text-white, #fff); border-color: var(--border-glass, rgba(255,255,255,0.1)); }
    #group-form-container .table-dark { --bs-table-bg: var(--bg-surface, #181818); }
    #group-form-container .btn-danger { background-color: var(--primary-red, #E50914); border-color: var(--primary-red, #E50914); }
    #group-form-container .form-control { 
        background-color: var(--bg-surface, #181818); 
        border-color: var(--border-glass, rgba(255,255,255,0.1)); 
        color: var(--text-white, #fff); 
    }
</style>

<div id="group-form-container" class="container-fluid mt-4">
	<form id="group-add-form" action="../codemaster/groupAdd.jsp" method="post">
    <div class="card bg-dark border-secondary mx-auto" style="max-width: 600px;">
        <div class="card-header border-secondary">
            <h5 class="mb-0 text-white">그룹등록</h5>
        </div>
        <div class="card-body">
            <table class="table table-dark table-bordered align-middle"> 
                <tr>
                    <th width="120" class="table-light text-dark">그룹코드</th>
                    <td>
                        <input type="text" name="Groupcode" class="form-control" required>			
                    </td>
                </tr>	    
                <tr>
                    <th class="table-light text-dark">그룹명</th>
                    <td>
                        <input type="text" name="GroupName" class="form-control" required>			
                    </td>
                </tr>
                <tr>
                    <th class="table-light text-dark">사용여부</th>
                    <td>
                        <select name="useYn" class="form-control" required>
                            <option value="Y">사용</option>
                            <option value="N">미사용</option>
                        </select>
                    </td>
                </tr>	    
            </table>
            <div class="text-center mt-3 gap-2 d-flex justify-content-center">
                <button type="submit" class="btn btn-danger px-4">등록</button>
                <button type="reset" class="btn btn-outline-secondary px-4">초기화</button>
                <button type="button" class="btn btn-outline-light px-4 ajax-inner-link"
                    data-url="../codemaster/groupList.jsp">목록</button>
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

    $('#group-add-form').on('submit', function(e) {
        e.preventDefault();
        var $form = $(this);
        $.ajax({
            type: 'POST',
            url: $form.attr('action'),
            data: $form.serialize(),
            success: function() {
                alert('등록되었습니다.');
                $contentArea.load('../codemaster/groupList.jsp');
            }
        });
    });
});
</script>

