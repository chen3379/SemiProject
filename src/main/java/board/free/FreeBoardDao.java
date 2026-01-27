package board.free;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class FreeBoardDao {
    DBConnect db = new DBConnect();

    // [숨김] → is_deleted = 1
    // [복구] → is_deleted = 0
    
    public void insertBoard(FreeBoardDto dto) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "INSERT INTO free_board "
                + "(category_type, title, content, id, is_spoiler_type, filename, readcount, create_day) "
                + "VALUES (?, ?, ?, ?, ?, ?, 0, NOW())";

        try {
            conn = db.getDBConnect();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, dto.getCategory_type());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getContent());
            pstmt.setString(4, dto.getId());
            pstmt.setBoolean(5, dto.isIs_spoiler_type());
            pstmt.setString(6, dto.getFilename());

            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 리스트 함수
    public List<FreeBoardDto> getBoardList(String category, int start, int pageSize) {

        List<FreeBoardDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = db.getDBConnect();

            String sql =
                "SELECT " +
                " b.board_idx, b.category_type, b.title, b.id, m.nickname, " +
                " b.readcount, b.create_day, IFNULL(c.cnt, 0) AS comment_count " +
                "FROM free_board b " +
                "LEFT JOIN member m ON b.id = m.id " +
                "LEFT JOIN ( " +
                "   SELECT board_idx, COUNT(*) AS cnt " +
                "   FROM free_comment " +
                "   WHERE is_deleted = 0 " +
                "   GROUP BY board_idx " +
                ") c ON b.board_idx = c.board_idx " +
                "WHERE b.is_deleted = 0 ";

            if (!"all".equals(category)) {
                sql += "AND b.category_type = ? ";
            }

            sql += "ORDER BY b.board_idx DESC LIMIT ?, ?";

            pstmt = conn.prepareStatement(sql);

            int idx = 1;

            if (!"all".equals(category)) {
                pstmt.setString(idx++, category);
            }

            pstmt.setInt(idx++, start);
            pstmt.setInt(idx, pageSize);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                FreeBoardDto dto = new FreeBoardDto();
                dto.setBoard_idx(rs.getInt("board_idx"));
                dto.setCategory_type(rs.getString("category_type"));
                dto.setTitle(rs.getString("title"));
                dto.setId(rs.getString("id"));
                dto.setNickname(rs.getString("nickname"));
                dto.setReadcount(rs.getInt("readcount"));
                dto.setCreate_day(rs.getTimestamp("create_day"));
                dto.setCommentCount(rs.getInt("comment_count"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return list;
    }

    // 전체글 개수 (페이지 계산용)
    public int getTotalCount(String category) {

        int count = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = db.getDBConnect();

            String sql = "SELECT COUNT(*) FROM free_board WHERE is_deleted = 0 ";

            if (!"all".equals(category)) {
                sql += "AND category_type = ?";
            }

            pstmt = conn.prepareStatement(sql);

            if (!"all".equals(category)) {
                pstmt.setString(1, category);
            }

            rs = pstmt.executeQuery();
            if (rs.next())
                count = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }

        return count;
    }

    // 관리자용 전체 글 개수 (숨김 포함)
    public int getAdminTotalCount(String category) {

        int count = 0;

        String sql = "SELECT COUNT(*) FROM free_board ";

        if (!"all".equals(category)) {
            sql += "WHERE category_type = ?";
        }

        try (Connection conn = db.getDBConnect(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (!"all".equals(category)) {
                pstmt.setString(1, category);
            }

            ResultSet rs = pstmt.executeQuery();
            if (rs.next())
                count = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    // community.jsp 하단 – 자유게시판 TOP 10
    public List<FreeBoardDto> getTop10ByReadcount() {

        List<FreeBoardDto> list = new ArrayList<>();

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql =
        	    "SELECT board_idx, title, readcount " +
        	    "FROM free_board " +
        	    "WHERE (is_deleted = 0 OR is_deleted IS NULL) " +
        	    "ORDER BY readcount DESC " +
        	    "LIMIT 10";

        try {
            conn = db.getDBConnect();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                FreeBoardDto dto = new FreeBoardDto();
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

    // 조회수 증가
    public void updateReadCount(int board_idx) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE free_board "
                   + "SET readcount = readcount + 1 "
                   + "WHERE board_idx = ?";

        try {
            conn = db.getDBConnect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, board_idx);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 게시글 1건 조회 (숨김 포함)
    public FreeBoardDto getBoard(int board_idx) {
        FreeBoardDto dto = null;

        String sql =
            "SELECT b.*, m.nickname " +
            "FROM free_board b " +
            "JOIN member m ON b.id = m.id " +
            "WHERE b.board_idx = ?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new FreeBoardDto();
                dto.setBoard_idx(rs.getInt("board_idx"));
                dto.setCategory_type(rs.getString("category_type"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setFilename(rs.getString("filename"));
                dto.setId(rs.getString("id"));
                dto.setNickname(rs.getString("nickname")); 
                dto.setReadcount(rs.getInt("readcount"));
                dto.setCreate_day(rs.getTimestamp("create_day"));
                dto.setIs_deleted(rs.getInt("is_deleted"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dto;
    }



    public void updateBoard(int board_idx, String category, String title, String content) {

        Connection conn = null;
        PreparedStatement pstmt = null;

        String sql = "UPDATE free_board " + "SET category_type=?, title=?, content=?, update_day=NOW() "
                + "WHERE board_idx=?";

        try {
            conn = db.getDBConnect();
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, category);
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.setInt(4, board_idx);

            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 게시글 삭제
    public void deleteBoard(int board_idx) {

        String sql = "UPDATE free_board SET is_deleted = 1 WHERE board_idx = ?";

        try (Connection conn = db.getDBConnect(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

 // 관리자용 게시글 목록 (삭제/숨김 포함 + 댓글 수)
    public List<FreeBoardDto> getAdminBoardList(String category, int start, int pageSize) {

        List<FreeBoardDto> list = new ArrayList<>();

        String sql =
            "SELECT " +
            " b.board_idx, b.category_type, b.title, b.id, m.nickname, " +
            " b.readcount, b.create_day, b.is_deleted, " +
            " IFNULL(c.cnt, 0) AS comment_count " +
            "FROM free_board b " +
            "LEFT JOIN member m ON b.id = m.id " +
            "LEFT JOIN ( " +
            "   SELECT board_idx, COUNT(*) AS cnt " +
            "   FROM free_comment " +
            "   WHERE is_deleted = 0 " +
            "   GROUP BY board_idx " +
            ") c ON b.board_idx = c.board_idx ";

        if (!"all".equals(category)) {
            sql += "WHERE b.category_type = ? ";
        }

        sql += "ORDER BY b.board_idx DESC LIMIT ?, ?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int idx = 1;

            if (!"all".equals(category)) {
                pstmt.setString(idx++, category);
            }
            pstmt.setInt(idx++, start);
            pstmt.setInt(idx, pageSize);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                FreeBoardDto dto = new FreeBoardDto();
                dto.setBoard_idx(rs.getInt("board_idx"));
                dto.setCategory_type(rs.getString("category_type"));
                dto.setTitle(rs.getString("title"));
                dto.setId(rs.getString("id"));
                dto.setNickname(rs.getString("nickname"));
                dto.setReadcount(rs.getInt("readcount"));
                dto.setCreate_day(rs.getTimestamp("create_day"));
                dto.setIs_deleted(rs.getInt("is_deleted"));
                dto.setCommentCount(rs.getInt("comment_count"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 게시글 숨김 처리
    public boolean hideBoard(int board_idx) {

        String sql = "UPDATE free_board SET is_deleted = 1 WHERE board_idx = ?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);

            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 게시글 복구 처리
    public boolean restoreBoard(int board_idx) {

        String sql = "UPDATE free_board SET is_deleted = 0 WHERE board_idx = ?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);

            int result = pstmt.executeUpdate();
            return result > 0; //  성공 여부 반환

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 상세 하단에 보여줄 글 목록 (최근 N개, 본인 글 제외)
    public List<FreeBoardDto> getBottomBoardList(int currentBoardIdx, int limit) {

        List<FreeBoardDto> list = new ArrayList<>();

        String sql =
        	    "SELECT b.board_idx, b.title, b.create_day, m.nickname " +
        	    "FROM free_board b " +
        	    "JOIN member m ON b.id = m.id " +
        	    "WHERE b.is_deleted = 0 " +
        	    "AND b.board_idx <> ? " +
        	    "ORDER BY b.board_idx DESC " +
        	    "LIMIT ?";

        try (Connection conn = db.getDBConnect(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, currentBoardIdx);
            pstmt.setInt(2, limit);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                FreeBoardDto dto = new FreeBoardDto();
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

    // 관리자 전용 - 게시글 완전 삭제 (물리 삭제)
    public boolean deleteBoardForever(int board_idx) {

        String sql = "DELETE FROM free_board WHERE board_idx = ?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

}