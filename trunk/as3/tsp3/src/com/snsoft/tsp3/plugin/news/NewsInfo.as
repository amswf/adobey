package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.util.SpriteUtil;

	import flash.geom.Point;

	public class NewsInfo extends MySprite {

		private var _infoSize:Point;

		public function NewsInfo(infoSize:Point) {
			this._infoSize = infoSize;
			super();
		}

		override protected function configMS():void {

		}

		override protected function draw():void {

		}

		public function refresh(board:NewsBoardBase):void {
			this.addChild(board);
		}

		public function clear():void {
			SpriteUtil.deleteAllChild(this);
		}

		public function get infoSize():Point {
			return _infoSize;
		}

	}
}
