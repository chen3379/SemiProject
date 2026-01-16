package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DBConnect;

public class ProfileDao {
    
    DBConnect db = new DBConnect();

    // 프로필 조회시 아이디 검색
     public Boolean checkId(String id) {
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
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
    }
}
