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
}