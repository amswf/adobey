package com.snsoft.tsp3 {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Welcome extends MySprite {

		private var sBtn:MovieClip;

		public static const EVENT_CLICK_START:String = "start";

		public function Welcome() {
			super();
		}

		override protected function init():void {
			sBtn = this.getChildByName("startBtn") as MovieClip;
			sBtn.addEventListener(MouseEvent.CLICK, handlerStartClick);
		}

		private function handlerStartClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_CLICK_START));
		}
	}
}
