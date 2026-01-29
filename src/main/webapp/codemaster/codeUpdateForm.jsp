<%@page import="codemaster.CodeDto"%>
<%@page import="codemaster.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String groupCode=request.getParameter("groupCode");
	String codeId=request.getParameter("codeId");
	String currentPage=request.getParameter("currentPage");

	CodeDao dao=new CodeDao();
	CodeDto dto=dao.getCode(groupCode, codeId);
%>
<style>
    #code-update-container { color: var(--text-white, #fff); }
    #code-update-container .table { color: var(--text-white, #fff); border-color: var(--border-glass, rgba(255,255,255,0.1)); }
    #code-update-container .table-dark { --bs-table-bg: var(--bg-surface, #181818); }
    #code-update-container .btn-danger { background-color: var(--primary-red, #E50914); border-color: var(--primary-red, #E50914); }
    #code-update-container .form-control, #code-update-container .form-select { 
        background-color: var(--bg-surface, #181818); 
        border-color: var(--border-glass, rgba(255,255,255,0.1)); 
        color: var(--text-white, #fff); 
    }
    #code-update-container .readonly-input { background-color: rgba(255,255,255,0.05) !important; color: var(--text-gray, #B3B3B3) !important; }
</style>

<div id="code-update-container" class="container-fluid mt-4">
    <form id="code-update-form" action="../codemaster/codeUpdateAction.jsp" method="post">
        <input type="hidden" name="currentPage" value="<%=currentPage%>">
        
        <div class="card bg-dark border-secondary mx-auto" style="max-width: 600px;">
            <div class="card-header border-secondary">
                <h5 class="mb-0 text-white">코드 수정</h5>
            </div>
            <div class="card-body">
                <table class="table table-dark table-bordered align-middle">
                    <tr>
                        <th width="120" class="table-light text-dark">그룹코드</th>
                        <td><input type="text" name="groupCode" value="<%=dto.getGroup_code()%>" readonly class="form-control readonly-input"></td>
                    </tr>
                    <tr>
                        <th class="table-light text-dark">그룹명</th>
                        <td><input type="text" name="groupName" value="<%=dto.getGroup_name()%>" readonly class="form-control readonly-input"></td>
                    </tr>
                    <tr>
                        <th class="table-light text-dark">코드ID</th>
                        <td><input type="text" name="codeId" value="<%=dto.getCode_id()%>" readonly class="form-control readonly-input"></td>
                    </tr>
                    <tr>
                        <th class="table-light text-dark">코드명</th>
                        <td><input type="text" name="codeName" value="<%=dto.getCode_name()%>" class="form-control" required></td>
                    </tr>
                    <tr>
                        <th class="table-light text-dark">표기순서</th>
                        <td><input type="number" name="sortOrder" value="<%=dto.getSort_order()%>" class="form-control" required></td>
                    </tr>
                    <tr>
                        <th class="table-light text-dark">사용여부</th>
                        <td>
                            <select name="useYn" class="form-select">
                                <option value="Y" <%= "Y".equals(dto.getUse_yn())?"selected":"" %>>사용</option>
                                <option value="N" <%= "N".equals(dto.getUse_yn())?"selected":"" %>>미사용</option>
                            </select>
                        </td>
                    </tr>
                </table>
                <div class="text-center mt-3 gap-2 d-flex justify-content-center">
                    <button type="submit" class="btn btn-danger px-4">수정</button>
                    <button type="button" class="btn btn-outline-light px-4 ajax-inner-link"
                        data-url="../codemaster/codeList.jsp?groupCode=<%=dto.getGroup_code()%>&currentPage=<%=currentPage%>">
                        목록
                    </button>
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

    $('#code-update-form').on('submit', function(e) {
        e.preventDefault();
        var $form = $(this);
        $.ajax({
            type: 'POST',
            url: $form.attr('action'),
            data: $form.serialize(),
            success: function() {
                alert('수정되었습니다.');
                $contentArea.load('../codemaster/codeList.jsp?groupCode=<%=dto.getGroup_code()%>&currentPage=<%=currentPage%>');
            }
        });
    });
});
</script>
