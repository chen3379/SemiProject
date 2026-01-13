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
        
        // PK (수정 조건)
        dto.setMovieIdx(Integer.parseInt(multi.getParameter("movie_idx")));
        
        // 일반 정보
        dto.setTitle(multi.getParameter("title"));
        dto.setReleaseDay(multi.getParameter("release_day"));
        dto.setGenre(multi.getParameter("genre"));
        dto.setCountry(multi.getParameter("country"));
        dto.setDirector(multi.getParameter("director"));
        dto.setCast(multi.getParameter("cast"));
        dto.setSummary(multi.getParameter("summary"));
        dto.setTrailerUrl(multi.getParameter("trailer_url"));
        dto.setUpdateId(multi.getParameter("update_id")); // 수정자

        // ★★★ 파일 처리 핵심 로직 ★★★
        String newFileName = multi.getFilesystemName("poster_path");
        String existingFileName = multi.getParameter("existing_poster");

        if (newFileName != null) {
            // 1. 새 파일이 업로드 됨 -> 새 파일명 사용
            dto.setPosterPath(newFileName);
            
            // (선택사항) 여기서 기존 파일(existingFileName)을 File 객체로 삭제해주는 코드를 넣으면 더 완벽함
        } else {
            // 2. 파일 업로드 안 함 -> 기존 파일명 그대로 유지
            dto.setPosterPath(existingFileName);
        }

        // DB 업데이트 실행
        MovieDao dao = new MovieDao();
        dao.updateMovie(dto); // 이 메서드가 DAO에 있어야 함

        out.print("success");

    } catch (Exception e) {
        e.printStackTrace();
        out.print("fail: " + e.getMessage());
    }
%>