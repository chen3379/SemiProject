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
	public boolean insertReview(MovieReviewDto dto)
	{
	    Connection conn = db.getDBConnect();
	    PreparedStatement pstmt = null;

	    String sql = "insert into movie_review (movie_idx, id, content, create_day) values (?,?,?,now())";

	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, dto.getMovieIdx());
	        pstmt.setString(2, dto.getId());
	        pstmt.setString(3, dto.getContent());

	        int n = pstmt.executeUpdate();
	        return n > 0;

	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    } finally {
	        db.dbClose(null, pstmt, conn);
	    }
	}
	
	//리뷰+별점 같이 가져오기 (join)
	public List<MovieReviewDto> getAllReviewsWithScore(int movieIdx)
	{
	    List<MovieReviewDto> list = new ArrayList<>();

	    Connection conn = db.getDBConnect();
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql =
	      "select r.review_idx, r.movie_idx, r.id, r.content, r.create_day, " +
	      "       ifnull(rt.score, 0) as score " +
	      "from movie_review r " +
	      "left join movie_rating rt on r.movie_idx=rt.movie_idx and r.id=rt.id " +
	      "where r.movie_idx=? " +
	      "order by r.review_idx desc";

	    try {
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, movieIdx);
	        rs = pstmt.executeQuery();

	        while(rs.next()){
	            MovieReviewDto dto = new MovieReviewDto();
	            dto.setReviewIdx(rs.getInt("review_idx"));
	            dto.setMovieIdx(rs.getInt("movie_idx"));
	            dto.setId(rs.getString("id"));
	            dto.setContent(rs.getString("content"));
	            dto.setCreateDay(rs.getTimestamp("create_day"));
	            dto.setScore(rs.getBigDecimal("score")); // dto에 score 필드 필요
	            list.add(dto);
	        }
	    } catch(SQLException e){
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
	public void deleteReview(int reviewIdx)
	{
		Connection conn=db.getDBConnect();
		PreparedStatement pstmt=null;
		
		String sql="delete from movie_review where review_idx=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setInt(1, reviewIdx);
			
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
		
		String sql="update movie_review set content=?, update_day=now() where review_idx=?";
		
		try {
			pstmt=conn.prepareStatement(sql);
			
			pstmt.setString(1, dto.getContent());
	        pstmt.setInt(2, dto.getReviewIdx());
			
			pstmt.executeUpdate();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			db.dbClose(null, pstmt, conn);
		}
	}
	
}