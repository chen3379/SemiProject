package board.review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class ReviewBoardDao {
	DBConnect db= new DBConnect();
	
	public List<ReviewBoardDto> getTop10ByReadcount() {
	    List<ReviewBoardDto> list = new ArrayList<>();
	    

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "SELECT review_idx, title, readcount " +
	                 "FROM review_board " +
	                 "ORDER BY readcount DESC LIMIT 10";
	    
	    try {
	        conn = db.getDBConnect();
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ReviewBoardDto dto = new ReviewBoardDto();
	            dto.setBoard_idx(rs.getInt("board_idx"));
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
