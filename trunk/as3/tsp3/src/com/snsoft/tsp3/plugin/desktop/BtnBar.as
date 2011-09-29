package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.plugin.desktop.dto.DesktopBtnDTO;

	import flash.display.Sprite;
	import flash.geom.Point;

	public class BtnBar extends Sprite {

		private var dtoList:Vector.<DesktopBtnDTO>;

		public function BtnBar(dtoList:Vector.<DesktopBtnDTO>) {
			super();
			this.dtoList = dtoList;
			init();
		}

		private function init():void {
			var bx:int = 0;
			for (var i:int = 0; i < dtoList.length; i++) {
				var dto:DesktopBtnDTO = dtoList[i];
				var dbtn:DesktopBtn = new DesktopBtn(new Point(48, 48), dto.img, dto.text);
				dbtn.data = dbtn;
				dbtn.x = bx;
				this.addChild(dbtn);
				bx += dbtn.width;
			}
		}
	}
}
