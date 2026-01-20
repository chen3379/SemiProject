package support;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class FaqDao {
    DBConnect db = new DBConnect();

    //메인 노출용 FAQ 목록
    public List<FaqDto> getActiveFaq() {
        List<FaqDto> list = new ArrayList<FaqDto>();
        
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql ="select * from faq_board where active_type='1' order by faq_idx asc";

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                FaqDto dto = new FaqDto();
                
                dto.setFaqIdx(rs.getInt("faq_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setActiveType(rs.getString("active_type"));
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

    //관리자용 FAQ 전체 목록
    public List<FaqDto> getAllFaq() {
        List<FaqDto> list = new ArrayList<>();
        
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select * from faq_board order by faq_idx desc";

        try {
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                FaqDto dto = new FaqDto();
                
                dto.setFaqIdx(rs.getInt("faq_idx"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setActiveType(rs.getString("active_type"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                dto.setCreateId(rs.getString("create_id"));
                
                list.add(dto);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return list;
    }

    // FAQ 1건 조회 (수정용)
    public FaqDto getOneData(int idx) {
        FaqDto dto = new FaqDto();
        
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "select * from faq_board where faq_idx=?";

        try {
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setInt(1, idx);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
            	
                dto.setFaqIdx(idx);
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setActiveType(rs.getString("active_type"));
                dto.setCreateDay(rs.getTimestamp("create_day"));
                
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, conn);
        }
        return dto;
    }

    //FAQ 등록 (관리자)
    public void insertFaq(FaqDto dto) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "insert into faq_board(title,content,active_type,create_day,create_id) " +
          "values(?,?,?,now(),?)";

        try {
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getActiveType());
            pstmt.setString(4, dto.getCreateId());
            
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    //FAQ 수정
    public void updateFaq(FaqDto dto) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "update faq_board set title=?, content=?, active_type=?, update_day=now(), update_id=? where faq_idx=?";

        try {
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getContent());
            pstmt.setString(3, dto.getActiveType());
            pstmt.setString(4, dto.getUpdateId());
            pstmt.setInt(5, dto.getFaqIdx());
            
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }

    //FAQ 노출/비노출 토글
    public void updateActive(int idx, String activeType) {
        Connection conn = db.getDBConnect();
        PreparedStatement pstmt = null;

        String sql = "update faq_board set active_type=?, update_day=now() where faq_idx=?";

        try {
            pstmt = conn.prepareStatement(sql);
            
            pstmt.setString(1, activeType);
            pstmt.setInt(2, idx);
            
            pstmt.executeUpdate();
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(null, pstmt, conn);
        }
    }
}
