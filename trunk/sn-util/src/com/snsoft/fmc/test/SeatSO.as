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
		
		private var soVideoArrayName:String = "soVideoArrayName";
				
		public function SeatSO(name:String,nc:NetConnection){
			this.name = name;
			this.remotePath = remotePath;
			this.nc = nc;
		}
		
		public function initSO():void{
			so = SharedObject.getRemote(name, nc.uri, true);
			so.connect(nc);
			var seatList:Vector.<Seat> = new Vector.<Seat>();
			so.setProperty(soVideoArrayName,new Array());
			so.addEventListener(SyncEvent.SYNC, syncHandler);
			trace("soVideoArrayName",so.data[soVideoArrayName]);
		}		
		
		public function updatSO():void{
			var st:String = String(new Date().getTime());
			so.setProperty("lala",st);
			trace("so.data[lala]:",so.data["lala"]);
		}
		
		private function syncHandler(e:Event):void{
			trace("syncHandler");
			this.dispatchEvent(new Event(SyncEvent.SYNC));
		}
	}
}