package org.red5.demos.oflaDemo;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Vector;

import org.red5.logging.Red5LoggerFactory;
import org.red5.server.adapter.ApplicationAdapter;
import org.red5.server.api.IBandwidthConfigure;
import org.red5.server.api.IConnection;
import org.red5.server.api.IScope;
import org.red5.server.api.stream.IServerStream;
import org.red5.server.api.stream.IStreamCapableConnection;
import org.red5.server.api.stream.support.SimpleConnectionBWConfig;
import org.slf4j.Logger;

public class TestApplication extends ApplicationAdapter {

	private static Logger log = Red5LoggerFactory.getLogger(TestApplication.class, "oflaDemo");
	
	private IScope appScope;

	private IServerStream serverStream;
	
	private int connCount = 0;
	
	/**
	 * 发布的视频列表
	 */
	private HashMap<String, String> videoList = new HashMap<String, String>();

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
			bwConfig.getChannelBandwidth()[IBandwidthConfigure.OVERALL_CHANNEL] =
				1024 * 1024;
			bwConfig.getChannelInitialBurst()[IBandwidthConfigure.OVERALL_CHANNEL] =
				128 * 1024;
			streamConn.setBandwidthConfigure(bwConfig);
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
    
    public void addVideo(String videoName){
    	System.out.println("addVideo");
    	videoList.put(videoName, videoName);
    	System.out.println(videoList.size());
    }
    
    public void delVideo(String videoName){
    	System.out.println("delVideo");
    	videoList.remove(videoName);
    	System.out.println(videoList.size());
    }
    
    public int delAllVideo(){
    	System.out.println("delAllVideo");
    	videoList = new HashMap<String, String>();
    	System.out.println(videoList.size());
    	return videoList.size();
    }
    
    public Vector<String> getVideoList(){
    	System.out.println("getVideoList");
    	Collection<String> coll = videoList.values();
    	Iterator<String> iter = coll.iterator();
    	Vector<String> v = new Vector<String>();
    	while(iter.hasNext()){
    		String videoName = iter.next();
    		v.add(videoName);
    	}
    	System.out.println(videoList.size());
    	return v;
    }
    
    public int getConnCount(){
    	return connCount ++;
    }
}
