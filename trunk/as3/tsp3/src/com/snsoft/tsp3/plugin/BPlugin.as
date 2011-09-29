package com.snsoft.tsp3.plugin {
	import com.snsoft.tsp3.PromptMsgMng;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	public class BPlugin extends Sprite {

		private var _promptMsgMng:PromptMsgMng;

		private var _pluginWidth:int = -1;

		private var _pluginHeight:int = -1;

		public function BPlugin() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);
			pluginWidth = pluginWidth == -1 ? stage.stageWidth : pluginWidth;
			pluginHeight = pluginHeight == -1 ? stage.stageHeight : pluginHeight;
			init();
		}

		public static function setPluginSize(plugin:BPlugin, stage:Stage):void {
			plugin.pluginWidth = stage.fullScreenWidth;
			plugin.pluginHeight = stage.fullScreenHeight;
		}

		protected function init():void {
			trace("需要重写 init方法！");
		}

		public function get promptMsgMng():PromptMsgMng {
			return _promptMsgMng;
		}

		public function set promptMsgMng(value:PromptMsgMng):void {
			_promptMsgMng = value;
		}

		public function get pluginWidth():int {
			return _pluginWidth;
		}

		public function set pluginWidth(value:int):void {
			_pluginWidth = value;
		}

		public function get pluginHeight():int {
			return _pluginHeight;
		}

		public function set pluginHeight(value:int):void {
			_pluginHeight = value;
		}

	}
}
