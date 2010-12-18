package org.red5.demos.oflaDemo.vc;

import java.util.Vector;

/**
 * ����
 * 
 * @author Administrator
 * 
 */
public class Room {

	/**
	 * ��λ�б�
	 */
	private Vector<Seat> seatList = new Vector<Seat>();

	private String roomName;

	/**
	 * �����λ��
	 */
	private int maxSeatCount;

	public void addSeat(Seat seat) {
		this.seatList.add(seat);
	}

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

	public Seat getSeatByIndex(int i) {
		Seat seat = null;
		if (i >= 0 && i < seatList.size()) {
			seat = seatList.get(i);
		}
		return seat;
	}

}
