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
	static final String MYSQL_URL = "jdbc:mysql://myhee.che2a2mk0gqm.ap-northeast-2.rds.amazonaws.com/moviereview?serverTimezone=Asia/Seoul";

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
			conn = DriverManager.getConnection(MYSQL_URL, "adminhee", "awsSIST2025");
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
			// 1. rs가 null이 아닐 때만 닫아야 함 (여기서 에러 나셨을 겁니다)
			if (rs != null) {
				rs.close();
			}

			// 2. stmt(pstmt) 닫기
			if (stmt != null) {
				stmt.close();
			}

			// 3. conn 닫기
			if (conn != null) {
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) {
		DBConnect db = new DBConnect();
		db.getDBConnect();

	}
}