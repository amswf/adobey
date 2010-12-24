package com.snsoft.fmc.test{
	import com.snsoft.fmc.test.vi.Seat;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.SharedObject;

	public class SeatSO extends EventDispatcher{
		
		private var so:SharedObject;
		
		private var name:String;
		
		private var remotePath:String;
		
		private var nc:NetConnection;
		
		private static const UVSO:String = "uvso";
				
		public function SeatSO(name:String,nc:NetConnection){
			this.name = name;
			this.remotePath = remotePath;
			this.nc = nc;
		}
		
		public function initSO():void{
			so = SharedObject.getRemote(name, nc.uri, true);
			so.connect(nc);
			so.addEventListener(SyncEvent.SYNC, syncHandler);
		}		
		
		public function updatSO():void{
			var st:String = String(new Date().getTime());
			so.setProperty(UVSO,st);
			trace("so.data[uvso]:",so.data[UVSO]);
		}
		
		private function syncHandler(e:Event):void{
			trace("syncHandler");
			this.dispatchEvent(new Event(SyncEvent.SYNC));
		}
	}
}