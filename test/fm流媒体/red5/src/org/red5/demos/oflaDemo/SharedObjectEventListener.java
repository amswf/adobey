package org.red5.demos.oflaDemo;

import java.util.List;
import java.util.Map;

import org.red5.server.api.IAttributeStore;
import org.red5.server.api.event.IEvent;
import org.red5.server.api.event.IEventListener;
import org.red5.server.api.so.ISharedObjectBase;
import org.red5.server.api.so.ISharedObjectListener;

public class SharedObjectEventListener implements ISharedObjectListener,IEventListener {

	@Override
	public void onSharedObjectClear(ISharedObjectBase arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectConnect(ISharedObjectBase arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectDelete(ISharedObjectBase arg0, String arg1) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectDisconnect(ISharedObjectBase arg0) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectSend(ISharedObjectBase arg0, String arg1, List<?> arg2) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onSharedObjectUpdate(ISharedObjectBase arg0, IAttributeStore arg1) {
		// TODO Auto-generated method stub
		System.out.println("onSharedObjectUpdate1");
	}

	@Override
	public void onSharedObjectUpdate(ISharedObjectBase arg0, Map<String, Object> arg1) {
		// TODO Auto-generated method stub
		System.out.println("onSharedObjectUpdate2");
	}

	@Override
	public void onSharedObjectUpdate(ISharedObjectBase arg0, String arg1, Object arg2) {
		// TODO Auto-generated method stub
		System.out.println("onSharedObjectUpdate3");
	}

	@Override
	public void notifyEvent(IEvent arg0) {
		// TODO Auto-generated method stub
		
	}

}
