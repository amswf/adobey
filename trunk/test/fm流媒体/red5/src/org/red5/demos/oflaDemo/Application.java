package org.red5.demos.oflaDemo;

import org.red5.demos.oflaDemo.vc.Hall;
import org.red5.demos.oflaDemo.vc.Room;
import org.red5.demos.oflaDemo.vc.Seat;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IBandwidthConfigure;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.event.IEventListener;
import org.red5.server.api.service.IPendingServiceCall;
import org.red5.server.api.service.IPendingServiceCallback;
import org.red5.server.api.service.IServiceCapableConnection;
import org.red5.server.api.so.ISharedObject;
import org.red5.server.api.so.ISharedObjectListener;
import org.red5.server.api.stream.IServerStream;
import org.red5.server.api.stream.IStreamCapableConnection;
import org.red5.server.api.stream.support.SimpleConnectionBWConfig;
import org.slf4j.Logger;

public class Application extends ApplicationAdapter implements IPendingServiceCallback {

	public static String CONN_ATRBT_USERNAME = "userName";

	public static String CONN_ATRBT_ROOMNAME = "roomName";

	public static String VC_SO_NAME = "vc_so_name";

	private static Logger log = Red5LoggerFactory.getLogger(Application.class, "oflaDemo");

	private IScope appScope;

	private IServerStream serverStream;

	private ISharedObject vcso;

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
		IEventListener soel = new SharedObjectEventListener();
		vcso.addEventListener(soel);
		vcso.setAttribute("test", "toto");
		System.out.println("vcso:" + vcso);
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

			// String roomName = (String)conn.getAttribute(CONN_ATRBT_ROOMNAME);
			// String userName = (String)conn.getAttribute(CONN_ATRBT_USERNAME);
			// vcs.creatSeat(roomName, userName);
		}
		return super.appConnect(conn, params);
	}

	/** {@inheritDoc} */
	@Override
	public void appDisconnect(IConnection conn) {
		log.info("oflaDemo appDisconnect");
		System.out.println("oflaDemo appDisconnect");
		if (appScope == conn.getScope() && serverStream != null) {
			serverStream.close();
		}
		super.appDisconnect(conn);
	}

	public void callClient(IConnection conn, String roomName, String userName) {
		if (conn instanceof IServiceCapableConnection) {
			IServiceCapableConnection sc = (IServiceCapableConnection) conn;
			VCManager vcm = VCManager.getInstance();
			Hall hall = vcm.getHall();
			Room room = hall.getRoomByName(roomName);
			Seat seat = room.getSeatByName(userName);
			sc.invoke("refreshSeatList", new Object[] {}, this);
		}
	}

	@Override
	public void resultReceived(IPendingServiceCall ipendingservicecall) {
		System.out.println("resultReceived");
	}

}
