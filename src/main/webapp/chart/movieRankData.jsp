<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*, java.sql.*, mysql.db.DBConnect"%>
<%
// [주의] 막대 차트는 '카테고리(영화제목)' 배열과 '데이터(조회수)' 배열을 따로 줘야 편합니다.
JSONObject result = new JSONObject();
JSONArray titles = new JSONArray(); // x축 (영화 제목)
JSONArray views = new JSONArray(); // y축 (조회수)

DBConnect db = new DBConnect();
Connection conn = db.getDBConnect();
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    // 조회수(readcount) 높은 순으로 5개
    String sql = "SELECT title, readcount FROM movie ORDER BY readcount DESC LIMIT 5";
    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();

    while (rs.next()) {
        titles.add(rs.getString("title"));
        views.add(rs.getInt("readcount"));
    }
    result.put("titles", titles);
    result.put("views", views);

} catch (Exception e) {
    e.printStackTrace();
} finally {
    db.dbClose(rs, pstmt, conn);
}

out.print(result.toString());
%>