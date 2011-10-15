package com.snsoft.ws54 {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class WebService extends EventDispatcher {
		public function WebService(wsdl:String) {
			super(null);
		}

		public static function initWS(stage:Stage):void {
			var ld:Loader = new Loader();
			this.addChild(ld);
			ld.load(new URLRequest("../bin-debug/fb4.swf"));
			ld.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, );
		}

		private function loadSwfCmp(e:Event):void {
			
		}

		public function loadWSDL():void {

		}

		public function getOperation():Operation {

		}

	}
}
