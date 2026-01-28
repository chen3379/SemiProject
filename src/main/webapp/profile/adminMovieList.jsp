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
    :root {
        --primary-red: #E50914;
        --primary-red-hover: #B20710;
        --bg-surface: #1a1a1a;
        --border-color: rgba(255, 255, 255, 0.1);
        --text-gray: #B3B3B3;
    }

    .admin-movie-container { padding: 30px; color: #fff; background-color: #141414; border-radius: 8px; }
    .search-wrapper { display: flex; gap: 10px; align-items: center; }
    
    .admin-search-box {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 4px; padding: 7px 15px; display: flex; align-items: center; width: 250px;
        transition: border-color 0.2s;
    }
    .admin-search-box:focus-within { border-color: var(--primary-red); }
    .admin-search-box input { background: none; border: none; color: #fff; outline: none; width: 100%; font-size: 0.9rem; }
    
    .btn-search { 
        background: #333; border: 1px solid #444; color: #fff; padding: 7px 20px; border-radius: 4px; 
        transition: 0.2s; cursor: pointer; height: 38px; display: flex; align-items: center; justify-content: center;
    }
    .btn-search:hover { background: #444; border-color: #666; }

    .btn-admin-action {
        height: 38px;
        min-width: 120px;
        font-weight: 600;
        white-space: nowrap;
        border-radius: 4px;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0 15px;
        font-size: 0.85rem;
        transition: all 0.2s;
    }

    /* 통일된 색감의 버튼 스타일 */
    .btn-db-reg { background-color: var(--primary-red); border: none; color: #fff; }
    .btn-db-reg:hover { background-color: var(--primary-red-hover); transform: translateY(-1px); }
    
    .btn-api-sync { background-color: #333; border: 1px solid #555; color: #fff; }
    .btn-api-sync:hover { background-color: #444; border-color: #777; transform: translateY(-1px); }
    
    .btn-recent-reg { background-color: transparent; border: 1px solid var(--primary-red); color: var(--primary-red); }
    .btn-recent-reg:hover { background-color: rgba(229, 9, 20, 0.1); transform: translateY(-1px); }

    .admin-table { width: 100%; margin-top: 20px; border-collapse: separate; border-spacing: 0; }
    .admin-table thead th { border-bottom: 2px solid var(--primary-red); padding: 12px; color: var(--text-gray); font-weight: 600; text-transform: uppercase; font-size: 0.8rem; }
    .admin-table tr { border-bottom: 1px solid var(--border-color); transition: background 0.2s; }
    .admin-table td { padding: 15px 12px; vertical-align: middle; }
    .admin-movie-row:hover { background: rgba(255, 255, 255, 0.03); }

    .thumb-img { width: 50px; height: 75px; object-fit: cover; border-radius: 4px; background: #222; box-shadow: 0 4px 8px rgba(0,0,0,0.3); }
    
    .btn-row-action {
        width: 60px;
        height: 32px;
        font-size: 0.8rem;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 4px;
        transition: all 0.2s;
    }

    .admin-pagination { display: flex; justify-content: center; gap: 8px; list-style: none; padding: 30px 0; }
    .admin-pagination .page-link {
        background: #1a1a1a; border: 1px solid #333; color: #999; padding: 8px 16px; border-radius: 4px; text-decoration: none; cursor: pointer; transition: 0.2s;
    }
    .admin-pagination .page-link:hover:not(.disabled) { background: #333; color: #fff; border-color: #555; }
    .admin-pagination .page-item.active .page-link { background: var(--primary-red); border-color: var(--primary-red); color: #fff; font-weight: bold; }
    .admin-pagination .page-link.disabled { opacity: 0.3; cursor: default; }
</style>

<div class="admin-movie-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="m-0">영화 데이터 관리</h4>
        <div class="search-wrapper">
            <div class="admin-search-box">
                <input type="text" id="adminMovieSearch" placeholder="영화 제목 입력" value="<%=searchWord%>" onkeyup="if(window.event.keyCode==13){searchMovie()}">
            </div>
            <button type="button" class="btn-search" onclick="searchMovie()"><i class="bi bi-search"></i>&nbsp;검색</button>
            <button type="button" class="btn-admin-action btn-db-reg" onclick="$('#content-area').load('../movie/movieInsertForm.jsp')">DB 등록</button>
            <button type="button" class="btn-admin-action btn-api-sync" onclick="$('#content-area').load('../movie/movieApi.jsp')">API 연동</button>
            <button type="button" class="btn-admin-action btn-recent-reg" onclick="$('#content-area').load('../movie/movieAutoInsert.jsp')">최근 인기 영화 등록</button>
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
                        <button class="btn btn-outline-light btn-row-action" onclick="location.href='../movie/movieUpdateForm.jsp?movie_idx=<%=dto.getMovieIdx()%>'">수정</button>
                        <button class="btn btn-outline-danger btn-row-action ms-1" onclick="delMovie(<%=dto.getMovieIdx()%>)">삭제</button>
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

	function delMovie(idx) {
	  openCustomConfirm("정말 이 영화 정보를 삭제하시겠습니까?\n삭제 후에는 복구할 수 없습니다.", function(confirmed){
	    if(!confirmed) return;
	    location.href = "../movie/movieDeleteAction.jsp?movie_idx=" + encodeURIComponent(idx);
	  });
	}
</script>

<jsp:include page="../common/customConfirm.jsp" />
