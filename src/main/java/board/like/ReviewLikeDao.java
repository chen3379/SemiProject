package board.like;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import mysql.db.DBConnect;

public class ReviewLikeDao {
	 DBConnect db = new DBConnect();

	 // 좋아요 여부 확인
    public boolean isLiked(int board_idx, String id) {
        boolean result = false;
        String sql = "SELECT COUNT(*) FROM review_like WHERE board_idx=? AND id=?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            pstmt.setString(2, id);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) result = rs.getInt(1) > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    // 좋아요 추가
    public void insertLike(int board_idx, String id) {
        String sql = "INSERT INTO review_like (board_idx, id) VALUES (?,?)";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            pstmt.setString(2, id);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 좋아요 취소
    public void deleteLike(int board_idx, String id) {
        String sql = "DELETE FROM review_like WHERE board_idx=? AND id=?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            pstmt.setString(2, id);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 좋아요 수
    public int getLikeCount(int board_idx) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM review_like WHERE board_idx=?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
	
}
