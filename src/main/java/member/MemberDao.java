package member;

import mysql.db.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class MemberDao {

    DBConnect db = new DBConnect();
     
    public String insertMember(MemberDto memberDto) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        String sql = "insert into member (id, password, create_day) values (?, ?, now())";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberDto.getId().trim());
            pstmt.setString(2, memberDto.getPassword());

            int result = pstmt.executeUpdate();

            if (result > 0)
                return "SUCCESS";
            else
                return "FAIL";

        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            // 아이디 중복(Primary Key 위반) 시 발생하는 예외
            return "DUPLICATE";
        } catch (SQLException e) {
            // 그 외 SQL 에러 (컬럼 길이 초과, DB 연결 끊김 등)
            e.printStackTrace();
            return "ERROR";
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // selectOneMemberbyId 아이디 조회
    // selectAllMemberbyId 모든 회원 조회

    // selectPasswordById 아이디로 찾기
    // selectPasswordByHp 전화번호로 찾기
    
    // deleteMember 회원삭제

    // updatePassword 비밀번호 수정
    // updateProfile 프로필 수정
    
    // updatePhoto 프로필 사진 수정
    
    // updateRoleType 권한 수정
    

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
        } return hashedPassword;

    }

    // 로그인 성공 후 role_type 조회 -> 백엔드에서 세션에 저장
    public String getRoleType(String id) {
        if (id == null || id.trim().isEmpty()) {
            return "3"; // 오류로 NULL 값일 경우 비회원
        }
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
        } return roleType;
    }

}

    