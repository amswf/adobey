package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.plugin.desktop.dto.DesktopBtnDTO;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class BtnBoard extends Sprite {

		private var dtoList:Vector.<DesktopBtnDTO>;

		private var boardWidth:int;

		private var boardHeight:int;

		private var spaceX:int;

		private var spaceY:int;

		private var coords:Vector.<Point> = new Vector.<Point>();

		public function BtnBoard(dtoList:Vector.<DesktopBtnDTO>, boardWidth:int, boardHeight:int, spaceX:int, spaceY:int) {
			super();
			this.dtoList = dtoList;
			this.boardWidth = boardWidth;
			this.boardHeight = boardHeight;
			this.spaceX = spaceX;
			this.spaceY = spaceY;

			init();
		}

		private function init():void {

			var back:Sprite = ViewUtil.creatRect(100, 100,0xffffff);
			back.width = boardWidth;
			back.height = boardHeight;
			this.addChild(back);

			var nx:int = boardWidth / spaceX;
			var ny:int = boardHeight / spaceY;

			for (var i:int = 0; i < nx; i++) {
				for (var j:int = 0; j < ny; j++) {
					var x:int = boardWidth - i * spaceX;
					var y:int = j * spaceY;
					var p:Point = new Point(x, y);
					coords.push(p);
				}
			}

			for (var k:int = 0; k < dtoList.length; k++) {
				var dto:DesktopBtnDTO = dtoList[k];
				var dbtn:DesktopBtn = new DesktopBtn(new Point(48, 48), dto.img, dto.text);
				dbtn.x = coords[k].x - dbtn.width;
				dbtn.y = coords[k].y;
				this.addChild(dbtn);
			}

		}
	}
}
