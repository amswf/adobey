package com.snsoft.tsp3 {
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;

	public class ViewUtil {
		public function ViewUtil() {

		}

		public static function creatHiddenRect(width:int, height:int):Sprite {
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill(0xffffff, 0);
			spr.graphics.drawRect(0, 0, width, height);
			spr.graphics.endFill();
			return spr;
		}
		
		public static function filterTfd(tfd:TextField):void{
			var fary:Array = new Array();
			var f1:DropShadowFilter = new DropShadowFilter (0, 0, 0xffffff, 1, 2, 2,10);
			fary.push(f1);
			var f2:DropShadowFilter = new DropShadowFilter (0, 0, 0x000000, 1, 4, 4,1);
			fary.push(f2);
			tfd.filters = fary;
		}
	}
}
