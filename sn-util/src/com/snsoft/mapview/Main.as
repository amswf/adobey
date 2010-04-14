package com.snsoft.mapview{
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Main extends Sprite{
		
		private var url:String = "flash_map/1x/ws_1.xml";
		
		private var request:URLRequest = new URLRequest(url);
		
		private var loader:URLLoader = new URLLoader();
		
		public function Main()
		{
			trace("load");
			loader.load(request);
			loader.addEventListener(Event.COMPLETE,handlerLoadComplete);
			super();
		}
		
		private function handlerLoadComplete(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var wsdo:WorkSpaceDO = MapViewXMLLoader.creatWorkSpaceDO(xml,"ws_1");
			var mv:MapView = new MapView();
			mv.workSpaceDO = wsdo;
			this.addChild(mv);
		}

	}
}