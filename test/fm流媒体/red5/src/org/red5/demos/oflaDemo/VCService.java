package org.red5.demos.oflaDemo;

import java.util.Date;
import java.util.Vector;

import org.red5.demos.oflaDemo.vc.Room;
import org.red5.demos.oflaDemo.vc.Seat;

public class VCService {
	
	private VCManager vcm = VCManager.getInstance();
	
	public Vector<Room> getRoomList(){
		return vcm.getHall().getRoomList();
	}
	
	public Vector<Seat> getSeatList(String roomName){
		System.out.println("getSeatList:" + roomName);
		return vcm.getHall().getRoomByName(roomName).getSeatList();
	}
	
	public Seat creatSeat(String roomName,String userName){
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

}
