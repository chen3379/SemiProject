<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>main-mockup</title>

    </head>

    <body>
        <header>
            <nav>
                <div>
                    <h1>WHATFLIX</h1>
                    <ul>
                        <li><a href="main-mockup.jsp">홈</a></li>
                        <li><a href="movieList.jsp">영화</a></li>
                        <li><a href="community.jsp">커뮤니티</a></li>
                        <li><a href="support.jsp">지원</a></li>

                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="profile.jsp">프로필</a></li>
                    </ul>
                </div>
            </nav>
        </header>
        <main>
            <section id="movie-section">
                <section>
                    <div>
                        <h2>최상단 노출</h2>
                        <a href="movieDetail.jsp">더보기 ›</a>
                    </div>
                </section>
                <section>
                    <div>
                        <!-- 좋아요 기능 별점으로 변경하여 추천순-최신순 변경 건의 -->
                        <h2>최신순</h2>
                        <a href="movieDetail.jsp">더보기 ›</a>
                    </div>
                </section>
                <section>
                    <div>
                        <h2>조회순</h2>
                        <a href="movieDetail.jsp">더보기 ›</a>
                    </div>
                </section>
                <section>
                    <div>
                        <!-- 조회한 영화에서 담은 영화로 변경 건의 -->
                        <h2>당신이 담은 영화</h2>
                        <a href="movieDetail.jsp">더보기 ›</a>
                    </div>
                </section>
            </section>

            <section id="community-section">
                <!-- 커뮤니티는 수정 후 변경 부탁드립니다. -->
                <section>
                    <div>
                        <h2></h2>
                        <a href="">더보기 ›</a>
                    </div>
                </section>
            </section>
        </main>
        <footer>
            <!-- footer -->
        </footer>
    </body>

    </html>