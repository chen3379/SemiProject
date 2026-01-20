package movie;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DBConnect;

public class MovieRatingStatDao {
	
	DBConnect db = new DBConnect();
	
	// 평균 별점 조회
	public BigDecimal getAvgScore(int movieIdx) {

        BigDecimal avgScore = BigDecimal.ZERO;

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
            "select ifnull(avg(score), 0) as avg_score " +
            "from movie_rating " +
            "where movie_idx = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, movieIdx);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                avgScore = rs.getBigDecimal("avg_score");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return avgScore;
    }
	
	//평점 참여 인원 수 
	public int getRatingCount(int movieIdx) {

	    int count = 0;

	    Connection conn = db.getDBConnect();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql =
	        "select count(*) as cnt " +
	        "from movie_rating " +
	        "where movie_idx = ?";

	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, movieIdx);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            count = rs.getInt("cnt");
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return count;
	}
	
	// stat 테이블에 해당 movie_idx가 이미 있는지 확인
    public boolean isStatExist(int movieIdx) {
        boolean flag = false;

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select 1 from movie_rating_stat where movie_idx=?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, movieIdx);
            rs = pstmt.executeQuery();

            if (rs.next()) flag = true;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return flag;
    }

    // movie_rating에서 평균/개수 계산해서 stat 갱신
    // 평균 별점 존재하면 update, 없으면 insert
    public void refreshStat(int movieIdx) {

        // 1) movie_rating에서 평균/개수 계산
        double avgRating = 0;
        int countRating = 0;

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sqlCalc = "select ifnull(avg(score), 0) as avg_rating, "
                       + "count(*) as count_rating "
                       + "from movie_rating "
                       + "where movie_idx=?";

        try {
            pstmt = conn.prepareStatement(sqlCalc);
            pstmt.setInt(1, movieIdx);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                avgRating = rs.getDouble("avg_rating");
                countRating = rs.getInt("count_rating");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        // 2) stat 테이블에 저장 (있으면 update, 없으면 insert)
        if (isStatExist(movieIdx)) {
            updateStat(movieIdx, avgRating, countRating);
        } else {
            insertStat(movieIdx, avgRating, countRating);
        }
    }

    // 평균 별점 insert
    public void insertStat(int movieIdx, double avgRating, int countRating) {

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "insert into movie_rating_stat "
                   + "(movie_idx, avg_rating, count_rating, update_day) "
                   + "values (?, ?, ?, now())";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, movieIdx);
            pstmt.setDouble(2, avgRating);
            pstmt.setInt(3, countRating);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 평균 별점 update
    public void updateStat(int movieIdx, double avgRating, int countRating) {

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "update movie_rating_stat "
                   + "set avg_rating=?, count_rating=?, update_day=now() "
                   + "where movie_idx=?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setDouble(1, avgRating);
            pstmt.setInt(2, countRating);
            pstmt.setInt(3, movieIdx);

            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }
}