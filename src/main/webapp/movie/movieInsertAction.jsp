<%@ page language="java" contentType="text/plain; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="movie.MovieDao"%>
<%@ page import="movie.MovieDto"%>

<%
    // 1. 파일이 저장될 실제 경로 구하기 (webapp/save 폴더)
    String realPath = getServletContext().getRealPath("/save");
    // System.out.println(realPath); // 콘솔에서 경로 확인용

    // 2. 업로드 사이즈 제한 (10MB)
    int uploadSize = 1024 * 1024 * 10; 

    try {
        // ★ MultipartRequest 생성과 동시에 파일 업로드 완료됨
        MultipartRequest multi = new MultipartRequest(request, realPath, uploadSize,"UTF-8", new DefaultFileRenamePolicy());

        // 4. 데이터 받기 (주의: request가 아니라 multi로 받아야 함!)
        MovieDto dto = new MovieDto();
        
        dto.setMovieId(multi.getParameter("movie_id"));
        dto.setTitle(multi.getParameter("title"));
        dto.setReleaseDay(multi.getParameter("release_day"));
        dto.setGenre(multi.getParameter("genre"));
        dto.setCountry(multi.getParameter("country"));
        dto.setDirector(multi.getParameter("director"));
        dto.setCast(multi.getParameter("cast"));
        dto.setSummary(multi.getParameter("summary"));
        
        // 5. 파일명 처리
        // "poster_path"라는 이름으로 올라온 파일의 '저장된 실제 파일명'을 얻음
        String originalFileName = multi.getFilesystemName("poster_path");
        
        // 파일이 안 올라왔으면 null 처리 혹은 기본 이미지 설정
        if(originalFileName != null) {
            dto.setPosterPath(originalFileName); // DB에는 파일명만 저장
        } else {
            dto.setPosterPath("no-image.jpg"); // 이미지가 없을 경우 대비
        }
        
        dto.setTrailerUrl(multi.getParameter("trailer_url"));
        dto.setCreateId(multi.getParameter("create_id"));

        // 6. DB 저장
        MovieDao dao = new MovieDao();
        dao.insertMovie(dto);
        
        out.print("success");
        
    } catch (Exception e) {
        e.printStackTrace();
        // 에러 메시지를 보내서 alert로 띄워볼 수 있음
        out.print("fail: " + e.getMessage());
    }
%>