package org.red5.demos.oflaDemo;

import java.util.Date;
import java.util.List;
import java.util.Vector;

import org.red5.demos.oflaDemo.vc.Hall;
import org.red5.demos.oflaDemo.vc.Room;
import org.red5.demos.oflaDemo.vc.Seat;
import org.red5.server.so.SharedObject;

public class VCService {

	private VCManager vcm = VCManager.getInstance();

	private static SharedObject vcso;

	public Vector<Room> getRoomList() {
		return vcm.getHall().getRoomList();
	}

	public Vector<Seat> getSeatList(String roomName) {
		System.out.println("getSeatList:" + roomName);
		return vcm.getHall().getRoomByName(roomName).getSeatList();
	}

	public Seat creatSeat(String roomName, String userName) {
		System.out.println("creatSeat:" + roomName + userName);
		Date date = new Date();
		String videoName = String.valueOf(date.getTime());

		Seat seat = new Seat();
		seat.setVideoName(videoName);
		seat.setUserName(userName);

		Room room = vcm.getHall().getRoomByName(roomName);
		room.addSeat(seat);
		return seat;
	}

	public void moveSeat(String userName, String fromRoomName, String toRoomName) {
		Hall hall = vcm.getHall();
		Room fromRoom = hall.getRoomByName(fromRoomName);
		Room toRoom = hall.getRoomByName(toRoomName);
		Seat seat = fromRoom.getSeatByName(userName);
		fromRoom.delSeat(userName);
		toRoom.addSeat(seat);
	}

	public void dropSeat(String userName) {
		Hall hall = vcm.getHall();
		List<Room> list = hall.getRoomList();
		for (int i = 0; i < list.size(); i++) {
			Room room = list.get(i);	
			delSeat(room.getRoomName(),userName);
		}
	}

	public void delSeat(String roomName, String userName) {
		System.out.println("delSeat:" + roomName + userName);
		Room room = vcm.getHall().getRoomByName(roomName);
		room.delSeat(userName);
	}

}
