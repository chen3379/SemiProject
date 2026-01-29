package member;

import mysql.db.DBConnect;

import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
import board.free.FreeBoardDto;
import board.review.ReviewBoardDto;

public class MemberDao {

    DBConnect db = new DBConnect();

    // 회원 가입
    public String insertMember(MemberDto memberDto) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        String sql = "insert into member (nickname, id, password,create_day, photo) values (?, ?, ?, now(), ?)";
        if (isIdDuplicate(memberDto.getId())) {
            return "DUPLICATE_ID";
        }

        if (isNicknameDuplicate(memberDto.getNickname())) {
            return "DUPLICATE_NICKNAME";
        }

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberDto.getNickname().trim());
            pstmt.setString(2, memberDto.getId().trim());
            pstmt.setString(3, memberDto.getPassword());
            pstmt.setString(4, "/profile_photo/default_photo.jpg");
            int result = pstmt.executeUpdate();

            if (result > 0)
                return "SUCCESS";
            else
                return "FAIL";
        } catch (SQLIntegrityConstraintViolationException e) {
            e.printStackTrace();
            return "DUPLICATE_ID";
        } catch (SQLException e) {
            e.printStackTrace();
            return "ERROR";
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 아이디 중복 체크
    public Boolean isIdDuplicate(String id) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "select * from member where id = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return true;
            } else {
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
    }

    // 닉네임 중복 체크
    public Boolean isNicknameDuplicate(String nickname) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "select * from member where nickname = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nickname.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return true;
            } else {
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
    }

    // updateMember 회원정보 수정
    public int updateMember(MemberDto memberDto) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        String sql = "update member set nickname=?, name=?, age=?, gender=?, hp=?, addr=?, photo=?, update_day=now() where id=?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberDto.getNickname());
            pstmt.setString(2, memberDto.getName());
            pstmt.setInt(3, memberDto.getAge());
            pstmt.setString(4, memberDto.getGender());
            pstmt.setString(5, memberDto.getHp());
            pstmt.setString(6, memberDto.getAddr());
            pstmt.setString(7, memberDto.getPhoto());
            pstmt.setString(8, memberDto.getId());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // updatePassword 비밀번호 변경
    public int updatePassword(String id, String password) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        String sql = "update member set password=?, update_day=now() where id=?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, password);
            pstmt.setString(2, id);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // checkPassword 비밀번호 확인
    public boolean checkPassword(String id, String password) {
        String hashedPassword = getHashedPassword(id);
        if (hashedPassword == null) {
            return false;
        }

        try {
            // BCrypt.checkpw(pw, hashedPw) : 입력된 비밀번호와 데이터베이스에 저장된 해시된 비밀번호가 일치하는지 확인
            return BCrypt.checkpw(password, hashedPassword);
        } catch (Exception e) {
            // 소셜 로그인 회원의 경우 "KAKAO_LOGIN" 등이 저장되어 있어 BCrypt check 시 예외가 발생할 수 있음
            return false;
        }
    }

    // deleteMember 회원삭제
    public int deleteMember(String id) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        String sql = "delete from member where id = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id.trim());
            return pstmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 아이디로 한명 조회
    public MemberDto selectOneMemberbyId(String id) {

        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        MemberDto memberDto = null;
        String sql = "select * from member where id = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                memberDto = new MemberDto();
                memberDto.setMemberIdx(rs.getInt("member_idx"));
                memberDto.setId(rs.getString("id"));
                memberDto.setRoleType(rs.getString("role_type"));
                memberDto.setStatus(rs.getString("status"));
                memberDto.setJoinType(rs.getString("join_type"));
                memberDto.setNickname(rs.getString("nickname"));
                memberDto.setCreateDay(rs.getTimestamp("create_day"));
                memberDto.setUpdateDay(rs.getTimestamp("update_day"));
                memberDto.setAge(rs.getInt("age"));
                memberDto.setName(rs.getString("name"));
                memberDto.setGender(rs.getString("gender"));
                memberDto.setHp(rs.getString("hp"));
                memberDto.setAddr(rs.getString("addr"));
                memberDto.setPhoto(rs.getString("photo"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return memberDto;
    }

    // 닉네임으로 조회
    public MemberDto selectOneMemberbyNickname(String nickname) {

        if (nickname == null || nickname.trim().isEmpty()) {
            return null;
        }
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        MemberDto memberDto = null;
        String sql = "select * from member where nickname = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nickname.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                memberDto = new MemberDto();
                memberDto.setMemberIdx(rs.getInt("member_idx"));
                memberDto.setId(rs.getString("id"));
                memberDto.setRoleType(rs.getString("role_type"));
                memberDto.setStatus(rs.getString("status"));
                memberDto.setJoinType(rs.getString("join_type"));
                memberDto.setNickname(rs.getString("nickname"));
                memberDto.setCreateDay(rs.getTimestamp("create_day"));
                memberDto.setUpdateDay(rs.getTimestamp("update_day"));
                memberDto.setAge(rs.getInt("age"));
                memberDto.setName(rs.getString("name"));
                memberDto.setGender(rs.getString("gender"));
                memberDto.setHp(rs.getString("hp"));
                memberDto.setAddr(rs.getString("addr"));
                memberDto.setPhoto(rs.getString("photo"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return memberDto;
    }

    // nickname으로 idList 찾기
    // 이거 기준으로 메서드 통일!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // null값이나 empty 왔을 때 빈 거 반환
    // e로 예외 던지기
    public List<String> getIdListByNickname(String nickname) throws SQLException {
        if (nickname == null || nickname.trim().isEmpty()) {
            return Collections.emptyList();
        }
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<String> idList = new ArrayList<>();
        String sql = "select id from member where nickname = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nickname.trim());
            rs = pstmt.executeQuery();

            while (rs.next()) {
                idList.add(rs.getString("id"));
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] getIdListByNickname 쿼리 실행 중 오류: " + e.getMessage());
            throw e;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return idList;
    }

    // id 확인(pass 찾을때 email로 otp 전송용)
    public String IsIdExist(String id) throws SQLException {
        if (id == null || id.trim().isEmpty()) {
            return "";
        }
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select id from member where id = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return "SUCCESS";
            }

        } catch (SQLException e) {
            System.err.println("[ERROR] IsIdExist 쿼리 실행 중 오류: " + e.getMessage());
            throw e;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return "SUCCESS";
    }

    // OTP 생성
    public String createOtp() {
        SecureRandom random = new SecureRandom();
        int otp = random.nextInt(900000) + 100000;
        return String.valueOf(otp);
    }

    // 로그인 메서드
    public String getHashedPassword(String id) {
        if (id == null || id.trim().isEmpty()) {
            return null;
        }
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String hashedPassword = null;
        String sql = "select password from member where id = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                hashedPassword = rs.getString("password");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return hashedPassword;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return hashedPassword;

    }

    // 로그인 성공 후 role_type 조회
    public String getRoleType(String id) {

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String roleType = null;
        String sql = "select role_type from member where id = ?";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id.trim());
            rs = pstmt.executeQuery();

            if (rs.next()) {
                roleType = rs.getString("role_type");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return roleType;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return roleType;
    }

    // [추가] 회원별 자유게시판 작성글 조회 (검색 포함)
    public List<FreeBoardDto> getBoardListById(String id, String search) {
        List<FreeBoardDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM free_board WHERE id = ? ";
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (title LIKE ? OR content LIKE ?) ";
        }
        sql += "ORDER BY board_idx DESC";

        try {
            conn = db.getDBConnect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            if (search != null && !search.trim().isEmpty()) {
                pstmt.setString(2, "%" + search + "%");
                pstmt.setString(3, "%" + search + "%");
            }
            rs = pstmt.executeQuery();

            while (rs.next()) {
                FreeBoardDto dto = new FreeBoardDto();
                dto.setBoard_idx(rs.getInt("board_idx"));
                dto.setCategory_type(rs.getString("category_type"));
                dto.setTitle(rs.getString("title"));
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

    // [추가] 회원별 리뷰게시판 작성글 조회 (검색 포함)
    public List<ReviewBoardDto> getReviewListById(String id, String search) {
        List<ReviewBoardDto> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM review_board WHERE id = ? ";
        if (search != null && !search.trim().isEmpty()) {
            sql += "AND (title LIKE ? OR content LIKE ?) ";
        }
        sql += "ORDER BY board_idx DESC";

        try {
            conn = db.getDBConnect();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            if (search != null && !search.trim().isEmpty()) {
                pstmt.setString(2, "%" + search + "%");
                pstmt.setString(3, "%" + search + "%");
            }
            rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewBoardDto dto = new ReviewBoardDto();
                dto.setBoard_idx(rs.getInt("board_idx"));
                dto.setGenre_type(rs.getString("genre_type"));
                dto.setTitle(rs.getString("title"));
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

    // [추가] 리뷰 삭제
    public void deleteReview(int board_idx) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "DELETE FROM review_board WHERE board_idx = ?";
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

    // [추가] 자유게시판 글 삭제
    public void deleteBoard(int board_idx) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "DELETE FROM free_board WHERE board_idx = ?";
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
    
    //[추가] 카카오 소셜 회원 가입
    public boolean insertKakaoMember(MemberDto dto) {

        // 이미 가입된 카카오 회원이면 insert 안 함
        if (isIdDuplicate(dto.getId())) {
            return false;
        }

        String sql =
            "INSERT INTO member " +
            "(id, password, nickname, join_type, role_type, status, photo, create_day) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        try (Connection conn = db.getDBConnect();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, dto.getId());
            pstmt.setString(2, "KAKAO_LOGIN");
            pstmt.setString(3, dto.getNickname());
            pstmt.setString(4, "kakao");
            pstmt.setString(5, "1");
            pstmt.setString(6, "active");
            pstmt.setString(7, "/profile_photo/default_photo.jpg");

            return pstmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
