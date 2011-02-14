package org.red5.demos.oflaDemo.vc;


public class Seat {
	
	/***
	 * 客户端ID
	 */
	private String clientId;
	
	/**
	 * 视频地址
	 */
	private String videoName;
	
	/**
	 * 用户名
	 */
	private String userName;
	
	/**
	 * 登录验证串
	 */
	private String checklogin;
	
	/**
	 * 用户类型
	 */
	private String userType;

	public String getVideoName() {
		return videoName;
	}

	public void setVideoName(String videoName) {
		this.videoName = videoName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getChecklogin() {
		return checklogin;
	}

	public void setChecklogin(String checklogin) {
		this.checklogin = checklogin;
	}

	public String getClientId() {
		return clientId;
	}

	public void setClientId(String clientId) {
		this.clientId = clientId;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}
	
}
