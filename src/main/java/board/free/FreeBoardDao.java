package board.free;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class FreeBoardDao {
	DBConnect db= new DBConnect();
	
	//insert 
	public void insertBoard(FreeBoardDto dto)
	{
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    String sql = "INSERT INTO free_board (category_type, title, content, id, is_spoiler_type, readcount, create_day) VALUES (?, ?, ?, ?, ?, 0, NOW())";

	    try {
	        conn = db.getDBConnect();
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, dto.getCategory_type());
	        pstmt.setString(2, dto.getTitle());
	        pstmt.setString(3, dto.getContent());
	        pstmt.setString(4, dto.getId());               // 작성자
	        pstmt.setBoolean(5, dto.isIs_spoiler_type());  // 스포 여부

	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(null, pstmt, conn);
	    }
	}

	
	
	//리스트 함수
	public List<FreeBoardDto> getBoardList(String category) {

	    List<FreeBoardDto> list = new ArrayList<>();
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = db.getDBConnect();

	        String sql =
	            "SELECT board_idx, category_type, title, id, readcount, create_day " +
	            "FROM free_board ";

	        // 🔥 전체가 아닐 때만 WHERE 추가
	        if (!"all".equals(category)) {
	            sql += "WHERE category_type = ? ";
	        }

	        sql += "ORDER BY board_idx DESC";

	        pstmt = conn.prepareStatement(sql);

	        if (!"all".equals(category)) {
	            pstmt.setString(1, category);
	        }

	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            FreeBoardDto dto = new FreeBoardDto();
	            dto.setBoard_idx(rs.getInt("board_idx"));
	            dto.setCategory_type(rs.getString("category_type"));
	            dto.setTitle(rs.getString("title"));
	            dto.setId(rs.getString("id"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));

	            list.add(dto);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return list;
	}
	
	//community.jsp 하단 – 자유게시판 TOP 10
	public List<FreeBoardDto> getTop10List() {
	    List<FreeBoardDto> list = new ArrayList<>();

	    String sql = " SELECT * FROM free_board ORDER BY readcount DESC, create_day DESC LIMIT 10";

	    // DB 연결 + ResultSet → list 담기
	    return list;
	}

	//조회수 증가 
	public void updateReadCount(int board_idx) {
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt =null;
		
	    String sql = "UPDATE free_board SET readcount = readcount + 1 WHERE board_idx = ?";
	    
	    conn= db.getDBConnect();
	    try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, board_idx);
		     pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(null, pstmt, conn);
		}
	}
	
	// 게시글 1건 조회
	public FreeBoardDto getBoard(int board_idx) {
	    FreeBoardDto dto = null;
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "SELECT * FROM free_board WHERE board_idx = ?";

	    try {
	        conn = db.getDBConnect();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, board_idx);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            dto = new FreeBoardDto();
	            dto.setBoard_idx(rs.getInt("board_idx"));
	            dto.setCategory_type(rs.getString("category_type"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setId(rs.getString("id"));
	            dto.setReadcount(rs.getInt("readcount"));
	            dto.setCreate_day(rs.getTimestamp("create_day"));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        db.dbClose(rs, pstmt, conn);
	    }

	    return dto;
	}


}
