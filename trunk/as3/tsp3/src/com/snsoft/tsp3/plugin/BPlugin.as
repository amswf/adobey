package com.snsoft.tsp3.plugin {
	import com.snsoft.tsp3.PromptMsgMng;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	public class BPlugin extends MovieClip {

		private var _promptMsgMng:PromptMsgMng;

		public function BPlugin() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			init();
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

	}
}
