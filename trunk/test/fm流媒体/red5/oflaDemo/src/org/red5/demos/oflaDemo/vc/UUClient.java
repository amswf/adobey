package org.red5.demos.oflaDemo.vc;

import org.red5.server.api.IConnection;

/**
 * 客户端对象
 * @author Administrator
 *
 */
public class UUClient {
	
	/**
	 * 服务端的client.id
	 */
	private String id;
	
	/**
	 * 客户端的UUID标识
	 */
	private String uuid;
	
	/**
	 * 链接
	 */
	private IConnection conn;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public IConnection getConn() {
		return conn;
	}

	public void setConn(IConnection conn) {
		this.conn = conn;
	}
}
