package support;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class SupportAdminDao {
	DBConnect db = new DBConnect();

    // 답변 조회
	public SupportAdminDto getAdminAnswer(int supportIdx){
	    SupportAdminDto dto = null;

	    Connection conn = db.getDBConnect();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql = "select * from support_admin where support_idx=?";

	    try{
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, supportIdx);
	        rs = pstmt.executeQuery();

	        if(rs.next()){
	            dto = new SupportAdminDto();
	            dto.setSupportIdx(rs.getInt("support_idx"));
	            dto.setId(rs.getString("id"));
	            dto.setContent(rs.getString("content"));
	            dto.setCreateDay(rs.getTimestamp("create_day"));
	        }
	    }catch(Exception e){
	        e.printStackTrace();
	    }finally{
	        db.dbClose(rs, pstmt, conn);
	    }

	    return dto;
	}

    // 답변 등록
    public boolean insertAdmin(int idx,String id,String content){
        Connection conn=db.getDBConnect();
        PreparedStatement pstmt=null;

        String sql="insert into support_admin(support_idx,id,content,create_day) values(?,?,?,now())";

        try{
            pstmt=conn.prepareStatement(sql);
            
            pstmt.setInt(1, idx);
            pstmt.setString(2, id);
            pstmt.setString(3, content);
            
            pstmt.executeUpdate();

            new SupportDao().updateStatus(idx,"1");
            return true;
            
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }finally{
            db.dbClose(null,pstmt,conn);
        }
    }
    
    // 답변수정
    public void updateAdmin(int supportIdx, String content){

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql =
          "update support_admin " +
          "set content=?, update_day=now() " +
          "where support_idx=?";

        try{
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, content);
            pstmt.setInt(2, supportIdx);
            pstmt.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            db.dbClose(null, pstmt, conn);
        }
    }
    
    // 답변삭제
    public void deleteAdmin(int supportIdx){

        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "delete from support_admin where support_idx=?";

        try{
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, supportIdx);
            pstmt.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            db.dbClose(null, pstmt, conn);
        }
    }
        // 내 문의내역 조회
    public List<SupportDto> getListById(String id) {
        List<SupportDto> list = new ArrayList<SupportDto>();
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "select * from support where delete_type='0' and id = ? order by support_idx desc";

        try {
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            
            while(rs.next()){
                SupportDto dto = new SupportDto();
                dto.setSupportIdx(rs.getInt("support_idx"));
                dto.setCategoryType(rs.getString("category_type"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setId(rs.getString("id"));
                dto.setSecretType(rs.getString("secret_type"));
                dto.setDeleteType(rs.getString("delete_type"));
                dto.setStatusType(rs.getString("status_type"));
                dto.setReadcount(rs.getInt("readcount"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }
}
