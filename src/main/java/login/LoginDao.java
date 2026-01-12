package login;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DBConnect;

public class LoginDao {
	
	DBConnect db = new DBConnect();
	
	public boolean isLogIn(String id, String pass) {
		boolean flag=false;
		
		Connection conn = db.getDBConnect();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select * from login where id = ? and pass = ?";
		
		
		try {
			
			var s = "";
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return flag;
	}
	
	
}
