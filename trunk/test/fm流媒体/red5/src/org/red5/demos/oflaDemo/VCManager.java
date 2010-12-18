package org.red5.demos.oflaDemo;

import org.red5.demos.oflaDemo.vc.Hall;
import org.red5.demos.oflaDemo.vc.Room;

public class VCManager {

	private static VCManager vcm = new VCManager();

	private Hall hall = new Hall();

	private VCManager() {
		Room roomOne = new Room();
		roomOne.setRoomName("one");
		hall.addRoom(roomOne);

		Room roomTwo = new Room();
		roomTwo.setRoomName("two");
		hall.addRoom(roomTwo);
	}

	public static VCManager getInstance() {
		return vcm;
	}

	public Hall getHall() {
		return hall;
	}

}
