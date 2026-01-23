package support;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class SupportDao {
	 DBConnect db = new DBConnect();

	    // 문의글 목록 + 필터
	    public List<SupportDto> getList(String status, String order, String categoryType) {
	        List<SupportDto> list = new ArrayList<SupportDto>();
	        
	        Connection conn = db.getDBConnect();
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        
	        String sql ="select * from support";

	        // 문의유형 필터
	        if (categoryType != null && !categoryType.equals("")) {
	            sql += " where category_type = ?";
	        }
	        
	        // 답변상태 필터
	        if(status != null && !status.isEmpty()){
	            sql += " and status_type=? ";
	        }
	        
	        // 정렬
	        if("old".equals(order)){
	            sql += " order by support_idx asc";
	        } else {
	            sql += " order by support_idx desc";
	        }

	        try {
	            pstmt = conn.prepareStatement(sql);
	            
	            int idx = 1;
	            
	            if (categoryType != null && !categoryType.equals("")) {
	            	pstmt.setString(idx++, categoryType);
	            }
	            
	            if(status != null && !status.isEmpty()){
	            	pstmt.setString(idx++, status);
	            }

	            rs = pstmt.executeQuery();
	            
	            while(rs.next()){
	            	
	                SupportDto dto = new SupportDto();
	                
	                dto.setSupportIdx(rs.getInt("support_idx"));
	                dto.setCategoryType(rs.getString("category_type"));
	                dto.setTitle(rs.getString("title"));
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

	    // 상세 조회
	    public SupportDto getOneData(int supportIdx){
	    	SupportDto dto = new SupportDto();
	    	
	        Connection conn = db.getDBConnect();
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        String sql="select * from support where support_idx=?";

	        try {
	            pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setInt(1, supportIdx);
	            
	            rs = pstmt.executeQuery();
	            
	            if(rs.next()){
	            	
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
	                
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            db.dbClose(rs, pstmt, conn);
	        }
	        return dto;
	    }

	    // 조회수 증가
	    public void updateReadCount(int supportIdx){
	        Connection conn = db.getDBConnect();
	        PreparedStatement pstmt = null;
	        
	        String sql="update support set readcount=readcount+1 where support_idx=?";

	        try {
	        	pstmt = conn.prepareStatement(sql);
	            
	            pstmt.setInt(1, supportIdx);
	            
	            pstmt.executeUpdate();
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            db.dbClose(null, pstmt, conn);
	        }
	    }

	    // 문의글 등록
	    public boolean insertSupport(String categoryType,String title,String content,String id,int secretType
	    	){
	    	    Connection conn = db.getDBConnect();
	    	    PreparedStatement pstmt = null;

	    	    String sql =
	    	        "insert into support " +
	    	        "(category_type, title, content, id, secret_type, create_day) " +
	    	        "values (?,?,?,?,?,now())";

	    	    try {
	    	        pstmt = conn.prepareStatement(sql);
	    	        pstmt.setString(1, categoryType);
	    	        pstmt.setString(2, title);
	    	        pstmt.setString(3, content);
	    	        pstmt.setString(4, id);
	    	        pstmt.setInt(5, secretType);

	    	        return pstmt.executeUpdate() > 0;

	    	    } catch (Exception e) {
	    	        e.printStackTrace();
	    	        return false;
	    	    } finally {
	    	        db.dbClose(null, pstmt, conn);
	    	    }
	    	}

	    // 문의글 삭제
	    public void deleteSupport(int supportIdx){
	        Connection conn=db.getDBConnect();
	        PreparedStatement pstmt=null;
	        
	        String sql="update support set delete_type='1' where support_idx=?";

	        try{
	            pstmt=conn.prepareStatement(sql);
	            
	            pstmt.setInt(1, supportIdx);
	            
	            pstmt.executeUpdate();
	            
	        }catch(Exception e){
	            e.printStackTrace();
	        }finally{
	            db.dbClose(null,pstmt,conn);
	        }
	    }
	    
	    // 문의글 수정
	    public boolean updateSupport(int supportIdx,String categoryType,String title,String content,int secretType
	    	){
	    	    Connection conn = db.getDBConnect();
	    	    PreparedStatement pstmt = null;

	    	    String sql =
	    	        "update support set " +
	    	        "category_type=?, title=?, content=?, secret_type=?, update_day=now() " +
	    	        "where support_idx=?";

	    	    try {
	    	        pstmt = conn.prepareStatement(sql);
	    	        pstmt.setString(1, categoryType);
	    	        pstmt.setString(2, title);
	    	        pstmt.setString(3, content);
	    	        pstmt.setInt(4, secretType);
	    	        pstmt.setInt(5, supportIdx);

	    	        return pstmt.executeUpdate() > 0;

	    	    } catch (Exception e) {
	    	        e.printStackTrace();
	    	        return false;
	    	    } finally {
	    	        db.dbClose(null, pstmt, conn);
	    	    }
	    	}



	    // 답변상태 변경
	    public void updateStatus(int supportIdx,String status){
	        Connection conn=db.getDBConnect();
	        PreparedStatement pstmt=null;
	        
	        String sql="update support set status_type=? where support_idx=?";

	        try{	        	
	            pstmt=conn.prepareStatement(sql);
	            
	            pstmt.setString(1, status);
	            pstmt.setInt(2, supportIdx);
	            
	            pstmt.executeUpdate();
	            
	        }catch(Exception e){
	            e.printStackTrace();
	        }finally{
	            db.dbClose(null,pstmt,conn);
	        }
	    }
	    
	    // (페이징용) 전체 글 갯수
	    public int getTotalCount(String status, String categoryType) {
	        int total = 0;

	        Connection conn = db.getDBConnect();
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        // 4가지 경우(둘 다 없음 / category만 / status만 / category+status)
	        String sql;

	        boolean hasCategory = (categoryType != null && !categoryType.trim().isEmpty());
	        boolean hasStatus = (status != null && !status.trim().isEmpty());

	        if (!hasCategory && !hasStatus) {
	            sql = "select count(*) from support";
	        } else if (hasCategory && !hasStatus) {
	            sql = "select count(*) from support where category_type=?";
	        } else if (!hasCategory && hasStatus) {
	            sql = "select count(*) from support where status_type=?";
	        } else {
	            sql = "select count(*) from support where category_type=? and status_type=?";
	        }

	        try {
	            pstmt = conn.prepareStatement(sql);

	            int idx = 1;
	            
	            if (hasCategory) pstmt.setString(idx++, categoryType.trim());
	            if (hasStatus) pstmt.setString(idx++, status.trim());

	            rs = pstmt.executeQuery();
	            if (rs.next()) total = rs.getInt(1);

	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            db.dbClose(rs, pstmt, conn);
	        }

	        return total;
	    }

	    
	    // (페이징용) 목록 조회
	    public List<SupportDto> getPagingList(int startNum, int perPage, String status, String categoryType) {

	        List<SupportDto> list = new ArrayList<>();

	        Connection conn = db.getDBConnect();
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;

	        // 4가지 경우(둘 다 없음 / category만 / status만 / category+status)
	        String sql;

	        boolean hasCategory = (categoryType != null && !categoryType.trim().isEmpty());
	        boolean hasStatus = (status != null && !status.trim().isEmpty());

	        if (!hasCategory && !hasStatus) {
	            sql = "select * from support order by support_idx desc limit ?, ?";
	        } else if (hasCategory && !hasStatus) {
	            sql = "select * from support where category_type=? order by support_idx desc limit ?, ?";
	        } else if (!hasCategory && hasStatus) {
	            sql = "select * from support where status_type=? order by support_idx desc limit ?, ?";
	        } else {
	            sql = "select * from support where category_type=? and status_type=? order by support_idx desc limit ?, ?";
	        }

	        try {
	            pstmt = conn.prepareStatement(sql);

	            int idx = 1;
	            if (hasCategory) pstmt.setString(idx++, categoryType.trim());
	            if (hasStatus) pstmt.setString(idx++, status.trim());

	            pstmt.setInt(idx++, startNum);  // offset
	            pstmt.setInt(idx++, perPage);   // limit

	            rs = pstmt.executeQuery();
	            while (rs.next()) {
	                SupportDto dto = new SupportDto();
	                
	                dto.setSupportIdx(rs.getInt("support_idx"));
	                dto.setCategoryType(rs.getString("category_type"));
	                dto.setTitle(rs.getString("title"));
	                dto.setId(rs.getString("id"));
	                dto.setSecretType(rs.getString("secret_type"));
	                dto.setStatusType(rs.getString("status_type"));
	                dto.setReadcount(rs.getInt("readcount"));
	                dto.setCreateDay(rs.getTimestamp("create_day"));
	                dto.setDeleteType(rs.getString("delete_type"));

	                list.add(dto);
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        } finally {
	            db.dbClose(rs, pstmt, conn);
	        }

	        return list;
	    }
	    
	    public int getAnsweredCount(String status, String categoryType){
	        Connection conn = db.getDBConnect();
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        int count = 0;

	        String sql = "select count(*) from support where status_type='1' and delete_type='0'";

	        try{
	            pstmt = conn.prepareStatement(sql);
	            rs = pstmt.executeQuery();
	            if(rs.next()) count = rs.getInt(1);
	        }catch(Exception e){
	            e.printStackTrace();
	        }finally{
	            db.dbClose(rs, pstmt, conn);
	        }
	        return count;
	    }

	    

	    
}
