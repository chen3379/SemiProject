<%@page import="movie.MovieSearchDao"%>
<%@page import="movie.MovieDao"%>
<%@page import="movie.MovieDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    String currentPageStr = request.getParameter("currentPage");
    String searchWord = request.getParameter("searchWord");
    if (searchWord == null) searchWord = "";

    int currentPage = (currentPageStr != null && !currentPageStr.isEmpty()) ? Integer.parseInt(currentPageStr) : 1;

    MovieSearchDao dao = new MovieSearchDao();
    MovieDao mdao = new MovieDao();
    int perPage = 10; 
    int startNum = (currentPage - 1) * perPage;
    
    int totalCount = 0;
    List<MovieDto> list = null;

    if (searchWord.isEmpty()) {
        totalCount = mdao.getTotalCount(); // 전체 개수는 mdao에서 가져오는 것이 정확함
        list = mdao.getAllList(startNum, perPage); // 전체 리스트 메서드 호출
    } else {
        totalCount = dao.getTotalCountByTitle(searchWord); 
        list = dao.getSearchMoviesByTitle(searchWord, startNum, perPage);
    }
    
    int totalPage = (int)Math.ceil((double)totalCount / perPage);
    if (totalPage == 0) totalPage = 1;

    int perBlock = 5;
    int startPage = (currentPage - 1) / perBlock * perBlock + 1;
    int endPage = Math.min(startPage + perBlock - 1, totalPage);
%>

<style>
    .admin-movie-container { padding: 20px; color: #fff; }
    .search-wrapper { display: flex; gap: 10px; align-items: center; }
    .admin-search-box {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 4px; padding: 5px 15px; display: flex; align-items: center; width: 250px;
    }
    .admin-search-box input { background: none; border: none; color: #fff; outline: none; width: 100%; font-size: 0.9rem; }
    .btn-search { background: #444; border: none; color: #fff; padding: 6px 15px; border-radius: 4px; transition: 0.2s; cursor: pointer; }
    .btn-search:hover { background: #666; }
    .admin-table { width: 100%; margin-top: 20px; border-top: 2px solid #e50914; }
    .admin-table tr { border-bottom: 1px solid rgba(255, 255, 255, 0.1); }
    .admin-table td { padding: 12px 10px; vertical-align: middle; }
    .thumb-img { width: 45px; height: 65px; object-fit: cover; border-radius: 3px; background: #333; }
    .admin-pagination { display: flex; justify-content: center; gap: 5px; list-style: none; padding: 20px 0; }
    .admin-pagination .page-link {
        background: #1a1a1a; border: 1px solid #333; color: #999; padding: 8px 14px; border-radius: 4px; text-decoration: none; cursor: pointer;
    }
    .admin-pagination .page-item.active .page-link { background: #e50914; border-color: #e50914; color: #fff; font-weight: bold; }
    .admin-pagination .page-link.disabled { opacity: 0.3; cursor: default; }
    .admin-movie-row:hover { background: rgba(255, 255, 255, 0.05); }
</style>

<div class="admin-movie-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="m-0">영화 데이터 관리</h4>
        <div class="search-wrapper">
            <div class="admin-search-box">
                <input type="text" id="adminMovieSearch" placeholder="영화 제목 입력" value="<%=searchWord%>" onkeyup="if(window.event.keyCode==13){searchMovie()}">
            </div>
            <button type="button" class="btn-search" onclick="searchMovie()">검색</button>
            <button class="btn btn-danger btn-sm px-3" onclick="$('#content-area').load('adminMovieForm.jsp')">신규 등록</button>
        </div>
    </div>

    <table class="admin-table">
        <tbody>
            <%
            if (list == null || list.size() == 0) {
            %>
                <tr><td colspan="3" class="text-center py-5 text-muted">조회된 영화가 없습니다.</td></tr>
            <%
            } else {
                for (MovieDto dto : list) {
                    String poster = dto.getPosterPath();
                    String fullPath = (poster != null && !poster.isEmpty()) ? 
                                      (poster.startsWith("http") ? poster : "../save/" + poster) : "../save/no_image.jpg";
                    String year = (dto.getReleaseDay() != null && dto.getReleaseDay().length() >= 4) ? 
                                  dto.getReleaseDay().substring(0, 4) : "미정";
            %>
                <tr class="admin-movie-row">
                    <td style="width: 60px; cursor: pointer;" onclick="location.href='../movie/movieDetail.jsp?movie_idx=<%=dto.getMovieIdx()%>'">
                        <img src="<%=fullPath%>" class="thumb-img" onerror="this.src='../save/no_image.jpg'">
                    </td>
                    <td style="cursor: pointer;" onclick="location.href='../movie/movieDetail.jsp?movie_idx=<%=dto.getMovieIdx()%>'">
                        <div style="font-weight: 600; font-size: 1rem;"><%=dto.getTitle()%></div>
                        <div style="font-size: 0.85rem; color: #888;">
                            <%=year%> · <i class="bi bi-star-fill text-warning"></i> <%=String.format("%.1f", dto.getAvgScore())%>
                        </div>
                    </td>
                    <td class="text-end">
                        <button class="btn btn-outline-light btn-sm" onclick="location.href='../movie/movieUpdateForm.jsp?movie_idx=<%=dto.getMovieIdx()%>'">수정</button>
                        <button class="btn btn-outline-danger btn-sm ms-1" onclick="delMovie(<%=dto.getMovieIdx()%>)">삭제</button>
                    </td>
                </tr>
            <%
                } // for문 끝
            } // else문 끝
            %>
        </tbody>
    </table>

    <% if (totalCount > 0) { %>
    <ul class="admin-pagination">
        <li class="page-item">
            <a class="page-link <%=currentPage == 1 ? "disabled" : ""%>" onclick="<%=currentPage > 1 ? "moveAdminPage(" + (currentPage - 1) + ")" : ""%>">이전</a>
        </li>
        <% for (int pp = startPage; pp <= endPage; pp++) { %>
            <li class="page-item <%=pp == currentPage ? "active" : ""%>">
                <a class="page-link" onclick="moveAdminPage(<%=pp%>)"><%=pp%></a>
            </li>
        <% } %>
        <li class="page-item">
            <a class="page-link <%=currentPage == totalPage ? "disabled" : ""%>" onclick="<%=currentPage < totalPage ? "moveAdminPage(" + (currentPage + 1) + ")" : ""%>">다음</a>
        </li>
    </ul>
    <% } %>
</div>

<script>
    function searchMovie() {
        moveAdminPage(1, $('#adminMovieSearch').val());
    }

    function moveAdminPage(page, word) {
        if(word === undefined) word = $('#adminMovieSearch').val();
        let url = "adminMovieList.jsp?currentPage=" + page + "&searchWord=" + encodeURIComponent(word);
        $('#content-area').load(url);
    }

    function editMovie(idx) {
        $('#content-area').load("adminMovieEditForm.jsp?movie_idx=" + idx);
    }

    function deleteMovie(idx) {
        if(confirm("정말 삭제하시겠습니까?")) {
            $.post("adminMovieDeleteAction.jsp", { movie_idx: idx }, function() {
                alert("삭제되었습니다.");
                moveAdminPage(<%=currentPage%>);
            });
        }
    }
    function delMovie(idx) {
		if (confirm("정말 이 영화 정보를 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.")) {
			location.href = "../movie/movieDeleteAction.jsp?movie_idx=" + idx;
		}
	}
</script>
