package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.tsp3.plugin.BPlugin;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Desktop extends BPlugin {
		public function Desktop() {
			super();
		}

		override protected function init():void {
			trace("des");

			PromptMsgMng.instance().setMsg("b");

			var mc:Sprite = new Sprite();

			this.addChild(mc);

			for (var i:int = 0; i < 10; i++) {
				var db:DesktopBtn = new DesktopBtn(new Point(48, 48), new BitmapData(10, 10, false, 0x000000), "我的桌面我的桌面");
				mc.addChild(db);
				db.x = i * db.width;
			}

			mc.y = stage.stageHeight - mc.height;
		}
	}
}
