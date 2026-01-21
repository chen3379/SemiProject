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

    // 1. 모든 회원 조회 (정렬 파라미터 포함)
    public List<MemberDto> selectAllMemberbyId(String sort) {
        List<MemberDto> memberList = new ArrayList<>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select * from member ";
        if ("name".equals(sort)) {
            sql += "order by name asc";
        } else {
            sql += "order by member_idx desc"; // 최신순 (기본값)
        }

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MemberDto dto = new MemberDto();
                // 모든 필드 세팅
                dto.setMemberIdx(rs.getInt("member_idx"));
                dto.setId(rs.getString("id"));
                dto.setRoleType(rs.getString("role_type"));
                dto.setStatus(rs.getString("status"));
                dto.setJoinType(rs.getString("join_type"));
                dto.setNickname(rs.getString("nickname"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setAge(rs.getInt("age"));
                dto.setName(rs.getString("name"));
                dto.setGender(rs.getString("gender"));
                dto.setHp(rs.getString("hp"));
                dto.setAddr(rs.getString("addr"));
                dto.setPhoto(rs.getString("photo"));
                memberList.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return memberList;
    }

    // 2. 검색 메서드 (닉네임/아이디 기준 및 모든 필드 로드)
    public List<MemberDto> selectSearchMembers(String search) {
        List<MemberDto> memberList = new ArrayList<>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select * from member where nickname like ? or id like ? order by member_idx desc";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + search + "%");
            pstmt.setString(2, "%" + search + "%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                MemberDto dto = new MemberDto();
                // JSP 화면 출력을 위해 모든 필드 세팅 (누락 금지)
                dto.setMemberIdx(rs.getInt("member_idx"));
                dto.setId(rs.getString("id"));
                dto.setRoleType(rs.getString("role_type"));
                dto.setStatus(rs.getString("status"));
                dto.setJoinType(rs.getString("join_type"));
                dto.setNickname(rs.getString("nickname"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setUpdateDay(rs.getTimestamp("update_day"));
                dto.setAge(rs.getInt("age"));
                dto.setName(rs.getString("name"));
                dto.setGender(rs.getString("gender"));
                dto.setHp(rs.getString("hp"));
                dto.setAddr(rs.getString("addr"));
                dto.setPhoto(rs.getString("photo"));
                memberList.add(dto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return memberList;
    }

    // 3. 어드민 정보 수정 (이메일 제외 버전)
public boolean updateMemberByAdminFull(MemberDto dto) {
    boolean success = false;
    Connection conn = db.getDBConnect();
    PreparedStatement pstmt = null;

    // SQL문 작성 (이메일 제외, 총 9개 필드 + update_day)
    String sql = "UPDATE member SET role_type=?, status=?, join_type=?, name=?, nickname=?, hp=?, gender=?, age=?, addr=?, update_day=now()";
    
    // 사진이 있을 경우만 photo 컬럼 추가
    if (dto.getPhoto() != null) {
        sql += ", photo=?";
    }
    sql += " WHERE id=?";

    try {
        pstmt = conn.prepareStatement(sql);
        
        // 순서대로 매핑 (1~9번)
        pstmt.setString(1, dto.getRoleType());
        pstmt.setString(2, dto.getStatus());
        pstmt.setString(3, dto.getJoinType());
        pstmt.setString(4, dto.getName());
        pstmt.setString(5, dto.getNickname());
        pstmt.setString(6, dto.getHp());
        pstmt.setString(7, dto.getGender());
        pstmt.setInt(8, dto.getAge());
        pstmt.setString(9, dto.getAddr());

        if (dto.getPhoto() != null) {
            // 사진이 있는 경우: photo는 10번, id는 11번
            pstmt.setString(10, dto.getPhoto());
            pstmt.setString(11, dto.getId());
        } else {
            // 사진이 없는 경우: id는 10번
            pstmt.setString(10, dto.getId());
        }

        int result = pstmt.executeUpdate();
        if (result == 1) success = true;
        
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // 기존 메서드들과 형식을 맞춰 rs가 없는 닫기 메서드 호출
        db.dbClose(null, pstmt, conn); 
    }
    return success;
}

}
