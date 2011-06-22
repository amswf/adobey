package com.snsoft.ltree {
	import flash.display.Sprite;

	public class Utils {
		public function Utils() {
		}

		public static function drawRect(width:int, height:int):Sprite {
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(0x000000, 1);
			spr.graphics.drawRect(0, 0, width, height);
			spr.graphics.endFill();
			return spr;
		}
	}
}
