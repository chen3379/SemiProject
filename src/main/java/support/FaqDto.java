package support;

import java.sql.Timestamp;

public class FaqDto {
	
	private int fagIdx;
	private String title;
	private String content;
	private String activeType; //0:N, 1:Y
	private Timestamp createDay;
	private String createId;
	private Timestamp updateDay;
	private String updateId;
	
	public int getFagIdx() {
		return fagIdx;
	}
	public void setFagIdx(int fagIdx) {
		this.fagIdx = fagIdx;
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
	public String getActiveType() {
		return activeType;
	}
	public void setActiveType(String activeType) {
		this.activeType = activeType;
	}
	public Timestamp getCreateDay() {
		return createDay;
	}
	public void setCreateDay(Timestamp createDay) {
		this.createDay = createDay;
	}
	public String getCreateId() {
		return createId;
	}
	public void setCreateId(String createId) {
		this.createId = createId;
	}
	public Timestamp getUpdateDay() {
		return updateDay;
	}
	public void setUpdateDay(Timestamp updateDay) {
		this.updateDay = updateDay;
	}
	public String getUpdateId() {
		return updateId;
	}
	public void setUpdateId(String updateId) {
		this.updateId = updateId;
	}
}
