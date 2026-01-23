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

    /* =====================
       게시글 등록
    ===================== */
    public void insertBoard(FreeBoardDto dto) {

        String sql = "INSERT INTO free_board "
                + "(category_type, title, content, id, is_spoiler_type, filename, readcount, is_deleted, create_day) "
                + "VALUES (?, ?, ?, ?, ?, ?, 0, 0, NOW())";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, dto.getCategory_type());
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

    /* =====================
       일반 게시글 목록 (숨김 제외)
    ===================== */
    public List<FreeBoardDto> getBoardList(String category, int start, int pageSize) {

        List<FreeBoardDto> list = new ArrayList<>();

        String sql =
            "SELECT f.board_idx, f.category_type, f.title, f.id, f.readcount, f.create_day, m.nickname " +
            "FROM free_board f JOIN member m ON f.id = m.id " +
            "WHERE f.is_deleted = 0 ";

        if (!"all".equals(category)) {
            sql += "AND f.category_type = ? ";
        }

        sql += "ORDER BY f.board_idx DESC LIMIT ?, ?";

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
                dto.setReadcount(rs.getInt("readcount"));
                dto.setCreate_day(rs.getTimestamp("create_day"));
                dto.setNickname(rs.getString("nickname"));
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /* =====================
       전체 글 개수 (숨김 제외)
    ===================== */
    public int getTotalCount(String category) {

        int count = 0;

        String sql = "SELECT COUNT(*) FROM free_board WHERE is_deleted = 0 ";

        if (!"all".equals(category)) {
            sql += "AND category_type = ?";
        }

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (!"all".equals(category)) {
                pstmt.setString(1, category);
            }

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    /* =====================
       조회수 증가 (숨김 제외)
    ===================== */
    public void updateReadCount(int board_idx) {

        String sql =
            "UPDATE free_board SET readcount = readcount + 1 " +
            "WHERE board_idx = ? AND is_deleted = 0";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /* =====================
       게시글 상세 (숨김 제외)
    ===================== */
    public FreeBoardDto getBoard(int board_idx) {

        FreeBoardDto dto = null;

        String sql =
            "SELECT f.*, m.nickname " +
            "FROM free_board f JOIN member m ON f.id = m.id " +
            "WHERE f.board_idx = ? AND f.is_deleted = 0";

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
                dto.setReadcount(rs.getInt("readcount"));
                dto.setCreate_day(rs.getTimestamp("create_day"));
                dto.setNickname(rs.getString("nickname"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }

    /* =====================
       게시글 수정
    ===================== */
    public void updateBoard(int board_idx, String category, String title, String content) {

        String sql =
            "UPDATE free_board SET category_type=?, title=?, content=?, update_day=NOW() " +
            "WHERE board_idx=?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, category);
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.setInt(4, board_idx);

            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* =====================
       게시글 숨김 / 복구
    ===================== */
    public void hideBoard(int board_idx) {
        updateDeleteFlag(board_idx, 1);
    }

    public void restoreBoard(int board_idx) {
        updateDeleteFlag(board_idx, 0);
    }

    private void updateDeleteFlag(int board_idx, int flag) {

        String sql = "UPDATE free_board SET is_deleted = ? WHERE board_idx = ?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, flag);
            pstmt.setInt(2, board_idx);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /* =====================
       관리자용 게시글 목록 (숨김 포함)
    ===================== */
    public List<FreeBoardDto> getAdminBoardList(String category, int start, int pageSize) {

        List<FreeBoardDto> list = new ArrayList<>();

        String sql =
            "SELECT f.*, m.nickname " +
            "FROM free_board f JOIN member m ON f.id = m.id " +
            (category.equals("all") ? "" : "WHERE f.category_type = ? ") +
            "ORDER BY f.board_idx DESC LIMIT ?, ?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int idx = 1;

            if (!category.equals("all")) {
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
                dto.setReadcount(rs.getInt("readcount"));
                dto.setCreate_day(rs.getTimestamp("create_day"));
                dto.setIs_deleted(rs.getInt("is_deleted"));
                dto.setNickname(rs.getString("nickname"));
                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    /* =====================
       관리자 전용 - 물리 삭제
    ===================== */
    public void deleteBoardForever(int board_idx) {

        String sql = "DELETE FROM free_board WHERE board_idx = ?";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, board_idx);
            pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
