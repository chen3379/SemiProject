package support;

import java.sql.Timestamp;

public class SupportAdminDto {
	private int supportAdminIdx;
	private int supportIdx;
	private String id;
	private String content;
	private Timestamp createDay;
	private Timestamp updateDay;
	private String createId;
	private String updateId;
	
	public int getSupportAdminIdx() {
		return supportAdminIdx;
	}
	public void setSupportAdminIdx(int supportAdminIdx) {
		this.supportAdminIdx = supportAdminIdx;
	}
	public int getSupportIdx() {
		return supportIdx;
	}
	public void setSupportIdx(int supportIdx) {
		this.supportIdx = supportIdx;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
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
