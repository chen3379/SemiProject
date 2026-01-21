package board.comment;

import mysql.db.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


public class ReviewCommentDao {
	DBConnect db= new DBConnect();
	
    // 댓글 목록
    public List<ReviewCommentDto> getCommentList(int board_idx) {

        List<ReviewCommentDto> list = new ArrayList<>();

        String sql = 
            "SELECT * FROM review_comment " +
            "WHERE board_idx = ? " +
            "ORDER BY comment_idx ASC";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewCommentDto dto = new ReviewCommentDto();
                dto.setComment_idx(rs.getInt("comment_idx"));
                dto.setBoard_idx(rs.getInt("board_idx"));
                dto.setWriter_id(rs.getString("writer_id"));
                dto.setContent(rs.getString("content"));
                dto.setCreate_day(rs.getTimestamp("create_day"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
	
	// 댓글 개수
    public int getCommentCount(int board_idx) {

        int count = 0;
        String sql = "SELECT COUNT(*) FROM review_comment WHERE board_idx = ?";

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
	
}
