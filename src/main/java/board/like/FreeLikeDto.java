package board.like;

import java.sql.Timestamp;

public class FreeLikeDto {
    private int like_idx;        // PK (있으면 사용)
    private int board_idx;       // 게시글 번호
    private String id;           // 좋아요 누른 사용자 ID
    private Timestamp create_day; // 좋아요 누른 시간
    
	public int getLike_idx() {
		return like_idx;
	}
	public void setLike_idx(int like_idx) {
		this.like_idx = like_idx;
	}
	public int getBoard_idx() {
		return board_idx;
	}
	public void setBoard_idx(int board_idx) {
		this.board_idx = board_idx;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Timestamp getCreate_day() {
		return create_day;
	}
	public void setCreate_day(Timestamp create_day) {
		this.create_day = create_day;
	}
    
    
}
