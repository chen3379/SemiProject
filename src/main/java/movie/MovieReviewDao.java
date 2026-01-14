package movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class MovieReviewDao {
	
	DBConnect db=new DBConnect();
	
	//insert
	public void insertReview(MovieReviewDto dto)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		
		String sql="insert into movie_review (id, content, create_day) values(?,?,now())";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getContent());
			pstmt.setTimestamp(3, dto.getCreateDay());
			
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(null, pstmt, conn);
		}
	}
	
	//한줄평 전체 select
	public List<MovieReviewDto> getAllReviews(int movieIdx)
	{
		List<MovieReviewDto> list=new ArrayList<MovieReviewDto>();
		
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from movie_review where movie_idx=? order by review_idx desc";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			
			rs=pstmt.executeQuery();
			
			while(rs.next())
			{
				MovieReviewDto dto=new MovieReviewDto();
				
				dto.setReviewIdx(rs.getInt("review_idx"));
				dto.setMovieIdx(rs.getInt("movie_idx"));
				dto.setId(rs.getString("id"));
				dto.setContent(rs.getString("content"));
				dto.setCreateDay(rs.getTimestamp("create_day"));
				
				list.add(dto);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}
	
	//한줄평갯수
	public int totalReview(int movieIdx) 
	{	
		int total=0;
		
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select count(*) from movie_review where movie_idx=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, movieIdx);
			
			rs=pstmt.executeQuery();
			
			if(rs.next())
			{
				total=rs.getInt(1);
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return total;
		
	}
	
	//한줄편삭제
	public void deleteReview(int movieIdx)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		
		String sql="delete from movie_review where movie_idx=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, movieIdx);
			
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(null, pstmt, conn);
		}
	}
	
	//한줄평수정 update
	public void updateReview(MovieReviewDto dto)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		
		String sql="update movie_review set (id, content, update_day) values(?,?,now())";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getContent());
			pstmt.setTimestamp(3, dto.getUpdateDay());
			
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(null, pstmt, conn);
		}
	}
	
}