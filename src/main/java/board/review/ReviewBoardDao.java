package board.review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import board.free.FreeBoardDto;
import mysql.db.DBConnect;

public class ReviewBoardDao {
	DBConnect db= new DBConnect();
	
	// 페이징 리스트
	public List<ReviewBoardDto> getReviewList(int start, int pageSize) {

	    List<ReviewBoardDto> list = new ArrayList<>();

	    String sql =
	        "SELECT board_idx, genre_type, title, id, readcount, create_day " +
	        "FROM review_board " +
	        "ORDER BY board_idx DESC LIMIT ?, ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, start);
	        pstmt.setInt(2, pageSize);

	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ReviewBoardDto dto = new ReviewBoardDto();
	            dto.setBoard_idx(rs.getInt("board_idx"));
	            dto.setGenre_type(rs.getString("genre_type"));
	            dto.setTitle(rs.getString("title"));
	            dto.setId(rs.getString("id"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	            list.add(dto);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	// 전체 개수
	public int getTotalCount() {

	    int count = 0;
	    String sql = "SELECT COUNT(*) FROM review_board";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        if (rs.next()) count = rs.getInt(1);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return count;
	}

	
	public List<ReviewBoardDto> getTop10ByReadcount() {
	    List<ReviewBoardDto> list = new ArrayList<>();
	    

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;


	    String sql =
	        "SELECT board_idx, genre_type, title, readcount " +
	        "FROM review_board " +
	        "ORDER BY readcount DESC LIMIT 10";
	    
	    try {
	        conn = db.getDBConnect();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ReviewBoardDto dto = new ReviewBoardDto();
	            dto.setBoard_idx(rs.getInt("board_idx"));
	            dto.setGenre_type(rs.getString("genre_type"));
	            dto.setTitle(rs.getString("title"));
	            dto.setReadcount(rs.getInt("readcount"));

	            list.add(dto);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return list;
	}
	
	
	// 조회수 증가
	public void updateReadCount(int board_idx) {

	    String sql = "UPDATE review_board SET readcount = readcount + 1 WHERE board_idx = ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, board_idx);
	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	// 상세 조회
	public ReviewBoardDto getBoard(int board_idx) {

	    ReviewBoardDto dto = null;

	    String sql = "SELECT * FROM review_board WHERE board_idx = ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, board_idx);
	        ResultSet rs = pstmt.executeQuery();

	        if (rs.next()) {
	            dto = new ReviewBoardDto();
	            dto.setBoard_idx(rs.getInt("board_idx"));
	            dto.setGenre_type(rs.getString("genre_type"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setId(rs.getString("id"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	            //dto.setUpdate_day(rs.getTimestamp("update_day"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return dto;
	}


}
