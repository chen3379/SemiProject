<%@page import="mysql.db.DBConnect"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="java.sql.*"%>
<%
// [Backend] DB에서 데이터 가져와서 JSON 만들기
JSONArray list = new JSONArray();

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
DBConnect db = new DBConnect();// 사용하시는 DB 클래스로 변경하세요

try {
    conn = db.getDBConnect();
    // 장르별 조회수 합계 쿼리
    String sql = "SELECT genre, SUM(readCount) as total_views FROM movie GROUP BY genre ORDER BY total_views DESC LIMIT 7";
    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();

    while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("name", rs.getString("genre")); // Highcharts는 'name' 키를 사용
        obj.put("y", rs.getInt("total_views")); // Highcharts는 값에 'y' 키를 사용
        list.add(obj);
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    db.dbClose(rs, pstmt, conn);
}

// 최종 JSON 출력
out.print(list);
%>