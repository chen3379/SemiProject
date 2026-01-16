<%@page import="movie.MovieReviewDto"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	
	int movieIdx = Integer.parseInt(request.getParameter("movie_idx"));
	
	MovieReviewDao dao = new MovieReviewDao();
	List<MovieReviewDto> list = dao.getAllReviewsWithScore(movieIdx);
	
	String id = (String)session.getAttribute("id");
	//test용 아래 코드 삭제필요
	if(id == null) id = "guest";
	
	//목록 없으면 아무것도 출력 안 함 
	if(list == null || list.size() == 0){
	  return;
	}
%>

<input type="hidden" id="movie_idx" value="<%=movieIdx%>">

<div class="list-group">
  <% for(MovieReviewDto r : list){ %>
    <div class="list-group-item">

      <div class="d-flex justify-content-between align-items-center">
        <div>
          <b><%=r.getId()%></b>

          <%
            double score = (r.getScore() == null) ? 0.0 : r.getScore().doubleValue();
            int full = (int)Math.floor(score);
            boolean half = (score - full) >= 0.5;
            int empty = 5 - full - (half ? 1 : 0);
          %>

          <span class="ms-1 align-middle" style="font-size:14px;">
            <% for(int i=0;i<full;i++){ %>
              <i class="bi bi-star-fill text-warning"></i>
            <% } %>

            <% if(half){ %>
              <i class="bi bi-star-half text-warning"></i>
            <% } %>

            <% for(int i=0;i<empty;i++){ %>
              <i class="bi bi-star text-warning"></i>
            <% } %>
          </span>
          
          <span class="ms-2 text-warning fw-semibold">
            <%=String.format("%.1f", score)%>
          </span>
        </div>

        <div class="d-flex align-items-center gap-2">
          <span class="text-muted small"><%=r.getCreateDay()%></span>

          <%-- 본인 글일 때만 버튼 출력 --%>
          <% if(id != null && id.equals(r.getId())) { %>
            <button type="button" class="btn btn-sm btn-outline-primary"
              onclick="updateReview(<%=r.getReviewIdx()%>, '<%=r.getContent().replace("'", "\\'")%>')">
              수정
            </button>

            <button type="button" class="btn btn-sm btn-outline-danger"
              onclick="deleteReview(<%=r.getReviewIdx()%>)">
              삭제
            </button>
          <% } %>
        </div>
      </div>

      <div class="mt-2"><%=r.getContent()%></div>
    </div>
  <% } %>
</div>
