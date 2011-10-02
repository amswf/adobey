package com.snsoft.tsp3.plugin {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.util.xmldom.XMLConfig;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * 插件基类，伪抽象类
	 *
	 * 加载plugin时，子swf是由父swf的Bplugin定义的，所以，在Bplugin中 load文件时，是相对父swf的路径，所以在BPlugin里加载config.xml时需要加上插件路径
	 * @author Administrator
	 *
	 */
	public class BPlugin extends MovieClip {

		private var _promptMsgMng:PromptMsgMng;

		private var _dataBaseUrl:String;

		private var _pluginUrl:String = "";

		public function BPlugin() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);

			var cfg:XMLConfig = new XMLConfig();
			cfg.addEventListener(Event.COMPLETE, handlerLoadConfigCmp);
			cfg.load(pluginUrl + "config.xml");
		}

		private function handlerLoadConfigCmp(e:Event):void {
			var cfg:XMLConfig = e.currentTarget as XMLConfig;
			cfg.configToObj(this);
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

	}
}
