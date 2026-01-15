<%@page import="movie.TmdbApi"%>
<%@page import="movie.MovieDto"%>
<%@page import="movie.MovieDao"%>
<%@page import="movie.GeminiApi"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String msg = request.getParameter("msg"); // 사용자가 보낸 메시지

    if(msg != null && !msg.trim().isEmpty()) {
        
        // 1. Gemini에게 추천 영화 제목 리스트 받기 - 설정 프롬프트에 사용자 메세지 반영해서 요청
        GeminiApi ai = new GeminiApi();
        List<String> aiTitles = ai.getRecommendMovieTitles(msg);
        
        // 답변 시작 (AI 말풍선)
        %>
        <div class="chat-message ai-message">
            <div class="message-content">
                <strong>WhatFlix Bot:</strong><br>
                '<%=msg%>'에 어울리는 영화를 추천해드릴게요!
            </div>
        </div>
        <%

        // 제목으로 영화 정보 검색 (DB에 없으면 TMDB)
        if(aiTitles.size() > 0) {
            MovieDao dao = new MovieDao();
            TmdbApi tmdb = new TmdbApi();
            
            %>
            <div class="chat-message ai-message">
                <div class="movie-carousel" style="display:flex; overflow-x:auto; gap:10px; padding:5px 0;">
            <%
            // 추천받은 영화 제목 5개를 하나씩 꺼내는 반복문
            for(String title : aiTitles) {
                //DB에 있는지 검색
                MovieDto dto = dao.getMovieByTitle(title);
                //DB에 없으면
                if(dto == null) {
                    // TMDB 검색
                    List<MovieDto> searchRes = tmdb.searchMovie(title); 
                    
                    if(searchRes.size() > 0) {
                        //첫 번째 영화의 상세정보 끌어오기
                        String tmdbId = searchRes.get(0).getMovieId();
                        MovieDto fullInfo = tmdb.getMovieDetail(tmdbId);
                        
                        // DB에 저장 후, movie_idx 받아오기
                        int newIdx = dao.insertMovieApi(fullInfo);
                        
                        // 받아온 번호로 DTO 다시 세팅 (DB에 없었어도 바로 클릭 가능)
                        if(newIdx > 0) {
                            dto = fullInfo;
                            dto.setMovieIdx(newIdx); // 방금 받은 번호 세팅
                        }
                    }
                }
                
                if(dto != null) {
                    // 포스터 경로 처리
                    String poster = dto.getPosterPath();
                    if(poster == null || poster.isEmpty()) poster = "../save/no_image.jpg";
                    else if(!poster.startsWith("http")) poster = "../save/" + poster;
                    
                    // 영화 카드 HTML 출력
                    %>
                    <div class="movie-card-tiny" onclick="location.href='movieDetail.jsp?movie_idx=<%=dto.getMovieIdx()!=0 ? dto.getMovieIdx() : "" %>&tmdb_id=<%=dto.getMovieId()%>'" 
                         style="min-width:100px; cursor:pointer; text-align:center;">
                        <img src="<%=poster%>" style="width:100px; height:145px; border-radius:5px; object-fit:cover;">
                        <div style="font-size:11px; margin-top:5px; color:#333; font-weight:bold; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><%=dto.getTitle()%></div>
                    </div>
                    <%
                }
            }
            %>
                </div>
            </div>
            <%
        } else {
            // 추천 결과가 없을 때
            %>
            <div class="chat-message ai-message">
                <div class="message-content">
                    죄송해요, 적절한 영화를 찾지 못했어요. 😭 다시 질문해주시겠어요?
                </div>
            </div>
            <%
        }
    }
%>