package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;

	public class BtnBoard extends Sprite {

		private var dtoList:Vector.<DataDTO>;

		private var boardWidth:int;

		private var boardHeight:int;

		private var spaceX:int;

		private var spaceY:int;

		private var coords:Vector.<Point> = new Vector.<Point>();

		private var _btnV:Vector.<DesktopBtn> = new Vector.<DesktopBtn>();

		private var btnSize:Point = new Point(64, 64);

		public function BtnBoard(dtoList:Vector.<DataDTO>, boardWidth:int, boardHeight:int, spaceX:int, spaceY:int) {
			super();
			this.dtoList = dtoList;
			this.boardWidth = boardWidth;
			this.boardHeight = boardHeight;
			this.spaceX = spaceX;
			this.spaceY = spaceY;

			init();
		}

		private function init():void {

			var nx:int = (boardWidth + 1) / spaceX;
			var ny:int = (boardHeight + 1) / spaceY;

			var px:int = (spaceX - btnSize.x) / 2;
			var py:int = (spaceY - btnSize.y) / 2;

			for (var i:int = 0; i < nx; i++) {
				for (var j:int = 0; j < ny; j++) {
					var x:int = i * spaceX + px;
					var y:int = j * spaceY + py;
					var p:Point = new Point(x, y);
					coords.push(p);
				}
			}

			for (var k:int = 0; k < dtoList.length; k++) {
				var dto:DataDTO = dtoList[k];
				var tft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0xffffff);
				var dbtn:DesktopBtn = new DesktopBtn(btnSize, dto.img, dto.text, null, tft, true);
				dbtn.x = coords[k].x;
				dbtn.y = coords[k].y;
				dbtn.data = dto;
				this.addChild(dbtn);
				btnV.push(dbtn);
			}

		}

		public function get btnV():Vector.<DesktopBtn> {
			return _btnV;
		}

	}
}
