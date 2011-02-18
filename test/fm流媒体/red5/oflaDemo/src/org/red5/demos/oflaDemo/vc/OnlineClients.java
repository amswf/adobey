package org.red5.demos.oflaDemo.vc;

import java.util.HashMap;

import org.red5.server.api.IConnection;

/**
 * 在线链接管理对象
 * @author Administrator
 *
 */
public class OnlineClients {

	private HashMap<String, UUClient> onlineClientsKeyUUID = new HashMap<String, UUClient>();

	private HashMap<String, UUClient> onlineClientsKeyCID = new HashMap<String, UUClient>();
	
	/**
	 * 
	 * @param conn
	 * @param uuid
	 */
	public void addUUClient(IConnection conn, String uuid) {
		UUClient uuc = new UUClient();
		String id = conn.getClient().getId();
		uuc.setId(id);
		uuc.setUuid(uuid);
		uuc.setConn(conn);
		onlineClientsKeyUUID.put(uuid, uuc);
		onlineClientsKeyCID.put(id, uuc);
	}
	
	/**
	 * 
	 * @param uuid
	 * @return
	 */
	public UUClient getUUClientByUUID(String uuid){
		return onlineClientsKeyUUID.get(uuid);
	}
	
	/**
	 * 
	 * @param id
	 * @return
	 */
	public UUClient getUUClientByCID(String id){
		return onlineClientsKeyCID.get(id);
	}
	
	/**
	 * 
	 * @param uuid
	 */
	public void removeUUClientByUUID(String uuid){
		UUClient uuc = getUUClientByUUID(uuid);
		if(uuc != null){
			String id = uuc.getId();
			onlineClientsKeyCID.remove(id);
			onlineClientsKeyUUID.remove(uuid);
		}
	}
	
	/**
	 * 
	 * @param id
	 */
	public void removeUUClientByCID(String id){
		UUClient uuc = getUUClientByCID(id);
		if(uuc != null){
			String uuid = uuc.getUuid();
			onlineClientsKeyCID.remove(id);
			onlineClientsKeyUUID.remove(uuid);
		}
	}
}
