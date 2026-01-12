package login;

import java.sql.Timestamp;

public class MemberDto {
	// member table
	
	private String id;
	private String nickname;
	private String pass;
	private String roleType;
	private Timestamp signupDay;
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getRoleType() {
		return roleType;
	}
	public void setRoleType(String roleType) {
		this.roleType = roleType;
	}
	public Timestamp getSignupDay() {
		return signupDay;
	}
	public void setSignupDay(Timestamp signupDay) {
		this.signupDay = signupDay;
	}

	
	
}
