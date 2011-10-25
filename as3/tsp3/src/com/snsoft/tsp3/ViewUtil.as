package com.snsoft.tsp3 {
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	public class ViewUtil {
		public function ViewUtil() {

		}

		public static function creatRect(width:int, height:int, color:uint = 0xffffff, alpha:Number = 0):Sprite {
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(color, alpha);
			spr.graphics.drawRect(0, 0, width, height);
			spr.graphics.endFill();
			return spr;
		}

		public static function filterTfd(tfd:TextField):void {
			var fary:Array = new Array();
			var f1:DropShadowFilter = new DropShadowFilter(2, 90, 0x000000, 1, 4, 4, 1);
			fary.push(f1);
			tfd.filters = fary;
		}
	}
}
