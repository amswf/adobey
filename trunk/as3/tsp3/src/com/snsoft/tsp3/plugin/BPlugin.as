package com.snsoft.tsp3.plugin {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.util.xmldom.XMLConfig;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

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

		private var _dataBaseUrl:String;

		private var _pluginUrl:String = "";

		private var _params:Object;

		protected var pluginCfg:Object;

		protected var _type:String;

		public function BPlugin() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);

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
			dataBaseUrl = Common.instance().dataBaseUrl;
			init();
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

		public function get dataBaseUrl():String {
			return _dataBaseUrl;
		}

		public function set dataBaseUrl(value:String):void {
			_dataBaseUrl = value;
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

	}
}
