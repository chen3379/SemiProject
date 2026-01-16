package movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import mysql.db.DBConnect;

public class MovieWishDao {
	
	DBConnect db = new DBConnect();

	//위시 여부 확인
	public boolean isWished(int movieIdx, String id)
	{
		boolean flag=false;
		
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from movie_wish where movie_idx=? and id=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, movieIdx);
			pstmt.setString(2, id);
			
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				flag=true;
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return flag;
	}
	
	//위시 insert
	public void insertWish(int movieIdx, String id)
	{
		//중복 방지
		if(isWished(movieIdx, id))
			return;
		
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		
		String sql="insert into movie_wish values(null,?,?,0,now(),now())";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, movieIdx);
			pstmt.setString(2, id);
			
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(null, pstmt, conn);
		}
	}
	
	//위시 delete
	public void deleteWish(int movieIdx, String id)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		
		String sql="delete from movie_wish where movie_idx=? and id=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, movieIdx);
			pstmt.setString(2, id);
			
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(null, pstmt, conn);
		}
	}
	
}
