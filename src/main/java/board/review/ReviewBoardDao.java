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
	
	//리스트 함수
	public List<ReviewBoardDto> getReviewList() {

	    List<ReviewBoardDto> list = new ArrayList<>();

	    String sql =
	    		   "SELECT board_idx, genre_type, title, id, readcount, create_day " +
			        "FROM review_board " +
			        "ORDER BY board_idx DESC";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

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


}
