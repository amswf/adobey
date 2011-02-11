package org.red5.demos.oflaDemo;

import java.util.Date;
import java.util.HashMap;

import org.red5.demos.oflaDemo.vc.Hall;
import org.red5.demos.oflaDemo.vc.Room;
import org.red5.demos.oflaDemo.vc.Seat;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IBandwidthConfigure;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.service.IPendingServiceCall;
import org.red5.server.api.service.IPendingServiceCallback;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.so.ISharedObject;
import org.red5.server.api.stream.IServerStream;
import org.red5.server.api.stream.IStreamCapableConnection;
import org.red5.server.api.stream.support.SimpleConnectionBWConfig;
import org.slf4j.Logger;

public class TspExpertApplication extends ApplicationAdapter implements IPendingServiceCallback {

	public static String CONN_ATRBT_USERNAME = "userName";

	public static String CONN_ATRBT_ROOMNAME = "roomName";

	public static String VC_SO_NAME = "vc_so_name";

	private static Logger log = Red5LoggerFactory.getLogger(TspExpertApplication.class, "oflaDemo");

	private IScope appScope;

	private IServerStream serverStream;

	private ISharedObject vcso;

	private HashMap<String, IConnection> onLineClient = new HashMap<String, IConnection>();

	private VCService vcs = new VCService();

	{
		log.info("oflaDemo created");
		System.out.println("oflaDemo created");

	}

	/** {@inheritDoc} */
	@Override
	public boolean appStart(IScope app) {

		log.info("oflaDemo appStart");
		System.out.println("oflaDemo appStart");
		appScope = app;

		boolean b = this.createSharedObject(app, VC_SO_NAME, true);
		if (b) {
			vcso = this.getSharedObject(app, VC_SO_NAME);
		}
		SharedObjectEventListener soel = new SharedObjectEventListener();
		vcso.addSharedObjectListener(soel);
		return true;
	}

	/** {@inheritDoc} */
	@Override
	public boolean appConnect(IConnection conn, Object[] params) {
		log.info("oflaDemo appConnect");
		System.out.println("oflaDemo appConnect");
		conn.setAttribute("params", params);
		measureBandwidth(conn);
		if (conn instanceof IStreamCapableConnection) {
			IStreamCapableConnection streamConn = (IStreamCapableConnection) conn;
			SimpleConnectionBWConfig bwConfig = new SimpleConnectionBWConfig();
			bwConfig.getChannelBandwidth()[IBandwidthConfigure.OVERALL_CHANNEL] = 1024 * 1024;
			bwConfig.getChannelInitialBurst()[IBandwidthConfigure.OVERALL_CHANNEL] = 128 * 1024;
			streamConn.setBandwidthConfigure(bwConfig);

			if (String.valueOf(params[2]).equals("one")) {
				System.out.println(params[0]);
				System.out.println(params[1]);
				String id = conn.getClient().getId();
				onLineClient.put(id, conn);
				Seat seat = new Seat();
				seat.setClientId(id);
				seat.setUserName(String.valueOf(params[0]));
				seat.setVideoName(String.valueOf(params[1]));
				addSeat("one",seat);
			}
		}
		return super.appConnect(conn, params);
	}

	/** {@inheritDoc} */
	@Override
	public void appDisconnect(IConnection conn) {
		log.info("oflaDemo appDisconnect");
		System.out.println("oflaDemo appDisconnect");
		Object[] params = (Object[]) conn.getAttribute("params");
		String userName = (String) params[0];
		vcs.dropSeat(userName);
		String ms = String.valueOf(new Date().getTime());
		vcso.setAttribute("uvso", ms);
		if (appScope == conn.getScope() && serverStream != null) {
			serverStream.close();
		}
		if (String.valueOf(params[2]).equals("one")) {
			String id = conn.getClient().getId();
			onLineClient.remove(id);
			removeSeat("one",id);
		}
		super.appDisconnect(conn);
	}

	@Override
	public void resultReceived(IPendingServiceCall ipendingservicecall) {
		System.out.println("resultReceived");
	}
	
	public void reqVideo(String uid){
		System.out.println("reqVideo");
		System.out.println(uid);
		callClient(uid,"callBackVideoRequest",new Object[]{uid});
	}

	/**
	 * 调用指定的客户端
	 * @param uid
	 * @param method_name
	 * @param obj
	 * @return
	 */
	public boolean callClient(String uid, String method_name, Object[] obj) {
		IConnection toClient = onLineClient.get(uid);
		if (toClient instanceof IServiceCapableConnection) {
			// 转发消息
			IServiceCapableConnection sc = (IServiceCapableConnection) toClient;
			sc.invoke(method_name, obj);
			return true;
		}
		return false;
	}

	private void addSeat(String roomName, Seat seat) {
		VCManager.getInstance().getHall().getRoomByName(roomName).addSeat(seat);
	}
	
	private void removeSeat(String roomName,String clientId){
		VCManager.getInstance().getHall().getRoomByName(roomName).delSeatById(clientId);
	}
	
	private Seat getSeatByIndex(String roomName,int i){
		return VCManager.getInstance().getHall().getRoomByName(roomName).getSeatByIndex(i);
		
	}
}
