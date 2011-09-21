package com.snsoft.tsp3 {
	import com.snsoft.util.rlm.rs.RSSwf;
	import com.snsoft.util.xmldom.XMLConfig;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;

	public class Tsp extends MovieClip {

		private var xmlConfig:XMLConfig = null;

		private var rss:RSSwf = new RSSwf();

		private var PLUGIN_BASE_PATH:String = "plugin";

		private var PLUGIN_SWF_NAME:String = "plugin.swf";

		private var pluginPath:String;

		public function Tsp() {
			super();
			init();
		}

		private function init():void {
			xmlConfig = new XMLConfig();
			xmlConfig.addEventListener(Event.COMPLETE, handlerLoadCfgCmp);
		}

		private function handlerLoadCfgCmp(e:Event):void {

		}

	}
}
