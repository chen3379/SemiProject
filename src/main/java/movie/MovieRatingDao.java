package movie;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DBConnect;

public class MovieRatingDao {
	
	DBConnect db=new DBConnect();
	
    // 내 별점 존재 여부
    public boolean isRating(int movieIdx, String id) {
    	boolean flag = false;
    	
    	Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select 1 from movie_rating where movie_idx=? and id=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, movieIdx);
            pstmt.setString(2, id);
            
            rs = pstmt.executeQuery();
            
            if(rs.next())
            	flag=true;
            		
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
    	
    	return flag;
    }
	
    // 내 별점 가져오기 (없으면 null)
    public BigDecimal getMyScore(int movieIdx, String id) {
    	BigDecimal score = null;
    	
    	Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select score from movie_rating where movie_idx=? and id=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, movieIdx);
            pstmt.setString(2, id);
            
            rs = pstmt.executeQuery();
            
            if(rs.next())
            	score = rs.getBigDecimal("score");
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
    	return score;
    }
    
    // 별점 insert
    public void insertRating(int movieIdx, String id, BigDecimal score) {
    	
    	if (score == null) 
    		return;
    	
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "insert into movie_rating(movie_idx, id, score, create_day) "
                   + "values(?,?,?,now())";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, movieIdx);
            pstmt.setString(2, id);
            // DB 컬럼(DECIMAL(2,1)) 규격에 맞춰 소수점 첫째 자리까지 값을 고정하여 저장
            pstmt.setBigDecimal(3, score.setScale(1, RoundingMode.HALF_UP));
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }
    
    // 별점 update
    public boolean updateRating(int movieIdx, String id, BigDecimal score) {

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        
        String sql = "update movie_rating set score=?, update_day=now() where movie_idx=? and id=?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setBigDecimal(1, score);
            pstmt.setInt(2, movieIdx);
            pstmt.setString(3, id);

            int n = pstmt.executeUpdate();
            return n > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;

        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }
    
    // 별점 있으면 update, 없으면 insert
    public void upsertRating(int movieIdx, String id, BigDecimal score) {

        if (isRating(movieIdx, id))
        	updateRating(movieIdx, id, score);
        else 
        	insertRating(movieIdx, id, score);
    }
    
    // 별점 delete
    public boolean deleteRating(int movieIdx, String id) {
        boolean flag = false;

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "delete from movie_rating where movie_idx=? and id=?";

        try {
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, movieIdx);
            pstmt.setString(2, id);
            
            //삭제됨-true, 삭제안됨(=그대로)-false
            int n = pstmt.executeUpdate();
            
            if (n > 0) 
            	flag = true;
            else 
            	flag = false;

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }

        return flag;
    }
	
}
