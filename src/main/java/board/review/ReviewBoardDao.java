package board.review;

import java.util.ArrayList;
import java.util.List;

import mysql.db.DBConnect;

public class ReviewBoardDao {
	DBConnect db= new DBConnect();
	
	public List<ReviewBoardDto> reviewTopList() {
	 List<ReviewBoardDto> list = new ArrayList<>();
	    String sql = "SELECT *  FROM review_board ORDER BY like_count DESC, create_day DESC LIMIT 10 ";
	    return list;
	}
}
