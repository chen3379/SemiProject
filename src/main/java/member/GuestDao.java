package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;

import mysql.db.DBConnect;

public class GuestDao {

    DBConnect db = new DBConnect();

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

    // 비회원 난수 생성 세션에 부여
    // 추후 쿠키에 저장해서 비회원 사용 편의성 증대
    public String createGuestUUID() {
        UUID uuid = UUID.randomUUID(); 
        return uuid.toString();
    }

    // 세션 생성되면 DB에 저장
    public void insertGuest(String guestUUID){
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        
        String sql = "insert into guest (guest_uuid) values (?)";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, guestUUID);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    // 기존 UUID 확인
    // 쿠키에서 UUID 가져와서 비교 후 boolean 반환  
    // 쿠키 구현 후 완성 예정
    public boolean getGuestUUID(String guestUUID) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "select guest_uuid from guest where guest_uuid = ?";
        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, guestUUID.trim());
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            db.dbClose(rs, pstmt, conn);
        } return false;
    }
      // 비회원 UUID 활동 로그 저장 후 회원가입시 UUID를 회원ID로 변경 메서드 추가 예정
}
