package soil {
	import fl.motion.Color;

	import flash.display.Graphics;
	import flash.display.Sprite;

	public class FoldLine extends Sprite {

		private var values:Vector.<Number>;

		private var w:int;

		private var h:int;

		private var min:int;

		private var max:int;

		private var color:uint;

		public function FoldLine(color:uint, width:int, height:int, minValue:Number, maxValue:Number, values:Vector.<Number>) {
			trace(minValue, maxValue);
			super();
			this.color = color;
			this.values = values;
			this.w = width;
			this.h = height;
			this.min = minValue;
			this.max = maxValue;
			init();
		}

		public function init():void {

			var p:Number = max - min;

			var wp:int = int(w / (values.length - 1));
			trace("w:", w, wp);

			var data:Vector.<Number> = new Vector.<Number>();

			var gra:Graphics = this.graphics;
			gra.lineStyle(1, color, 1);

			for (var i:int = 0; i < values.length; i++) {
				var v:Number = values[i];
				var y:Number = h - (v - min) * h / p;
				var x:int = wp * i;

				if (i == 0) {
					gra.moveTo(x, y);
				}
				else {
					gra.lineTo(x, y);
				}
			}
		}
	}
}
