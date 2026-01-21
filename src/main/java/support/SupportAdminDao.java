package support;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import mysql.db.DBConnect;

public class SupportAdminDao {
	DBConnect db = new DBConnect();

    // 답변 조회
    public SupportAdminDto getAdminAnswer(int idx){
        SupportAdminDto dto=new SupportAdminDto();
        
        Connection conn=db.getDBConnect();
        PreparedStatement pstmt=null;
        ResultSet rs=null;
        
        String sql="select * from support_admin where support_idx=?";

        try{
            pstmt=conn.prepareStatement(sql);
            
            pstmt.setInt(1, idx);
            
            rs=pstmt.executeQuery();
            
            if(rs.next()){
                dto.setContent(rs.getString("content"));
                dto.setId(rs.getString("id"));
            }
            
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            db.dbClose(rs,pstmt,conn);
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
    public void deleteAnswer(int supportIdx){

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
}
