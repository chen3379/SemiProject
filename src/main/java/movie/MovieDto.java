package movie;

import java.sql.Date;
import java.sql.Timestamp;

public class MovieDto {

	private int movieIdx;
	private String movieId;
	private String title;
	private String releaseDay;
	private String genre;
	private String country;
	private String director;
	private String cast;
	private String summary;
	private String posterPath;
	private String trailerUrl;
	private Timestamp createDay;
	private Timestamp updateDay;
	private int readcount;
	private String createId;
	private String updateId;

	public int getMovieIdx() {
		return movieIdx;
	}

	public void setMovieIdx(int movieIdx) {
		this.movieIdx = movieIdx;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getReleaseDay() {
		return releaseDay;
	}

	public void setReleaseDay(String releaseDay) {
		this.releaseDay = releaseDay;
	}

	public String getGenre() {
		return genre;
	}

	public void setGenre(String genre) {
		this.genre = genre;
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getDirector() {
		return director;
	}

	public void setDirector(String director) {
		this.director = director;
	}

	public String getCast() {
		return cast;
	}

	public void setCast(String cast) {
		this.cast = cast;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public String getPosterPath() {
		return posterPath;
	}

	public void setPosterPath(String posterPath) {
		this.posterPath = posterPath;
	}

	public String getTrailerUrl() {
		return trailerUrl;
	}

	public void setTrailerUrl(String trailerUrl) {
		this.trailerUrl = trailerUrl;
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

	public int getReadcount() {
		return readcount;
	}

	public void setReadcount(int readcount) {
		this.readcount = readcount;
	}

	public String getMovieId() {
		return movieId;
	}

	public void setMovieId(String movieId) {
		this.movieId = movieId;
	}

	public String getCreateId() {
		return createId;
	}

	public void setCreateId(String createId) {
		this.createId = createId;
	}

	public String getUpdateId() {
		return updateId;
	}

	public void setUpdateId(String updateId) {
		this.updateId = updateId;
	}
}
