package movie;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class MovieRatingDto {

	private int ratingIdx;
	private int movieIdx;
	private String id;
	private BigDecimal score;
	private Timestamp createDay;
	private Timestamp updateDay;
	
	
	public int getRatingIdx() {
		return ratingIdx;
	}
	public void setRatingIdx(int ratingIdx) {
		this.ratingIdx = ratingIdx;
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
	public BigDecimal getScore() {
		return score;
	}
	public void setScore(BigDecimal score) {
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
