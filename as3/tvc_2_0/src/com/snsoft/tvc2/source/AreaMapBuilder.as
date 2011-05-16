package com.snsoft.tvc2.source {
	import com.snsoft.mapview.dataObj.WorkSpaceDO;
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

	/**
	 * 背影地图加载
	 * @author Administrator
	 *
	 */
	public class AreaMapBuilder extends EventDispatcher {

		private var mapView:MapView;

		private var bizDO:BizDO;

		public function AreaMapBuilder(bizDO:BizDO, target:IEventDispatcher = null) {
			super(target);
			this.bizDO = bizDO;
		}

		public function build():void {
			var textList:Vector.<String> = bizDO.mapRS.textList;
			
			var xml:XML = null;
			if(textList.length > 0){
				xml = new XML(textList[0]);
			}
			var wsdo:WorkSpaceDO = MapViewXMLLoader.creatWorkSpaceDO(xml, "areaMap");
			mapView = new MapView();
			mapView.addEventListener(Event.COMPLETE, handlerMapViewDrawCmp);
			mapView.workSpaceDO = wsdo;
			mapView.drawNow();
		}

		private function handlerMapViewDrawCmp(e:Event):void {
			bizDO.mapView = this.mapView;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}
