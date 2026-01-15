package mysql.db;

import java.io.InputStream; // 파일 읽기용
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties; // 프로퍼티 사용

public class DBConnect {

    static final String MYSQLDRIVER = "com.mysql.cj.jdbc.Driver";
    static final String MYSQL_URL = "jdbc:mysql://myhee.che2a2mk0gqm.ap-northeast-2.rds.amazonaws.com/moviereview?serverTimezone=Asia/Seoul";

    // ★ 비밀번호를 담아둘 변수 선언
    private String dbPassword = "";

    public DBConnect() {
        // 1. 드라이버 로딩
        try {
            Class.forName(MYSQLDRIVER);
            System.out.println("#MYSQL 드라이버 성공");
        } catch (ClassNotFoundException e) {
            System.out.println("#MYSQL 드라이버 실패");
            e.printStackTrace();
        }

        // 2. ★ secret.properties 파일에서 비밀번호 읽어오기
        try {
            // 파일을 찾아서 엽니다 (src/main/java/secret.properties)
            InputStream input = getClass().getClassLoader().getResourceAsStream("secret.properties");

            if (input != null) {
                Properties prop = new Properties();
                prop.load(input);

                // 파일에 저장한 이름("AWS_ACCESS_KEY")으로 값을 꺼내서 변수에 저장
                this.dbPassword = prop.getProperty("AWS_ACCESS_KEY");
            } else {
                System.out.println("❌ 오류: secret.properties 파일을 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // MySQL서버연결메서드(Connection)
    public Connection getDBConnect() {
        Connection conn = null;
        try {
            // ★ "aws비밀번호" 대신 위에서 읽어온 this.dbPassword 변수를 넣습니다.
            conn = DriverManager.getConnection(MYSQL_URL, "adminhee", this.dbPassword);

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
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}