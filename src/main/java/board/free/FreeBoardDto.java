package board.free;

import java.sql.Timestamp;

public class FreeBoardDto {

    private int board_idx;
    private String category_type;
    private String title;
    private String content;
    private String id; // 작성자
    private boolean is_spoiler_type;
    private int readcount;
    private Timestamp create_day;
    private Timestamp update_day;
    private String create_id;
    private String update_id;
    private String nickname;
    private String filename;

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    // ⭐ 관리자용 (숨김/삭제 여부)
    private int is_deleted; // 0: 정상, 1: 숨김(삭제)

    public int getBoard_idx() {
        return board_idx;
    }

    public void setBoard_idx(int board_idx) {
        this.board_idx = board_idx;
    }

    public String getCategory_type() {
        return category_type;
    }

    public void setCategory_type(String category_type) {
        this.category_type = category_type;
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

    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }
}
