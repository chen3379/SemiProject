package member;

import mysql.db.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

public class MemberDao {

    DBConnect db = new DBConnect();
     
    // 회원 가입
    public String insertMember(MemberDto memberDto) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        String sql = "insert into member (nickname, id, password,create_day) values (?, ?, ?, now())";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, memberDto.getNickname().trim());
            pstmt.setString(2, memberDto.getId().trim());
            pstmt.setString(3, memberDto.getPassword());

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

    // updatePassword 비밀번호 수정

    
    // updateProfile 프로필 수정
    
    // updatePhoto 프로필 사진 수정
    
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


    // selectOneMemberbyId 로그인시 세션에 회원정보 저장
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
        } return memberDto;
    }
    
    

    // selectPasswordById 아이디로 찾기(이메일 전송 api가져올 예졍)
    // selectPasswordByHp 전화번호로 찾기(문자 전송 api 가져올 예정 비싸지않을까..)
    
   

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

    