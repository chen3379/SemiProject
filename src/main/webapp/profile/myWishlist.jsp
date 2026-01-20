<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.MovieDto" %>

<%-- 데이터 로드 액션 포함 --%>
<jsp:include page="myWishlistAction.jsp" />

<%
    // Action에서 전달된 데이터 추출
    List<MovieDto> wishList = (List<MovieDto>) request.getAttribute("wishList");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    String sortOrder = (String) request.getAttribute("sortOrder");

    if (totalCount == null) totalCount = 0;
    if (sortOrder == null) sortOrder = "latest";
%>

<style>
    /* [WHATFLIX My Wishlist Style] */
    .my-movies-section {
        animation: fadeInUp 0.6s var(--ease-smooth);
    }

    .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
        border-bottom: 1px solid var(--border-glass);
        padding-bottom: 15px;
    }

    .section-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--text-white);
        margin: 0;
    }

    .section-count {
        color: var(--primary-red);
        margin-left: 8px;
        font-size: 1.2rem;
    }

    /* 정렬 버튼 */
    .sort-buttons { display: flex; gap: 8px; }
    .sort-btn {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid var(--border-glass);
        color: var(--text-gray);
        padding: 6px 16px;
        border-radius: 20px;
        font-size: 0.85rem;
        transition: 0.2s;
        cursor: pointer;
    }
    .sort-btn.active {
        background-color: var(--primary-red) !important;
        border-color: var(--primary-red);
        color: white !important;
    }

    /* 그리드 시스템 */
    .movies-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 25px;
    }

    .movie-card {
        background: var(--bg-surface);
        border-radius: 12px;
        overflow: hidden;
        position: relative;
        transition: transform 0.3s ease;
        border: 1px solid var(--border-glass);
    }

    .movie-card:hover {
        transform: translateY(-8px);
        border-color: rgba(229, 9, 20, 0.5);
    }

    /* 찜 삭제 버튼 */
    .wish-remove-btn {
        position: absolute;
        top: 10px;
        right: 10px;
        z-index: 10;
        width: 32px;
        height: 32px;
        background: rgba(0, 0, 0, 0.7);
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
        cursor: pointer;
        transition: 0.2s;
        backdrop-filter: blur(4px);
    }

    .wish-remove-btn:hover {
        background: var(--primary-red);
        transform: scale(1.1);
    }

    .movie-poster-wrapper {
        width: 100%;
        aspect-ratio: 2/3;
        overflow: hidden;
        cursor: pointer;
    }

    .movie-poster {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: 0.3s;
    }

    .movie-info { padding: 15px; }

    .movie-title {
        font-size: 1rem;
        font-weight: 700;
        color: var(--text-white);
        margin-bottom: 8px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .movie-meta {
        display: flex;
        justify-content: space-between;
        font-size: 0.8rem;
        color: var(--text-muted);
    }

    .movie-genre {
        background: rgba(255,255,255,0.05);
        padding: 2px 6px;
        border-radius: 4px;
    }

    /* 빈 상태 */
    .empty-state {
        text-align: center;
        padding: 80px 0;
        border: 1px dashed var(--border-glass);
        border-radius: 12px;
    }
    .empty-icon { font-size: 3rem; margin-bottom: 10px; }
</style>

<div class="my-movies-section">
    <div class="section-header">
        <div>
            <h2 class="section-title">
                찜한 영화
                <span class="section-count"><%= totalCount %></span>
            </h2>
        </div>
        <div class="sort-buttons">
            <button class="sort-btn <%= "latest".equals(sortOrder) ? "active" : "" %>"
                    onclick="sortWishes('latest')">
                최신순
            </button>
            <button class="sort-btn <%= "oldest".equals(sortOrder) ? "active" : "" %>"
                    onclick="sortWishes('oldest')">
                오래된순
            </button>
        </div>
    </div>

    <% if (wishList != null && !wishList.isEmpty()) { %>
        <div class="movies-grid">
            <% 
                for (MovieDto movie : wishList) { 
                    // 포스터 경로 처리
                    String posterSrc = "../save/no_image.jpg";
                    if (movie.getPosterPath() != null && !movie.getPosterPath().isEmpty()) {
                        if (movie.getPosterPath().startsWith("http")) {
                            posterSrc = movie.getPosterPath();
                        } else {
                            posterSrc = "../save/" + movie.getPosterPath();
                        }
                    }
            %>
                <div class="movie-card">
                    <!-- 삭제 버튼 -->
                    <div class="wish-remove-btn" onclick="removeWish(event, <%= movie.getMovieIdx() %>)" title="찜 해제">
                        ✕
                    </div>
                    
                    <!-- 포스터 영역 -->
                    <div class="movie-poster-wrapper" onclick="goToDetail(<%= movie.getMovieIdx() %>)">
                        <img src="<%= posterSrc %>" alt="<%= movie.getTitle() %>" class="movie-poster"
                             onerror="this.src='../save/no_image.jpg'">
                    </div>

                    <!-- 정보 영역 -->
                    <div class="movie-info">
                        <h3 class="movie-title"><%= movie.getTitle() %></h3>
                        <div class="movie-meta">
                            <span class="movie-genre"><%= movie.getGenre() != null ? movie.getGenre() : "장르미상" %></span>
                            <span class="wish-date"><%= movie.getWishDay() %></span>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="empty-state">
            <div class="empty-icon">❤️</div>
            <p class="empty-text">찜한 영화가 없습니다. 마음에 드는 영화를 담아보세요!</p>
        </div>
    <% } %>
</div>

<script>
    /* 정렬 함수 */
    function sortWishes(sort) {
        $.ajax({
            type: "get",
            url: "myWishlist.jsp",
            data: { sort: sort },
            success: function(response) {
                $('#content-area').html(response);
            },
            error: function() {
                alert("목록을 불러오는 데 실패했습니다.");
            }
        });
    }

    /* 찜 삭제 함수 */
    function removeWish(event, movieIdx) {
        event.stopPropagation(); // 카드 클릭 상세 이동 방지

        if (confirm("찜 목록에서 삭제하시겠습니까?")) {
            $.ajax({
                type: "post",
                url: "../movie/movieWishDeleteAction.jsp",
                data: { movie_idx: movieIdx },
                dataType: "json",
                success: function(res) {
                    if (res.status === "OK") {
                        // 현재 정렬 상태 유지하며 리로드
                        sortWishes("<%= sortOrder %>");
                    } else {
                        alert(res.message || "삭제에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("서버와 통신 중 오류가 발생했습니다.");
                }
            });
        }
    }

    /* 상세 페이지 이동 */
    function goToDetail(movieIdx) {
        window.location.href = '../movie/movieDetail.jsp?movie_idx=' + movieIdx;
    }
</script>
