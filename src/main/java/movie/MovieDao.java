package movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

//영화 정보에 대한 DAO
public class MovieDao {

    DBConnect db = new DBConnect();

    // Local 영화 등록(insert) - cast ` 백틱으로 감싸야 함(예약어)
    public void insertMovie(MovieDto dto) {

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "insert into movie (movie_id,title,release_day, genre,country,director,`cast`,summary,poster_path, trailer_url,create_id) VALUES(?,?,?,?,?,?,?,?,?,?,?)";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getMovieId());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getReleaseDay());
            pstmt.setString(4, dto.getGenre());
            pstmt.setString(5, dto.getCountry());
            pstmt.setString(6, dto.getDirector());
            pstmt.setString(7, dto.getCast());
            pstmt.setString(8, dto.getSummary());
            pstmt.setString(9, dto.getPosterPath());
            pstmt.setString(10, dto.getTrailerUrl());
            pstmt.setString(11, dto.getCreateId());
            pstmt.execute();

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }

    }

    // API 영화 등록(insert) - cast ` 백틱으로 감싸야 함(예약어)
    // Gemini를 통해 영화를 추천받을 때 해당 영화가 DB에 없으면 자동 등록할 때 쓰이는 insert
    public int insertMovieApi(MovieDto dto) {
        int generatedKey = 0; // return할 movie_idx

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "INSERT INTO movie (movie_id, title, release_day, genre, country, director, `cast`, summary, poster_path, trailer_url, create_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            // pstmt에 sql문과 함께 generatedkey(movie_idx)를 넘겨준다
            pstmt = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);

            pstmt.setString(1, dto.getMovieId()); // TMDB ID
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getReleaseDay());
            pstmt.setString(4, dto.getGenre());
            pstmt.setString(5, dto.getCountry());
            pstmt.setString(6, dto.getDirector());
            pstmt.setString(7, dto.getCast());
            pstmt.setString(8, dto.getSummary());

            // 포스터 경로 처리: 전체 URL이 들어오면 저장, 아니면 빈 값
            String poster = dto.getPosterPath();
            if (poster == null)
                poster = "";
            pstmt.setString(9, poster);

            pstmt.setString(10, dto.getTrailerUrl());

            // create_id는 'WhatFlix AI bot'으로 지정 <- gemini 자동 등록 영화
            pstmt.setString(11, "WhatFlix AI bot");

            pstmt.executeUpdate();

            // 방금 생성된 Auto Increment 키(movie_idx) 가져오기
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                generatedKey = rs.getInt(1); // 첫 번째 컬럼(PK) 반환
            }
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return generatedKey; // 생성된 movie_idx return (실패시 0)
    }

    // 전체 영화 개수 구하기 (페이징 처리용)
    public int getTotalCount() {
        int totalCount = 0;
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT COUNT(*) FROM movie";

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return totalCount;
    }

    // 장르별갯수(페이징 처리용)
    public int getTotalCountByGenre(String genre) {
        int total = 0;

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select count(*) from movie where genre=?";

        try {
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, genre);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                total = rs.getInt(1);
            }

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return total;
    }

    // 영화 list-전체
    public List<MovieDto> getAllList(int startNum, int perPage) {
        List<MovieDto> list = new ArrayList<MovieDto>();

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select * from movie m order by m.movie_idx desc limit ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, startNum);
            pstmt.setInt(2, perPage);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();

                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));

                list.add(dto);
            }

        } catch (SQLException e) { // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return list;
    }

    // 영화 list-평점 높은순(전체)
    public List<MovieDto> getRatingList(int startNum, int perPage) {
        List<MovieDto> list = new ArrayList<MovieDto>();

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select m.*, ifnull(s.avg_rating,0) as avg_rating, ifnull(s.count_rating,0) as count_rating from movie m "
                + "left join movie_rating_stat s on m.movie_idx=s.movie_idx "
                + "order by ifnull(s.avg_rating,0) desc, ifnull(s.count_rating,0) desc, m.movie_idx desc "
                + "limit ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, startNum);
            pstmt.setInt(2, perPage);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();

                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));

                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return list;
    }

    // 영화 list-평점 높은순(장르별)
    public List<MovieDto> getRatingListByGenre(String genre, int startNum, int perPage) {
        List<MovieDto> list = new ArrayList<MovieDto>();

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select m.*, ifnull(s.avg_rating,0) as avg_rating, ifnull(s.count_rating,0) as count_rating from movie m "
                + "left join movie_rating_stat s on m.movie_idx=s.movie_idx " + "where m.genre=? "
                + "order by ifnull(s.avg_rating,0) desc, ifnull(s.count_rating,0) desc, m.movie_idx desc "
                + "limit ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, genre);
            pstmt.setInt(2, startNum);
            pstmt.setInt(3, perPage);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();

                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));

                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }

        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return list;
    }

    // 영화 list-개봉순(전체)
    public List<MovieDto> getReleaseDayList(int startNum, int perPage) {
        List<MovieDto> list = new ArrayList<MovieDto>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // [수정 1] SQL에 평점 계산 로직(서브쿼리) 추가
        String sql = "SELECT m.*, "
                + " (SELECT IFNULL(AVG(score), 0) FROM movie_rating r WHERE r.movie_idx = m.movie_idx) as avg_rating "
                + " FROM movie m " + " ORDER BY m.release_day DESC, m.movie_idx DESC LIMIT ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, startNum);
            pstmt.setInt(2, perPage);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();
                // ... 기존 컬럼 세팅 (그대로 두세요) ...
                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));

                // [수정 2] 계산된 평점을 DTO에 담기 (이 한 줄이 핵심!)
                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 영화 list-개봉순(장르별)
    public List<MovieDto> getReleaseDayListByGenre(String genre, int startNum, int perPage) {
        List<MovieDto> list = new ArrayList<MovieDto>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // [수정 1] SQL 변경
        String sql = "SELECT m.*, "
                + " (SELECT IFNULL(AVG(score), 0) FROM movie_rating r WHERE r.movie_idx = m.movie_idx) as avg_rating "
                + " FROM movie m " + " WHERE genre=? " + " ORDER BY m.release_day DESC, m.movie_idx DESC LIMIT ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, genre);
            pstmt.setInt(2, startNum);
            pstmt.setInt(3, perPage);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();
                // 기존 세팅 생략 (위와 동일하게 유지)
                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));

                // [수정 2] 평점 추가
                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 영화 list-최신등록순(전체)
    public List<MovieDto> getCreateDayList(int startNum, int perPage) {
        List<MovieDto> list = new ArrayList<MovieDto>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // [수정 1] SQL 변경
        String sql = "SELECT m.*, "
                + " (SELECT IFNULL(AVG(score), 0) FROM movie_rating r WHERE r.movie_idx = m.movie_idx) as avg_rating "
                + " FROM movie m " + " ORDER BY m.create_day DESC, m.movie_idx DESC LIMIT ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, startNum);
            pstmt.setInt(2, perPage);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();
                // ... 기존 세팅 ...
                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));

                // [수정 2] 평점 추가
                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 영화 list-최신등록순(장르별)
    public List<MovieDto> getCreateDayListByGenre(String genre, int startNum, int perPage) {
        List<MovieDto> list = new ArrayList<MovieDto>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // [수정 1] SQL 변경
        String sql = "SELECT m.*, "
                + " (SELECT IFNULL(AVG(score), 0) FROM movie_rating r WHERE r.movie_idx = m.movie_idx) as avg_rating "
                + " FROM movie m " + " WHERE genre=? " + " ORDER BY m.create_day DESC, m.movie_idx DESC LIMIT ?, ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, genre);
            pstmt.setInt(2, startNum);
            pstmt.setInt(3, perPage);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();
                // ... 기존 세팅 ...
                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));

                // [수정 2] 평점 추가
                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 영화 list-인기순(조회수순)
    public List<MovieDto> getPopularList(int limit) {
        List<MovieDto> list = new ArrayList<MovieDto>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.* FROM movie m ORDER BY  m.readcount DESC, m.release_day DESC LIMIT ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();

                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));
                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 영화 list-새로 올라온 작품(개봉일순)
    public List<MovieDto> getNewList(int limit) {
        List<MovieDto> list = new ArrayList<MovieDto>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.* FROM movie m ORDER BY m.release_day DESC LIMIT ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();

                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));
                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 영화 list-새로 등록한 작품(등록일순)
    public List<MovieDto> getNewUpdateList(int limit) {
        List<MovieDto> list = new ArrayList<MovieDto>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT m.* FROM movie m ORDER BY m.create_day DESC LIMIT ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MovieDto dto = new MovieDto();

                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));
                dto.setAvgScore(rs.getDouble("avg_rating"));

                list.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // 영화 상세 조회 (Select - 1개)
    // 수정 폼이나 상세 페이지에서 사용
    public MovieDto getMovie(String movieIdx) {
        MovieDto dto = new MovieDto();

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM movie WHERE movie_idx = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, movieIdx);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setMovieId(rs.getString("movie_id"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setCreateId(rs.getString("create_id"));
                dto.setUpdateId(rs.getString("update_id"));
                dto.setReadcount(rs.getInt("readcount"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return dto;
    }

    // 영화 수정 (Update)
    public void updateMovie(MovieDto dto) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        // 수정일(update_day)을 현재 시간(now())으로 업데이트
        String sql = "UPDATE movie SET title=?, release_day=?, genre=?, country=?, director=?, `cast`=?, summary=?, poster_path=?, trailer_url=?, update_day=now(), update_id=? WHERE movie_idx=?";

        try {
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getReleaseDay());
            pstmt.setString(3, dto.getGenre());
            pstmt.setString(4, dto.getCountry());
            pstmt.setString(5, dto.getDirector());
            pstmt.setString(6, dto.getCast());
            pstmt.setString(7, dto.getSummary());
            pstmt.setString(8, dto.getPosterPath());
            pstmt.setString(9, dto.getTrailerUrl());
            pstmt.setString(10, dto.getUpdateId()); // 수정자 ID
            pstmt.setInt(11, dto.getMovieIdx()); // 기준이 되는 PK

            pstmt.execute();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 영화 삭제 (Delete)
    public void deleteMovie(String movieIdx) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "DELETE FROM movie WHERE movie_idx=?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, movieIdx);
            pstmt.execute();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 조회수 1 증가 메서드
    public void updateReadCount(String movieIdx) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "UPDATE movie SET readcount = readcount + 1 WHERE movie_idx = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, movieIdx);
            pstmt.execute();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 영화 중복 체크 메서드 (movie_id 기준 있으면 true, 없으면 false 반환)
    public boolean isMovieExist(String movieId) {
        boolean isExist = false;
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // count(*)가 1이면 존재하는 것
        String sql = "SELECT count(*) FROM movie WHERE movie_id = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, movieId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                if (rs.getInt(1) > 0)
                    isExist = true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return isExist;
    }

    // 제목으로 영화 찾기 bot에서 사용 (정확히 일치하거나 포함되는 것) - Gemini 에서 제목을 받아오면 DB에서 제목 검색
    public MovieDto getMovieByTitle(String title) {
        MovieDto dto = null;
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 제목이 비슷하면 가져오도록 like 검색
        String sql = "SELECT * FROM movie WHERE title LIKE ? LIMIT 1";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + title + "%");
            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new MovieDto();
                dto.setMovieIdx(rs.getInt("movie_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setReleaseDay(rs.getString("release_day"));
                dto.setGenre(rs.getString("genre"));
                dto.setCountry(rs.getString("country"));
                dto.setDirector(rs.getString("director"));
                dto.setCast(rs.getString("cast"));
                dto.setSummary(rs.getString("summary"));
                dto.setPosterPath(rs.getString("poster_path"));
                dto.setTrailerUrl(rs.getString("trailer_url"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setReadcount(rs.getInt("readcount"));

            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return dto;
    }
}
