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

if(list == null || list.size() == 0){
  // 아무것도 없으면 movieDetail.js에서 "없음" 문구를 넣게 해놨으니 return 가능
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
          <%-- 점수까지 보여줄 거면(있으면) 예: <span class="text-warning ms-2">★ <%=r.getScore()%></span> --%>
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
