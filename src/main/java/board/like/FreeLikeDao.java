package board.like;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DBConnect;

public class FreeLikeDao {
	DBConnect db= new DBConnect();
	
	public boolean isLike(int board_idx, String id) {
		   boolean result = false;
		   Connection conn=db.getDBConnect();
		   PreparedStatement pstmt=null;
		   ResultSet rs=null;
		   
		   String sql="select count(*) from free_like where board_idx=? and id=?";
		   
		   conn=db.getDBConnect();
		   try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, board_idx);
			pstmt.setString(2, id);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				result=rs.getInt(1)>0;
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		   
		   return result;
	}
}
