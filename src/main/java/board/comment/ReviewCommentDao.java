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
        	    "ORDER BY parent_comment_idx ASC, comment_idx ASC";


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
        	    dto.setParent_comment_idx(rs.getInt("parent_comment_idx")); // ⭐
        	    dto.setCreate_day(rs.getTimestamp("create_day"));
        	    dto.setUpdate_day(rs.getTimestamp("update_day"));
        	    dto.setCreate_id(rs.getString("create_id"));
        	    dto.setUpdate_id(rs.getString("update_id"));
        	    dto.setIs_deleted(rs.getInt("is_deleted"));                 // ⭐

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
    
    // 댓글 등록
    public void insertComment(ReviewCommentDto dto) {

        String sql =
            "INSERT INTO review_comment " +
            "(board_idx, writer_id, content, parent_comment_idx, create_day, create_id) " +
            "VALUES (?, ?, ?, ?, NOW(), ?)";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, dto.getBoard_idx());
            pstmt.setString(2, dto.getWriter_id());
            pstmt.setString(3, dto.getContent());
            pstmt.setInt(4, dto.getParent_comment_idx()); // ⭐ 이 줄이 핵심
            pstmt.setString(5, dto.getCreate_id());

            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

 	
	// 댓글 삭제
	public void deleteComment(int comment_idx, String loginId) {

		String sql =
			    "UPDATE review_comment " +
			    "SET is_deleted = 1, update_day = NOW(), update_id = ? " +
			    "WHERE comment_idx = ? AND writer_id = ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	    	pstmt.setString(1, loginId);
	    	pstmt.setInt(2, comment_idx);
	    	pstmt.setString(3, loginId);
	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
	
}
