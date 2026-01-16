package movie;

import java.sql.Timestamp;

public class MovieWishDto {

	private int wishIdx;
	private int movieIdx;
	private String id;
	private double score;
	private Timestamp createDay;
	private Timestamp updateDay;
	
	
	public int getWishIdx() {
		return wishIdx;
	}
	public void setWishIdx(int wishIdx) {
		this.wishIdx = wishIdx;
	}
	public int getMovieIdx() {
		return movieIdx;
	}
	public void setMovieIdx(int movieIdx) {
		this.movieIdx = movieIdx;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public double getScore() {
		return score;
	}
	public void setScore(double score) {
		this.score = score;
	}
	public Timestamp getCreateDay() {
		return createDay;
	}
	public void setCreateDay(Timestamp createDay) {
		this.createDay = createDay;
	}
	public Timestamp getUpdateDay() {
		return updateDay;
	}
	public void setUpdateDay(Timestamp updateDay) {
		this.updateDay = updateDay;
	}
	
}
