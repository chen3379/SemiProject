package board.like;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import mysql.db.DBConnect;

public class ReviewLikeDao {
	 DBConnect db = new DBConnect();

	    // 좋아요 개수
	    public int getLikeCount(int board_idx) {

	        int count = 0;
	        String sql = "SELECT COUNT(*) FROM review_like WHERE board_idx = ?";

	        try (Connection conn = db.getDBConnect();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setInt(1, board_idx);
	            ResultSet rs = pstmt.executeQuery();

	            if (rs.next()) {
	                count = rs.getInt(1);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return count;
	    }

	    // 내가 좋아요 눌렀는지
	    public boolean isLiked(int board_idx, String id) {

	        boolean liked = false;
	        String sql = "SELECT 1 FROM review_like WHERE board_idx = ? AND id = ?";

	        try (Connection conn = db.getDBConnect();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setInt(1, board_idx);
	            pstmt.setString(2, id);

	            ResultSet rs = pstmt.executeQuery();
	            liked = rs.next();

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return liked;
	    }
	
}
