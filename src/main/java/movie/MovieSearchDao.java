package movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class MovieSearchDao {
    // 검색된 영화 총 개수 구하기 (관리자 검색용)
    DBConnect db = new DBConnect();
public int getTotalCountByTitle(String searchWord) {
    int totalCount = 0;
    Connection conn = db.getDBConnect();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String sql = "SELECT COUNT(*) FROM movie WHERE title LIKE ?";

    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + searchWord + "%");
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

public List<MovieDto> getSearchMoviesByTitle(String searchWord, int startNum, int perPage) {
    List<MovieDto> list = new ArrayList<MovieDto>();
    Connection conn = db.getDBConnect();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // 제목 검색 + 평점 정보 조인
    String sql = "SELECT m.*, IFNULL(s.avg_rating, 0) AS avg_rating "
               + "FROM movie m "
               + "LEFT JOIN movie_rating_stat s ON m.movie_idx = s.movie_idx "
               + "WHERE m.title LIKE ? "
               + "ORDER BY m.movie_idx DESC "
               + "LIMIT ?, ?";

    try {
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + searchWord + "%");
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
            dto.setReadcount(rs.getInt("readcount"));
            
            // JSP 화면의 별점 출력을 위해 추가
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

}
