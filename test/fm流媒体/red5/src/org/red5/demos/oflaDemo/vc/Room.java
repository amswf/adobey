package org.red5.demos.oflaDemo.vc;

import java.util.Vector;

/**
 * 房间
 * 
 * @author Administrator
 * 
 */
public class Room {

	/**
	 * 坐位列表
	 */
	private Vector<Seat> seatList = new Vector<Seat>();

	private String roomName;

	/**
	 * 最大坐位数
	 */
	private int maxSeatCount;

	public Vector<Seat> getSeatList() {
		return seatList;
	}

	public void setMaxSeatCount(int maxSeatCount) {
		this.maxSeatCount = maxSeatCount;
	}

	public int getMaxSeatCount() {
		return maxSeatCount;
	}

	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}

	public String getRoomName() {
		return roomName;
	}

	public void addSeat(Seat seat) {
		this.seatList.add(seat);
	}

	public Seat getSeatByClientId(String clientId) {
		Seat seat = null;
		for (int i = 0; i < seatList.size(); i++) {
			Seat st = seatList.get(i);
			if (clientId != null && clientId.equals(st.getClientId())) {
				seat = st;
				break;
			}
		}
		return seat;
	}
	
	public Seat getSeatByVideoName(String videoName) {
		Seat seat = null;
		for (int i = 0; i < seatList.size(); i++) {
			Seat st = seatList.get(i);
			if (videoName != null && videoName.equals(st.getVideoName())) {
				seat = st;
				break;
			}
		}
		return seat;
	}

	public void delSeatById(String clientId) {
		for (int i = 0; i < seatList.size(); i++) {
			Seat st = seatList.get(i);
			if (clientId != null && clientId.equals(st.getClientId())) {
				seatList.remove(i);
				break;
			}
		}
	}

	public void delSeat(String userName) {
		for (int i = 0; i < seatList.size(); i++) {
			Seat st = seatList.get(i);
			if (userName != null && userName.equals(st.getUserName())) {
				seatList.remove(i);
				break;
			}
		}
	}

	public Seat getSeatByIndex(int i) {
		Seat seat = null;
		if (i >= 0 && i < seatList.size()) {
			seat = seatList.get(i);
		}

		return seat;
	}

	public Seat getSeatByName(String userName) {
		Seat seat = null;
		for (int i = 0; i < seatList.size(); i++) {
			Seat st = seatList.get(i);
			if (userName != null && userName.equals(st.getUserName())) {
				seat = st;
				break;
			}
		}
		return seat;
	}

}
