package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class AdminDao {

    DBConnect db = new DBConnect();
 
    // selectAllMemberbyId 모든 회원 조회(관리자용)
    public List<MemberDto> selectAllMemberbyId() {

        List<MemberDto> memberList = new ArrayList<>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        MemberDto memberDto = null;
        String sql = "select * from member order by idx desc";

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                memberDto = new MemberDto();
                memberDto.setMemberIdx(rs.getInt("member_idx"));
                memberDto.setId(rs.getString("id"));
                memberDto.setRoleType(rs.getString("role_type"));
                memberDto.setStatus(rs.getString("status"));
                memberDto.setJoinType(rs.getString("join_type"));
                memberDto.setNickname(rs.getString("nickname"));
                memberDto.setCreateDay(rs.getTimestamp("create_day"));
                memberDto.setUpdateDay(rs.getTimestamp("update_day"));
                memberDto.setAge(rs.getInt("age"));
                memberDto.setName(rs.getString("name"));
                memberDto.setGender(rs.getString("gender"));
                memberDto.setHp(rs.getString("hp"));
                memberDto.setAddr(rs.getString("addr"));
                memberDto.setPhoto(rs.getString("photo"));


                memberList.add(memberDto);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return memberList;
        } finally {
            db.dbClose(rs, pstmt, conn);
        } return memberList;
    }   

    // updateRoleType 권한 수정
}