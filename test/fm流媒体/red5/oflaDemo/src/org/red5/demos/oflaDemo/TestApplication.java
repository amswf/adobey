package org.red5.demos.oflaDemo;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

import org.red5.demos.oflaDemo.vc.OnlineClients;
import org.red5.demos.oflaDemo.vc.UUClient;
import org.red5.server.adapter.MultiThreadedApplicationAdapter;
import org.red5.server.api.IClient;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.stream.IServerStream;

public class TestApplication extends MultiThreadedApplicationAdapter {

	private IScope appScope;

	private IServerStream serverStream;

	private int connCount = 0;

	public static final String CONN_ATTR_PARAMS = "params";

	public static final int PARAMS_UUID = 0;

	private OnlineClients clients = new OnlineClients();

	/**
	 * 发布的视频列表
	 */
	private HashMap<String, String> videoList = new HashMap<String, String>();

	{

		System.out.println("oflaDemo created");
	}

	public TestApplication() {
	}

	public synchronized boolean connect(IConnection conn, IScope scope, Object params[]) {
		System.out.println("oflaDemo appConnect");
		conn.setAttribute(CONN_ATTR_PARAMS, params);
		measureBandwidth(conn);

		// 添加在线链接
		if (params.length >= 1) {
			String uuid = (String) params[PARAMS_UUID];
			if (uuid != null && uuid.trim().length() > 0) {
				clients.addUUClient(conn, uuid);
			}
		}

		return super.connect(conn, scope, params);
	}

	public synchronized void disconnect(IConnection conn, IScope scope) {
		System.out.println("oflaDemo appDisconnect");

		Object[] params = (Object[]) conn.getAttribute(CONN_ATTR_PARAMS);

		if (appScope == conn.getScope() && serverStream != null) {
			serverStream.close();
		}

		String id = conn.getClient().getId();

		String videoNamePrefix = "cid" + id;

		Vector<String> v = getVideoList();
		for (int i = 0; v != null && i < v.size(); i++) {
			String videoName = v.get(i);
			if (videoName.startsWith(videoNamePrefix)) {
				videoList.remove(videoName);
			}
		}

		// 删除在线链接
		clients.removeUUClientByCID(id);

		super.disconnect(conn, scope);
	}

	public synchronized boolean start(IScope scope) {
		System.out.println("oflaDemo appStart");
		appScope = scope;
		return super.start(scope);
	}

	public synchronized void stop(IScope scope) {
		super.stop(scope);
	}

	public synchronized boolean join(IClient client, IScope scope) {
		return super.join(client, scope);
	}

	public synchronized void leave(IClient client, IScope scope) {
		super.leave(client, scope);
	}

	/**
	 * 客户端 call 方法
	 * 
	 * @param videoName
	 */
	public void addVideo(String videoName) {
		System.out.println("addVideo");
		videoList.put(videoName, videoName);
		System.out.println(videoList.size());
	}

	/**
	 * 客户端 call 方法
	 * 
	 * @param videoName
	 */
	public void delVideo(String videoName) {
		System.out.println("delVideo");
		videoList.remove(videoName);
		System.out.println(videoList.size());
	}

	/**
	 * 客户端 call 方法
	 * 
	 * @return
	 */
	public int delAllVideo() {
		System.out.println("delAllVideo");
		videoList = new HashMap<String, String>();
		System.out.println(videoList.size());
		return videoList.size();
	}

	/**
	 * 客户端 call 方法
	 * 
	 * @return
	 */
	public Vector<String> getVideoList() {
		System.out.println("getVideoList");
		Collection<String> coll = videoList.values();
		Iterator<String> iter = coll.iterator();
		Vector<String> v = new Vector<String>();
		while (iter.hasNext()) {
			String videoName = iter.next();
			v.add(videoName);
		}
		System.out.println(videoList.size());
		return v;
	}

	/**
	 * 客户端 call 方法
	 * 
	 * @return
	 */
	public int getConnCount() {
		return connCount++;
	}

	/**
	 * 客户端 call 方法
	 * 
	 * @param uuid
	 * @return
	 */
	public String getId(String uuid) {
		UUClient client = clients.getUUClientByUUID(uuid);
		String id = null;
		if (client != null) {
			id = client.getId();
		}
		return id;
	}
}
