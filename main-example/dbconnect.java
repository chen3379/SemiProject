package mysql.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DbConnect {

    static final String MYSQLDRIVER = "com.mysql.cj.jdbc.Driver";
    static final String MYSQL_URL = "jdbc:mysql://myhee.che2a2mk0gqm.ap-northeast-2.rds.amazonaws.com:3306/moviereview";

    public DbConnect() {
        try {
            Class.forName(MYSQLDRIVER);
            System.out.println("MYSQL 드라이버 성공");
        } catch (ClassNotFoundException e) {
            System.out.println("MYSQL 드라이버 실패");
        }
    }

    // 오라클서버 연결 (connection)

    public Connection getDbConnect() {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(MYSQL_URL, "adminhee", "awsSIST2025");
            System.out.println("MYSQL 서버 연결");
        } catch (SQLException e) {
            System.out.println("MYSQL 서버 연결 실패" + e.getMessage());
        }
        return conn;
    }

    public void executeInsertSql(String sql) {
        try (Connection conn = getDbConnect(); Statement stmt = conn.createStatement();) {
            stmt.execute(sql);
        } catch (Exception e) {
            System.out.println("오류" + e.getMessage());
        }
    }

    public void executeSelectSql(String sql) {
        try (Connection conn = getDbConnect();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);) {
            while (rs.next()) {
                System.out.println(rs.getInt("num") + "\t" + rs.getString("name") + "\t" + rs.getInt("age") + "\t"
                        + rs.getDate("writeday"));
            }
        } catch (Exception e) {
            System.out.println("오류" + e.getMessage());
        }
    }

    public void executeDeleteSql(String sql) {
        try (Connection conn = getDbConnect(); Statement stmt = conn.createStatement();) {
            int a = stmt.executeUpdate(sql);
            if (a == 0) {
                System.out.println("없는 테이터 번호");
            } else {
                System.out.println("삭제되었습니다");
            }

        } catch (Exception e) {
            System.out.println("오류" + e.getMessage());
        }
    }

    // 1. 수정하려는 데이터 조회
    // 데이터를 조회하여 여부를 파악하는 메서드
    public boolean executeCheckData(int num) {
        boolean flag = false;

        String sql = "select * from hello where num =" + num;

        try (Connection conn = getDbConnect();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                flag = true;
            } else {
                flag = false;
            }
        } catch (Exception e) {
            System.out.println("오류" + e.getMessage());
        }

        return flag;
    }

    // 2. 수정

    public void executeUpdateSql(String sql) {
        try (Connection conn = getDbConnect(); Statement stmt = conn.createStatement();) {
            stmt.execute(sql);
            System.out.println("수정됨");
        } catch (Exception e) {
            System.out.println("오류" + e.getMessage());
        }
    }

    // db 닫기

    public void dbClose(Connection conn, Statement stmt, ResultSet rs) {
        try {
            if (rs != null)
                rs.close();
            if (stmt != null)
                stmt.close();
            if (conn != null)
                conn.close();
        } catch (SQLException e) {
            e.printStackTrace(); // 닫는 도중 발생한 예외를 출력
        }
    }

}
