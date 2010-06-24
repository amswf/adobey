package com.snsoft.tvc2.source{
	import com.snsoft.map.WorkSpaceDO;
	import com.snsoft.mapview.util.MapViewXMLLoader;
	import com.snsoft.tvc2.dataObject.BizDO;
	import com.snsoft.tvc2.map.MapView;
	import com.snsoft.tvc2.util.StringUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class AreaMapLoader extends EventDispatcher{
		
		private var areaMapName:String;
		
		private var mapView:MapView;
		
		private var bizDO:BizDO;
		
		public function AreaMapLoader(areaMapName:String,bizDO:BizDO,target:IEventDispatcher=null)
		{
			super(target);
			this.areaMapName = areaMapName;
			this.bizDO = bizDO;
		}
		
		public function load():void{
			var url:String =this.areaMapName;
			if(StringUtil.isEffective(url)){
				var request:URLRequest = new URLRequest(url);	
				var loader:URLLoader = new URLLoader();
				loader.load(request);
				loader.addEventListener(Event.COMPLETE,handlerLoadAreaMapComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadIOError);
			}
		}
		
		private function handlerLoadAreaMapComplete(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var wsdo:WorkSpaceDO = MapViewXMLLoader.creatWorkSpaceDO(xml,"areaMap");
			
			mapView = new MapView();
			mapView.addEventListener(Event.COMPLETE,handlerMapViewDrawCmp);
			mapView.workSpaceDO = wsdo;
			mapView.drawNow();
			
		}
		private function handlerMapViewDrawCmp(e:Event):void{
			bizDO.mapView = this.mapView;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function handlerLoadIOError(e:Event):void{
			this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}
		
	}
}