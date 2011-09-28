package com.snsoft.tsp3 {
	import flash.display.Sprite;
	import flash.events.Event;

	public class MySprite extends Sprite {

		public function MySprite() {
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);
			init();
		}

		protected function init():void {
			trace("需要重写 init方法！");
		}

	}
}
