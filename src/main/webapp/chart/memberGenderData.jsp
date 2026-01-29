<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*, java.sql.*, mysql.db.DBConnect" %>
<%
JSONArray list = new JSONArray();
    DBConnect db = new DBConnect();
    Connection conn = db.getDBConnect();
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 성별(gender)별 회원 수 카운트
        String sql = "SELECT gender, COUNT(*) as cnt FROM member GROUP BY gender";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while(rs.next()) {
    JSONObject obj = new JSONObject();
    String g = rs.getString("gender");
    // 화면에 보여줄 이름 변환 (M->남성, F->여성)
    if ("남".equals(g))
        obj.put("name", "남성");
    else if ("여".equals(g))
        obj.put("name", "여성");
    else
        obj.put("name", "기타");

    obj.put("y", rs.getInt("cnt"));
    list.add(obj);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        db.dbClose(rs, pstmt, conn);
    }

    out.print(list.toString());
%>