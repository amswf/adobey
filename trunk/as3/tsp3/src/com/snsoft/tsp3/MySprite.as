package com.snsoft.tsp3 {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class MySprite extends Sprite {
		public function MySprite() {
			super();
			configMS();
			this.addEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);
		}

		protected function configMS():void {

		}

		public function drawNow():void {
			draw();
		}

		protected function draw():void {
			trace("需要重写draw方法！");
			throw new Error("需要重写 draw方法！");
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerEnterFrame);
			draw();
		}
	}
}
