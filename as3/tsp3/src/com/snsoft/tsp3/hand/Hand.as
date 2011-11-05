package com.snsoft.tsp3.hand {
	import com.snsoft.util.SkinsUtil;

	import flash.display.Sprite;

	/**
	 * 手式指示
	 * @author Administrator
	 *
	 */
	public class Hand extends Sprite {

		public static const SKIN_UP:String = "HandUp";

		public static const SKIN_DOWN:String = "HandDown";

		public static const SKIN_LEFT:String = "HandLeft";

		public static const SKIN_RIGHT:String = "HandRight";

		public function Hand(skin:String, width:int = NaN, height:int = NaN) {
			super();
			var spr:Sprite = SkinsUtil.createSkinByName(skin);
			this.addChild(spr);
			if (width > 0) {
				spr.width = width;
			}
			if (height > 0) {
				spr.height = height;
			}
		}
	}
}
