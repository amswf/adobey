package com.snsoft.tsp3.plugin {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.util.xmldom.XMLConfig;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	[Event(name = "pluginMinimize", type = "com.snsoft.tsp3.plugin.BPluginEvent")]
	[Event(name = "pluginClose", type = "com.snsoft.tsp3.plugin.BPluginEvent")]

	/**
	 * 插件基类，伪抽象类
	 *
	 * 加载plugin时，子swf是由父swf的Bplugin定义的，所以，在Bplugin中 load文件时，是相对父swf的路径，所以在BPlugin里加载config.xml时需要加上插件路径
	 * @author Administrator
	 *
	 */
	public class BPlugin extends MovieClip {

		public static const TYPE_DESKTOP:String = "DESKTOP";

		public static const TYPE_FUNCTION:String = "FUNCTION";

		public static const TYPE_TOOL:String = "TOOL";

		private var _promptMsgMng:PromptMsgMng;

		private var _serverRootUrl:String;

		private var _pluginUrl:String = "";

		private var _params:Object;

		protected var pluginCfg:Object;

		protected var _type:String;

		private var _uuid:String;

		public function BPlugin() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var cfg:XMLConfig = new XMLConfig();
			cfg.addEventListener(Event.COMPLETE, handlerLoadConfigCmp);
			cfg.load(pluginUrl + "config.xml");
		}

		private function handlerLoadConfigCmp(e:Event):void {
			var cfg:XMLConfig = e.currentTarget as XMLConfig;
			if (pluginCfg != null) {
				cfg.configToObj(pluginCfg);
			}
			else {
				trace(this, "没有初始化pluginCfg属性");
			}
			serverRootUrl = Common.instance().serverRootUrl;
			init();
		}

		public function closePlugin():void {
			this.dispatchEvent(new Event(BPluginEvent.PLUGIN_CLOSE));
		}

		public function minimizePlugin():void {
			this.dispatchEvent(new Event(BPluginEvent.PLUGIN_MINIMIZE));
		}

		protected function init():void {
			trace("需要重写 init方法！");
			throw new Error("需要重写 init方法！");
		}

		public function get promptMsgMng():PromptMsgMng {
			return _promptMsgMng;
		}

		public function set promptMsgMng(value:PromptMsgMng):void {
			_promptMsgMng = value;
		}

		public function get serverRootUrl():String {
			return _serverRootUrl;
		}

		public function set serverRootUrl(value:String):void {
			_serverRootUrl = value;
		}

		public function get pluginUrl():String {
			return _pluginUrl;
		}

		public function set pluginUrl(value:String):void {
			_pluginUrl = value;
		}

		public function get params():Object {
			return _params;
		}

		public function set params(value:Object):void {
			_params = value;
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

		public function get uuid():String {
			return _uuid;
		}

		public function set uuid(value:String):void {
			_uuid = value;
		}

	}
}
