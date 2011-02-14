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

	private static final int USER_NAME = 0;

	private static final int VIDEO_NAME = 1;

	private static final int USER_TYPE = 2;

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
		measureBandwidth(conn);
		if (conn instanceof IStreamCapableConnection) {
			IStreamCapableConnection streamConn = (IStreamCapableConnection) conn;
			SimpleConnectionBWConfig bwConfig = new SimpleConnectionBWConfig();
			bwConfig.getChannelBandwidth()[IBandwidthConfigure.OVERALL_CHANNEL] = 1024 * 1024;
			bwConfig.getChannelInitialBurst()[IBandwidthConfigure.OVERALL_CHANNEL] = 128 * 1024;
			streamConn.setBandwidthConfigure(bwConfig);
			if (params != null && params.length == 3) {
				conn.setAttribute("params", params);
				System.out.println(params[USER_NAME]);
				System.out.println(params[VIDEO_NAME]);
				String id = conn.getClient().getId();
				onLineClient.put(id, conn);
				Seat seat = new Seat();
				seat.setClientId(id);
				seat.setUserName(String.valueOf(params[USER_NAME]));
				seat.setVideoName(String.valueOf(params[VIDEO_NAME]));
				seat.setUserType(String.valueOf(params[USER_TYPE]));
				addSeat(String.valueOf(params[USER_TYPE]), seat);
				String ms = String.valueOf(new Date().getTime());
				vcso.setAttribute("uvso", ms);
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
		if (params != null && params.length > 0) {
			String userName = (String) params[0];
			vcs.dropSeat(userName);

			if (appScope == conn.getScope() && serverStream != null) {
				serverStream.close();
			}

			if (params != null && params.length == 3) {
				String id = conn.getClient().getId();
				onLineClient.remove(id);
				removeSeat(String.valueOf(params[USER_TYPE]), id);
				String ms = String.valueOf(new Date().getTime());
				vcso.setAttribute("uvso", ms);
			}
		}
		super.appDisconnect(conn);
	}

	@Override
	public void resultReceived(IPendingServiceCall ipendingservicecall) {
		System.out.println("resultReceived");
	}

	/**
	 * 请求方通知被请求方播放请求方视频
	 * @param passiveUserType
	 * @param passiveClientId
	 */
	public void callBackPassiveClientPlayVideo(String passiveUserType, String passiveClientId) {
		System.out.println("callBackPassiveClientPlayVideo");
		System.out.println("　passiveUserType:" + passiveUserType +"　passiveClientId:" + passiveClientId);
		IConnection conn = onLineClient.get(passiveClientId);
		if (conn instanceof IServiceCapableConnection) {
			// 转发消息
			Seat seat = getSeatByClientId(passiveUserType, passiveClientId);
			IServiceCapableConnection sc = (IServiceCapableConnection) conn;
			sc.invoke("callBackPassiveClientPlayVideo", new Object[] {seat.getClientId()});
		}
	}

	/**
	 * 告诉客户端，它的用户信息(目前不用)
	 * 
	 * @param conn
	 * @param seat
	 */
	private void callClientSetSeat(IConnection conn, Seat seat) {
		if (conn instanceof IServiceCapableConnection) {
			// 转发消息
			IServiceCapableConnection sc = (IServiceCapableConnection) conn;
			sc.invoke("callBackSetSeat", new Object[] { seat });
		}
	}

	/**
	 * 一个客户端向另一个客户端请求视频
	 * 
	 * @param uid
	 */
	public void callBackReqVideo(String userType,String clientId, String oppositeClientType, String oppositeClientId) {
		System.out.println("reqVideo");
		System.out.println("clientId:" + clientId + " oppositeClientType:" + oppositeClientType + " oppositeClientId:" + oppositeClientId);
		IConnection conn = onLineClient.get(oppositeClientId);
		if (conn instanceof IServiceCapableConnection) {
			// 转发消息
			Seat seat = getSeatByClientId(userType, clientId);
			IServiceCapableConnection sc = (IServiceCapableConnection) conn;
			sc.invoke("callBackVideoRequest", new Object[] {userType, clientId, seat.getVideoName() });
		}
	}

	/**
	 * 通知请求方，已接受视频
	 * 
	 * @param oppositeClientId
	 * @param clientVideoName
	 */
	public void callBackAccessVideo(String oppositeClientId,String clientId, String clientVideoName) {
		System.out.println("reqVideo");
		System.out.println("oppositeClientId:" + oppositeClientId + "clientVideoName" + clientVideoName);
		IConnection conn = onLineClient.get(oppositeClientId);
		if (conn instanceof IServiceCapableConnection) {

			IServiceCapableConnection sc = (IServiceCapableConnection) conn;
			sc.invoke("callBackReqAccessVideo", new Object[] {clientId, clientVideoName });
		}
	}

	/**
	 * 添加用户
	 * 
	 * @param roomName
	 * @param seat
	 */
	private void addSeat(String roomName, Seat seat) {
		VCManager.getInstance().getHall().getRoomByName(roomName).addSeat(seat);
	}

	/**
	 * 删除用户
	 * 
	 * @param roomName
	 * @param clientId
	 */
	private void removeSeat(String roomName, String clientId) {
		VCManager.getInstance().getHall().getRoomByName(roomName).delSeatById(clientId);
	}

	/**
	 * 通过ID获得用户
	 * 
	 * @param roomName
	 * @param i
	 * @return
	 */
	private Seat getSeatByIndex(String roomName, int i) {
		return VCManager.getInstance().getHall().getRoomByName(roomName).getSeatByIndex(i);
	}

	/**
	 * 通过ID获得用户
	 * 
	 * @param roomName
	 * @param i
	 * @return
	 */
	private Seat getSeatByClientId(String roomName, String clientId) {
		return VCManager.getInstance().getHall().getRoomByName(roomName).getSeatByClientId(clientId);
	}
}
