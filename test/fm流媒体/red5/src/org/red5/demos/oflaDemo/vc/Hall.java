package org.red5.demos.oflaDemo.vc;

import java.util.Vector;

/**
 * 视频大厅
 * 
 * @author Administrator
 * 
 */
public class Hall {

	/**
	 * 房间列表
	 */
	private Vector<Room> roomList = new Vector<Room>();

	public void addRoom(Room room) {
		roomList.add(room);
	}

	public Vector<Room> getRoomList() {
		return roomList;
	}

	public Room getRoomByIndex(int i) {
		Room room = null;
		if (i >= 0 && i < roomList.size()) {
			room = roomList.get(i);
		}
		return room;
	}
	
	public Room getRoomByName(String roomName) {
		Room room = null;
		for(int i = 0;i<roomList.size();i++){
			Room rm = roomList.get(i);
			if(roomName != null && roomName.equals(rm.getRoomName())){
				room = rm;
			}
		}
		return room;
	}

}
