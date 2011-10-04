package com.snsoft.tsp3.plugin.news {
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class NewsBookPage extends Sprite {

		private var pageSize:Point;

		public function NewsBookPage(pageSize:Point) {
			this.pageSize = pageSize;
			init();
		}

		private function init():void {
			var pb:MovieClip = SkinsUtil.createSkinByName("NewsBookPage_backSkin");
			pb.width = pageSize.x;
			pb.height = pageSize.y;
			this.addChild(pb);
		}
	}
}
