package com.snsoft.tsp3.plugin {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;

	/**
	 * 按钮显示板
	 * @author Administrator
	 *
	 */
	public class BtnBoard extends Sprite {

		private var dtoList:Vector.<DataDTO>;

		private var boardWidth:int;

		private var boardHeight:int;

		private var spaceX:int;

		private var spaceY:int;

		private var coords:Vector.<Point> = new Vector.<Point>();

		private var _btnV:Vector.<SquareBtn> = new Vector.<SquareBtn>();

		private var btnSize:Point = new Point(48, 48);

		public static const TYPE_ROW:String = "row";

		public static const TYPE_COL:String = "col";

		private var type:String;

		public function BtnBoard(dtoList:Vector.<DataDTO>, boardWidth:int, boardHeight:int, spaceX:int, spaceY:int, btnSize:Point, type:String) {
			super();
			this.dtoList = dtoList;
			this.boardWidth = boardWidth;
			this.boardHeight = boardHeight;
			this.spaceX = spaceX;
			this.spaceY = spaceY;
			this.btnSize = btnSize;
			this.type = type;
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
				var dbtn:SquareBtn = new SquareBtn(btnSize, dto.img, dto.text, null, tft, true);
				dbtn.x = coords[k].x;
				dbtn.y = coords[k].y;
				dbtn.data = dto;
				this.addChild(dbtn);
				btnV.push(dbtn);
			}

		}

		public function get btnV():Vector.<SquareBtn> {
			return _btnV;
		}

	}
}
