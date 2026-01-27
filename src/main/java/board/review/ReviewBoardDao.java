package board.review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import mysql.db.DBConnect;

public class ReviewBoardDao {
	DBConnect db= new DBConnect();
	
	//[숨김] → is_deleted = 1
	//[복구] → is_deleted = 0
	
	// 페이징 리스트
	public List<ReviewBoardDto> getReviewList(int start, int pageSize) {

	    List<ReviewBoardDto> list = new ArrayList<>();

	    String sql =
    	    "SELECT " +
    	    " r.board_idx, r.genre_type, r.title, r.id, r.readcount, " +
    	    " r.create_day, r.is_spoiler, m.nickname, " +
    	    " IFNULL(c.cnt, 0) AS comment_count " +
    	    "FROM review_board r " +
    	    "JOIN member m ON r.id = m.id " +
    	    "LEFT JOIN ( " +
    	    "   SELECT board_idx, COUNT(*) AS cnt " +
    	    "   FROM review_comment " +
    	    "   WHERE is_deleted = 0 " +
    	    "   GROUP BY board_idx " +
    	    ") c ON r.board_idx = c.board_idx " +
    	    "WHERE r.is_deleted = 0 " +
    	    "ORDER BY r.board_idx DESC " +
    	    "LIMIT ?, ?";
	    
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
	            dto.setNickname(rs.getString("nickname"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	            dto.setIs_spoiler_type(rs.getBoolean("is_spoiler"));
	            dto.setCommentCount(rs.getInt("comment_count"));

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
	        "SELECT r.board_idx, r.genre_type, r.title, r.id, r.readcount, " +
	        "       r.create_day, r.is_spoiler, r.is_deleted, " +
	        "       COUNT(c.comment_idx) AS comment_count " +
	        "FROM review_board r " +
	        "LEFT JOIN review_comment c " +
	        "  ON r.board_idx = c.board_idx AND c.is_deleted = 0 " +
	        "GROUP BY r.board_idx " +
	        "ORDER BY r.board_idx DESC " +
	        "LIMIT ?, ?";

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
	            dto.setCommentCount(rs.getInt("comment_count"));

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
            "SELECT r.board_idx, r.genre_type, r.title, r.readcount, r.is_spoiler " +
            "FROM review_board r " +
            "JOIN member m ON r.id = m.id " +
            "WHERE r.is_deleted = 0 " +
            "ORDER BY r.readcount DESC " +
            "LIMIT 10";

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

		String sql =
	    "UPDATE review_board " +
	    "SET readcount = readcount + 1 " +
	    "WHERE board_idx = ? AND is_deleted = 0";

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

	    String sql =
    		"SELECT r.*, m.nickname " +
	        "FROM review_board r " +
	        "JOIN member m ON r.id = m.id " +
	        "WHERE r.board_idx = ?";

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
	            dto.setNickname(rs.getString("nickname")); 
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
		    boolean is_spoiler,
		    String filename
		) {
		    String sql =
		        "UPDATE review_board SET title=?, content=?, genre_type=?, is_spoiler=?, filename=? WHERE board_idx=?";

		    try (Connection conn = db.getDBConnect();
		         PreparedStatement pstmt = conn.prepareStatement(sql)) {

		        pstmt.setString(1, title);
		        pstmt.setString(2, content);
		        pstmt.setString(3, genre);
		        pstmt.setBoolean(4, is_spoiler);
		        pstmt.setString(5, filename);
		        pstmt.setInt(6, board_idx);

		        pstmt.executeUpdate();
		    } catch (SQLException e) {
				// TODO Auto-generated catch block
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

	//다른글 더보
	public List<ReviewBoardDto> getOtherBoards(int currentBoardIdx, int limit) {

	    List<ReviewBoardDto> list = new ArrayList<>();

	    String sql =
	        "SELECT r.board_idx, r.title, r.create_day, m.nickname " +
	        "FROM review_board r " +
	        "JOIN member m ON r.id = m.id " +
	        "WHERE r.is_deleted = 0 " +
	        "AND r.board_idx <> ? " +
	        "ORDER BY r.board_idx DESC " +
	        "LIMIT ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, currentBoardIdx);
	        pstmt.setInt(2, limit);

	        ResultSet rs = pstmt.executeQuery();

	        while (rs.next()) {
	            ReviewBoardDto dto = new ReviewBoardDto();
	            dto.setBoard_idx(rs.getInt("board_idx"));
	            dto.setTitle(rs.getString("title"));
	            dto.setNickname(rs.getString("nickname")); 
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
	
	// 관리자 전용 - 리뷰 게시글 완전 삭제
	public boolean deleteBoardForever(int board_idx) {

	    String sql = "DELETE FROM review_board WHERE board_idx = ?";

	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, board_idx);
	        return pstmt.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}
	
	// 리뷰 글 숨김
	public boolean hideBoard(int board_idx) {
	    String sql = "UPDATE review_board SET is_deleted = 1 WHERE board_idx = ?";
	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, board_idx);
	        return pstmt.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	// 리뷰 글 복구
	public boolean restoreBoard(int board_idx) {
	    String sql = "UPDATE review_board SET is_deleted = 0 WHERE board_idx = ?";
	    try (Connection conn = db.getDBConnect();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setInt(1, board_idx);
	        return pstmt.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return false;
	}
}
