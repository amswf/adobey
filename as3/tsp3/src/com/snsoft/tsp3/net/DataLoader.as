package com.snsoft.tsp3.net {
	import com.snsoft.util.UUID;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "ioError", type = "flash.events.Event")]

	/**
	 *
	 * @author Administrator
	 *
	 */
	public class DataLoader extends EventDispatcher {

		private var _data:Object;

		private var url:String;

		private static const OPERATION:String = "operation";

		public function DataLoader() {
			super(null);

		}

		public function loadData(url:String, code:String, operation:String, params:Params = null):void {
			this.url = url;
			if (params != null) {
				params = new Params();
			}
			params.addParam(OPERATION, operation);

			var uvs:URLVariables = new URLVariables();
			uvs["code"] = code;
			uvs["xml"] = params.toXML();
			load(url, uvs);
		}

		private function load(url:String, uvs:URLVariables = null):void {

			var req:URLRequest = new URLRequest(url);
			if (uvs == null) {
				uvs = new URLVariables();
			}
			var uuid:String = UUID.create();
			uvs[uuid] = uuid;
			req.data = uvs;
			req.method = URLRequestMethod.POST;

			var ul:URLLoader = new URLLoader();
			ul.addEventListener(Event.COMPLETE, handlerLoadCmp);
			ul.addEventListener(IOErrorEvent.IO_ERROR, handlerLoadError);
			ul.load(req);
		}

		private function handlerLoadCmp(e:Event):void {
			var ul:URLLoader = e.currentTarget as URLLoader;
			ul.removeEventListener(Event.COMPLETE, handlerLoadCmp);
			ul.removeEventListener(IOErrorEvent.IO_ERROR, handlerLoadError);
			_data = ul.data;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		private function handlerLoadError(e:Event):void {
			var ul:URLLoader = e.currentTarget as URLLoader;
			ul.removeEventListener(Event.COMPLETE, handlerLoadCmp);
			ul.removeEventListener(IOErrorEvent.IO_ERROR, handlerLoadError);
			this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}

		public function get data():Object {
			return _data;
		}

	}
}
