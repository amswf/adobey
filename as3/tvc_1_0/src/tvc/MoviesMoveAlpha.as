package tvc {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MoviesMoveAlpha {
		private var alpha:Number = 0;

		private var step:Number = 0.01;

		public function MoviesMoveAlpha(alpha:Number, step:Number) {
			this.alpha=alpha;
			this.step=step;
		}

		public function getAlpha():Number {
			return this.alpha;
		}

		public function linesEnterFrameHandler(event:Event):void {
			this.alpha+=this.step;
		}
	}
}