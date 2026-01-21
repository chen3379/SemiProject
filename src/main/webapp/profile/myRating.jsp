<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.MovieDto" %>

<%-- 데이터 로드 액션 포함 --%>
<jsp:include page="myRatingAction.jsp" />

<%
    List<MovieDto> ratingList = (List<MovieDto>) request.getAttribute("ratingList");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    String sortOrder = (String) request.getAttribute("sortOrder");

    if (totalCount == null) totalCount = 0;
    if (sortOrder == null) sortOrder = "latest";
%>

<style>
    /* [WHATFLIX My Ratings - Wishlist 스타일 완전 동기화] */
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

    /* 정렬 버튼 - Wishlist와 동일 */
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

    /* 그리드 시스템 - Wishlist와 동일 (200px 기준) */
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
        cursor: pointer;
    }

    .movie-card:hover {
        transform: translateY(-8px);
        border-color: rgba(229, 9, 20, 0.5);
    }

    /* 포스터 영역 - Wishlist와 동일 (2:3 비율) */
    .movie-poster-wrapper {
        width: 100%;
        aspect-ratio: 2/3;
        overflow: hidden;
    }

    .movie-poster {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: 0.3s;
    }

    /* 정보 영역 */
    .movie-info { padding: 15px; }

    .movie-title {
        font-size: 1rem;
        font-weight: 700;
        color: var(--text-white);
        margin-bottom: 5px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    /* 평점 별점 (추가됨) */
    .rating-score {
        color: #FFD700;
        font-size: 0.9rem;
        font-weight: 700;
        margin-bottom: 8px;
    }

    /* 코멘트 (카드 크기를 해치지 않도록 짧게 제한) */
    .movie-comment {
        font-size: 0.8rem;
        color: var(--text-gray);
        background: rgba(255, 255, 255, 0.03);
        padding: 5px 8px;
        border-radius: 4px;
        margin-bottom: 10px;
        display: -webkit-box;
        -webkit-line-clamp: 1; /* Wishlist와 높이를 맞추기 위해 1줄로 제한 */
        line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .movie-meta {
        display: flex;
        justify-content: space-between;
        font-size: 0.75rem;
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
        grid-column: 1 / -1;
    }
    .empty-icon { font-size: 3rem; margin-bottom: 10px; }
</style>

<div class="my-movies-section">
    <div class="section-header" data-sort-order="<%= sortOrder %>">
        <h2 class="section-title">
            평가한 영화
            <span class="section-count"><%= totalCount %></span>
        </h2>
        <div class="sort-buttons">
            <button type="button" class="sort-btn <%= "latest".equals(sortOrder) ? "active" : "" %>"
                    data-sort="latest">최신순</button>
            <button type="button" class="sort-btn <%= "high".equals(sortOrder) ? "active" : "" %>"
                    data-sort="high">평점순</button>
        </div>
    </div>

    <% if (ratingList != null && !ratingList.isEmpty()) { %>
        <div class="movies-grid">
            <% 
                for (MovieDto movie : ratingList) { 
                    String posterSrc = "../save/no_image.jpg";
                    if (movie.getPosterPath() != null && !movie.getPosterPath().isEmpty()) {
                        posterSrc = movie.getPosterPath().startsWith("http") ? movie.getPosterPath() : "../save/" + movie.getPosterPath();
                    }
            %>
                <div class="movie-card js-movie-detail" data-movie-idx="<%= movie.getMovieIdx() %>">
                    <!-- 포스터 영역 (Wishlist와 비율 동일) -->
                    <div class="movie-poster-wrapper">
                        <img src="<%= posterSrc %>" alt="<%= movie.getTitle() %>" class="movie-poster"
                             onerror="this.src='../save/no_image.jpg'">
                    </div>

                    <!-- 정보 영역 -->
                    <div class="movie-info">
                        <h3 class="movie-title"><%= movie.getTitle() %></h3>
                        
                        <div class="rating-score">★ <%= movie.getMyScore() %></div>
                        
                        <div class="movie-comment">
                            <%= (movie.getMyComment() != null) ? movie.getMyComment() : "코멘트 없음" %>
                        </div>

                        <div class="movie-meta">
                            <span class="movie-genre"><%= movie.getGenre() != null ? movie.getGenre() : "장르미상" %></span>
                            <span class="rating-date"><%= movie.getRatingDay() %></span>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="empty-state">
            <div class="empty-icon">⭐</div>
            <p class="empty-text">아직 평가한 영화가 없습니다.</p>
        </div>
    <% } %>
</div>

<script>
    $(function() {
        /* 정렬 버튼 클릭 이벤트 */
        $('.sort-btn').on('click', function() {
            const sort = $(this).data('sort');
            sortRatings(sort);
        });

        /* 상세 페이지 이동 클릭 이벤트 */
        $('.js-movie-detail').on('click', function() {
            const movieIdx = $(this).data('movie-idx');
            goToDetail(movieIdx);
        });
    });

    function sortRatings(sort) {
        $.ajax({
            type: "get",
            url: "myRating.jsp",
            data: { sort: sort },
            success: function(response) {
                $('#content-area').html(response);
            }
        });
    }

    function goToDetail(movieIdx) {
        window.location.href = '../movie/movieDetail.jsp?movie_idx=' + movieIdx;
    }
</script>
