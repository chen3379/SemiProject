package board.comment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class FreeCommentDao {

	DBConnect db= new DBConnect();
	
	//댓글 목록 조회
	public List<FreeCommentDto> getCommentList(int board_idx) {

	    List<FreeCommentDto> list = new ArrayList<>();
	    String sql = " SELECT * FROM free_comment  WHERE board_idx = ?  ORDER BY parent_comment_idx ASC, comment_idx ASC";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, board_idx);
	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            FreeCommentDto dto = new FreeCommentDto();
	            dto.setComment_idx(rs.getInt("comment_idx"));
	            dto.setBoard_idx(rs.getInt("board_idx"));
	            dto.setWriter_id(rs.getString("writer_id"));
	            dto.setContent(rs.getString("content"));
	            dto.setParent_comment_idx(rs.getInt("parent_comment_idx"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	            dto.setUpdate_day(rs.getTimestamp("update_day"));
	            dto.setCreate_id(rs.getString("create_id"));
	            dto.setUpdate_id(rs.getString("update_id"));
	            dto.setIs_deleted(rs.getInt("is_deleted"));

	            list.add(dto);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
	// 댓글 등록
	public void insertComment(FreeCommentDto dto) {

	    String sql = "INSERT INTO free_comment "
	               + "(board_idx, writer_id, content, parent_comment_idx, create_day, create_id) "
	               + "VALUES (?, ?, ?, ?, NOW(), ?)";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, dto.getBoard_idx());
	        pstmt.setString(2, dto.getWriter_id());
	        pstmt.setString(3, dto.getContent());
	        pstmt.setInt(4, dto.getParent_comment_idx()); // 원댓글이면 0
	        pstmt.setString(5, dto.getCreate_id());

	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	//댓글 카운트
	public int getCommentCount(int board_idx) {
	    int count = 0;
	    Connection conn = db.getDBConnect();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "SELECT COUNT(*) FROM free_comment WHERE board_idx=?";

	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, board_idx);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }
	    return count;
	}

	// 댓글 삭제 (소프트 삭제)
	public void deleteComment(int comment_idx, String loginId) {

	    String sql =
	        "UPDATE free_comment " +
	        "SET is_deleted = 1, update_day = NOW(), update_id = ? " +
	        "WHERE comment_idx = ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, loginId);
	        pstmt.setInt(2, comment_idx);
	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	

}
