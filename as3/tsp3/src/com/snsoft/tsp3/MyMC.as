package com.snsoft.tsp3 {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MyMC extends MovieClip {
		public function MyMC() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			init();
		}

		protected function init():void {
			trace("需要重写 init方法！");
			throw new Error("需要重写 init方法！");
		}
	}
}
