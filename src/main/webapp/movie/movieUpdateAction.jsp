<%@page import="movie.MovieDto"%>
<%@page import="movie.MovieDao"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String realPath = getServletContext().getRealPath("/save");
    int uploadSize = 1024 * 1024 * 10; // 10MB
    String enc = "UTF-8";

    try {
        MultipartRequest multi = new MultipartRequest(request, realPath, uploadSize, enc, new DefaultFileRenamePolicy());

        MovieDto dto = new MovieDto();
        
        // 영화 고유번호 (수정 조건)
        dto.setMovieIdx(Integer.parseInt(multi.getParameter("movie_idx")));
        
        // 영화 세부정보
        dto.setTitle(multi.getParameter("title"));
        dto.setReleaseDay(multi.getParameter("release_day"));
        dto.setGenre(multi.getParameter("genre"));
        dto.setCountry(multi.getParameter("country"));
        dto.setDirector(multi.getParameter("director"));
        dto.setCast(multi.getParameter("cast"));
        dto.setSummary(multi.getParameter("summary"));
        dto.setTrailerUrl(multi.getParameter("trailer_url"));
        dto.setUpdateId(multi.getParameter("update_id")); // 수정자

        // 포스터 경로 처리 로직
        String newFileName = multi.getFilesystemName("poster_path");
        String existingFileName = multi.getParameter("existing_poster");

        if (newFileName != null) {
            // 새로운 파일이 업로드 됨 -> 새 파일명 사용
            dto.setPosterPath(newFileName);
            
        } else {
            // 파일 업로드 안 함 -> 기존 파일명 그대로 유지
            dto.setPosterPath(existingFileName);
        }

        // DB 업데이트 실행
        MovieDao dao = new MovieDao();
        dao.updateMovie(dto);

        out.print("success");

    } catch (Exception e) {
        e.printStackTrace();
        out.print("fail: " + e.getMessage());
    }
%>