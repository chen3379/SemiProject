package board.review;

import java.sql.Timestamp;

public class ReviewBoardDto {
	private int board_idx;
    private String genre_type;
    private String title;
    private String content;
    private String id;
    private boolean is_spoiler_type;
    private int readcount;
    private Timestamp create_day;
    private Timestamp update_day;
    private String nickname;
    private String filename;
    private int commentCount;
    
    public int getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(int commentCount) {
        this.commentCount = commentCount;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public Timestamp getUpdate_day() {
        return update_day;
    }
    public void setUpdate_day(Timestamp update_day) {
        this.update_day = update_day;
    }
    
    // ⭐ 관리자용 (숨김/삭제 여부)
    private int is_deleted; // 0: 정상, 1: 숨김(삭제)

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

	public int getBoard_idx() {
		return board_idx;
	}
	public void setBoard_idx(int board_idx) {
		this.board_idx = board_idx;
	}
	public String getGenre_type() {
		return genre_type;
	}
	public void setGenre_type(String genre_type) {
		this.genre_type = genre_type;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public boolean isIs_spoiler_type() {
		return is_spoiler_type;
	}
	public void setIs_spoiler_type(boolean is_spoiler_type) {
		this.is_spoiler_type = is_spoiler_type;
	}
	public int getReadcount() {
		return readcount;
	}
	public void setReadcount(int readcount) {
		this.readcount = readcount;
	}
	public Timestamp getCreate_day() {
		return create_day;
	}
	public void setCreate_day(Timestamp create_day) {
		this.create_day = create_day;
	}

	public int getIs_deleted() {
		return is_deleted;
	}

	public void setIs_deleted(int is_deleted) {
		this.is_deleted = is_deleted;
	}
    
    
}
