package codemaster;

import java.sql.Timestamp;

public class CodeDto {

	private String group_code;
	private String group_name;
	private String code_id;
	private String code_name;
	private int sort_order;
	private String use_yn;
	private String create_id;
	private Timestamp create_day;
	private String update_id;
	private Timestamp update_day;
	public String getGroup_code() {
		return group_code;
	}
	public void setGroup_code(String group_code) {
		this.group_code = group_code;
	}
	public String getGroup_name() {
		return group_name;
	}
	public void setGroup_name(String group_name) {
		this.group_name = group_name;
	}
	public String getCode_id() {
		return code_id;
	}
	public void setCode_id(String code_id) {
		this.code_id = code_id;
	}
	public String getCode_name() {
		return code_name;
	}
	public void setCode_name(String code_name) {
		this.code_name = code_name;
	}
	public int getSort_order() {
		return sort_order;
	}
	public void setSort_order(int sort_order) {
		this.sort_order = sort_order;
	}
	public String getUse_yn() {
		return use_yn;
	}
	public void setUse_yn(String use_yn) {
		this.use_yn = use_yn;
	}
	public String getCreate_id() {
		return create_id;
	}
	public void setCreate_id(String create_id) {
		this.create_id = create_id;
	}
	public Timestamp getCreate_day() {
		return create_day;
	}
	public void setCreate_day(Timestamp create_day) {
		this.create_day = create_day;
	}
	public String getUpdate_id() {
		return update_id;
	}
	public void setUpdate_id(String update_id) {
		this.update_id = update_id;
	}
	public Timestamp getUpdate_day() {
		return update_day;
	}
	public void setUpdate_day(Timestamp update_day) {
		this.update_day = update_day;
	}
	
}
