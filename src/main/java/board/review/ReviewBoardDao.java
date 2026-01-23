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
	
	//[숨김] → is_deleted = 1

	//[복구] → is_deleted = 0
	
	// 페이징 리스트
	public List<ReviewBoardDto> getReviewList(int start, int pageSize) {

	    List<ReviewBoardDto> list = new ArrayList<>();

	    String sql =
	    		"SELECT board_idx, genre_type, title, id, readcount, create_day, is_spoiler " +
	    		        "FROM review_board " +
	    		        "WHERE is_deleted = 0 " +
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
	             dto.setIs_spoiler_type(rs.getBoolean("is_spoiler"));
	             list.add(dto);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	// 유저용 전체 글 개수
	public int getTotalCount() {

	    int count = 0;
	    String sql = "SELECT COUNT(*) FROM review_board WHERE is_deleted = 0";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        if (rs.next()) count = rs.getInt(1);

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return count;
	}
	
	// 관리자용 리스트 (숨김 포함)
	public List<ReviewBoardDto> getAdminReviewList(int start, int pageSize) {

	    List<ReviewBoardDto> list = new ArrayList<>();

	    String sql =
	        "SELECT board_idx, genre_type, title, id, readcount, create_day, is_spoiler, is_deleted " +
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
	            dto.setIs_spoiler_type(rs.getBoolean("is_spoiler"));
	            dto.setIs_deleted(rs.getInt("is_deleted"));
	            list.add(dto);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}

	// 관리자용 전체 글 개수 (숨김 포함)
	public int getAdminTotalCount() {

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
	    		"SELECT board_idx, genre_type, title, readcount, is_spoiler FROM review_board ORDER BY readcount DESC LIMIT 10";
	    
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
	            dto.setIs_spoiler_type(rs.getBoolean("is_spoiler"));

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

	    String sql = "SELECT * FROM review_board WHERE board_idx = ? AND is_deleted = 0";

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
	            dto.setFilename(rs.getString("filename"));
	            dto.setId(rs.getString("id"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	            dto.setIs_spoiler_type(rs.getBoolean("is_spoiler"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return dto;
	}

	// 리뷰 글 등록
	public void insertBoard(ReviewBoardDto dto) {

	    String sql =
	    		"INSERT INTO review_board (genre_type, title, content, id, is_spoiler, filename, create_day) VALUES (?, ?, ?, ?, ?, ?, NOW())";
	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, dto.getGenre_type());
	        pstmt.setString(2, dto.getTitle());
	        pstmt.setString(3, dto.getContent());
	        pstmt.setString(4, dto.getId());
	        pstmt.setBoolean(5, dto.isIs_spoiler_type());
	        pstmt.setString(6, dto.getFilename());

	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	public void updateBoard(
		    int board_idx,
		    String title,
		    String content,
		    String genre,
		    String filename
		) {
		    String sql =
		        "UPDATE review_board " +
		        "SET title=?, content=?, genre_type=?, filename=?, update_day=NOW() " +
		        "WHERE board_idx=?";

		    try (Connection conn = db.getDBConnect();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {

		        pstmt.setString(1, title);
		        pstmt.setString(2, content);
		        pstmt.setString(3, genre);
		        pstmt.setString(4, filename);
		        pstmt.setInt(5, board_idx);

		        pstmt.executeUpdate();

		    } catch (Exception e) {
		        e.printStackTrace();
		    }
		}

	// 리뷰 글 숨김
	public void deleteBoard(int board_idx) {

	    String sql = "UPDATE review_board SET is_deleted = 1 WHERE board_idx = ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, board_idx);
	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	// 리뷰 글 복구
	public void restoreBoard(int board_idx) {

	    String sql = "UPDATE review_board SET is_deleted = 0 WHERE board_idx = ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, board_idx);
	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

	// ReviewBoardDao.java
	public List<ReviewBoardDto> getOtherBoards(int boardIdx, int limit) {
	    List<ReviewBoardDto> list = new ArrayList<>();

	    String sql = "SELECT board_idx, title, id, create_day  FROM review_board   WHERE board_idx != ?   ORDER BY create_day DESC LIMIT ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, boardIdx);
	        ps.setInt(2, limit);

	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            ReviewBoardDto dto = new ReviewBoardDto();
	            dto.setBoard_idx(rs.getInt("board_idx"));
	            dto.setTitle(rs.getString("title"));
	            dto.setId(rs.getString("id"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	// 관리자용 상세 조회 (숨김 포함)
	public ReviewBoardDto getAdminBoard(int board_idx) {

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
	            dto.setFilename(rs.getString("filename"));
	            dto.setId(rs.getString("id"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	            dto.setIs_spoiler_type(rs.getBoolean("is_spoiler"));
	            dto.setIs_deleted(rs.getInt("is_deleted"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return dto;
	}

	
}
