package member;

import java.sql.Timestamp;

public class MemberDto {
	// member table
	private int idx;
	private String id;
	private String password;
	private int roleType;
	private String status;
	private String joinType;
	private String nickname;
	private Timestamp signUpDay;
	private String email;
	private int age;
	private String name;
	private String gender;
	private String hp;
	private String addr;
	private String photo;


	public int getIdx() {
		return idx;
	}

	public String getId() {
		return id;
	}

	public String getPassword() {
		return password;
	}

	public int getRoleType() {
		return roleType;
	}

	public String getStatus() {
		return status;
	}

	public String getJoinType() {
		return joinType;
	}

	public String getNickname() {
		return nickname;
	}

	public Timestamp getSignUpDay() {
		return signUpDay;
	}

	public String getEmail() {
		return email;
	}

	public int getAge() {
		return age;
	}

	public String getName() {
		return name;
	}

	public String getGender() {
		return gender;
	}

	public String getHp() {
		return hp;
	}

	public String getAddr() {
		return addr;
	}

	public String getPhoto() {
		return photo;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public void setId(String id) {
		this.id = id;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setRoleType(int roleType) {
		this.roleType = roleType;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public void setJoinType(String joinType) {
		this.joinType = joinType;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public void setSignUpDay(Timestamp signUpDay) {
		this.signUpDay = signUpDay;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public void setHp(String hp) {
		this.hp = hp;
	}

	public void setAddr(String addr) {
		this.addr = addr;
	}

	public void setPhoto(String photo) {
		this.photo = photo;
	}

}
