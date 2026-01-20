<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="movie.MovieDao, movie.MovieDto, java.util.List"%>
<%@ page import="member.MemberDto"%>
<%
    // 세션에서 로그인 정보 확인
    MemberDto member = (MemberDto) session.getAttribute("memberInfo");
    if (member == null) {
        out.print("GUEST");
        return;
    }

    // 정렬 옵션 가져오기 (기본값: 최신순)
    String sortOrder = request.getParameter("sort");
    if (sortOrder == null || (!"latest".equals(sortOrder) && !"oldest".equals(sortOrder))) {
        sortOrder = "latest";
    }

    MovieDao dao = new MovieDao();
    // 로그인한 사용자의 찜한 영화 리스트 조회
    List<MovieDto> wishList = dao.getMyWishList(member.getId(), sortOrder);

    // JSP 파일 내부에서 사용할 수 있도록 request 객체에 저장
    request.setAttribute("wishList", wishList);
    request.setAttribute("totalCount", wishList.size());
    request.setAttribute("sortOrder", sortOrder);
%>
