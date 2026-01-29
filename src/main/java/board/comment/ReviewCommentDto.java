package board.comment;

import java.sql.Timestamp;

public class ReviewCommentDto {
	private int comment_idx;
    private int board_idx;
    private String writer_id;
    private String content;
    private int parent_comment_idx;
    private Timestamp create_day;
    private Timestamp update_day;
    private String create_id;
    private String update_id;
    private int is_deleted;
    
	public int getComment_idx() {
		return comment_idx;
	}
	public void setComment_idx(int comment_idx) {
		this.comment_idx = comment_idx;
	}
	public int getBoard_idx() {
		return board_idx;
	}
	public void setBoard_idx(int board_idx) {
		this.board_idx = board_idx;
	}
	public String getWriter_id() {
		return writer_id;
	}
	public void setWriter_id(String writer_id) {
		this.writer_id = writer_id;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getParent_comment_idx() {
		return parent_comment_idx;
	}
	public void setParent_comment_idx(int parent_comment_idx) {
		this.parent_comment_idx = parent_comment_idx;
	}
	public Timestamp getCreate_day() {
		return create_day;
	}
	public void setCreate_day(Timestamp create_day) {
		this.create_day = create_day;
	}
	public Timestamp getUpdate_day() {
		return update_day;
	}
	public void setUpdate_day(Timestamp update_day) {
		this.update_day = update_day;
	}
	public String getCreate_id() {
		return create_id;
	}
	public void setCreate_id(String create_id) {
		this.create_id = create_id;
	}
	public String getUpdate_id() {
		return update_id;
	}
	public void setUpdate_id(String update_id) {
		this.update_id = update_id;
	}
	public int getIs_deleted() {
		return is_deleted;
	}
	public void setIs_deleted(int is_deleted) {
		this.is_deleted = is_deleted;
	}
    
    
}
