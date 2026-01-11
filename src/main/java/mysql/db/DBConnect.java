package mysql.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnect {
	// url 경로 확인 필요 - schema 등
	static final String MYSQLDRIVER = "com.mysql.cj.jdbc.Driver";
	static final String MYSQL_URL = "jdbc:mysql://myhee.che2a2mk0gqm.ap-northeast-2.rds.amazonaws.com/semiproject?serverTimezone=Asia/Seoul";

	public DBConnect() {

		try {
			Class.forName(MYSQLDRIVER);
			System.out.println("#MYSQL 드라이버 성공");
		} catch (ClassNotFoundException e) {

			System.out.println("#MYSQL 드라이버 실패");
			e.printStackTrace();
		}
	}

	// MySQL서버연결메서드(Connection)
	public Connection getDBConnect() {
		Connection conn = null;
		try {
			conn = DriverManager.getConnection(MYSQL_URL, "adminhee", "비밀번호 수정 필요");
			System.out.println("#MYSQL 서버연결 성공");
		} catch (SQLException e) {
			System.out.println("#MYSQL 서버연결 실패");

			e.printStackTrace();
		}
		return conn;
	}

	// close메서드
	public void dbClose(ResultSet rs, Statement stmt, Connection conn) {
		try {
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {

			e.printStackTrace();
		}

	}

	public void dbClose(Statement stmt, Connection conn) {
		try {
			stmt.close();
			conn.close();
		} catch (SQLException e) {

			e.printStackTrace();
		}

	}

	public void dbClose(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		try {
			rs.close();
			pstmt.close();
			conn.close();
		} catch (SQLException e) {

			e.printStackTrace();
		}

	}

	public void dbClose(PreparedStatement pstmt, Connection conn) {
		try {
			pstmt.close();
			conn.close();
		} catch (SQLException e) {

			e.printStackTrace();
		}

	}

	public static void main(String[] args) {
		DBConnect db = new DBConnect();
		db.getDBConnect();

	}
}