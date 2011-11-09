package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;

	public class LinkBoard extends Sprite {

		public static const EVENT_BTN_CLICK:String = "EVENT_BTN_CLICK";

		private var dtoList:Vector.<DataDTO>;

		private var columnNum:int;

		private var spaceX:int;

		private var spaceY:int;

		private var _btnV:Vector.<LinkBtn> = new Vector.<LinkBtn>();

		private var btnSize:Point = new Point(48, 48);

		//皮肤，顶部三角形高度 ：LinkBoard_backDefSkin
		private var boadert:int = 10;

		private var boader:int = 10;

		private var _clickObj:LinkBtn;

		public function LinkBoard(dtoList:Vector.<DataDTO>, columnNum:int, spaceX:int, spaceY:int) {
			super();
			this.dtoList = dtoList;
			this.columnNum = columnNum;
			this.spaceX = spaceX;
			this.spaceY = spaceY;

			init();
		}

		private function init():void {

			var nx:int = columnNum;
			nx = Math.min(nx, dtoList.length);

			var back:Sprite = SkinsUtil.createSkinByName("LinkBoard_backDefSkin");
			this.addChild(back);

			back.width = boader + boader + nx % columnNum * spaceX;
			back.height = boadert + boader + boader + int(1 + ((nx - 1) / columnNum)) * spaceY;

			var btns:Sprite = new Sprite();
			this.addChild(btns);
			btns.x = boader;
			btns.y = boader + boadert;

			var lb:LinkBtn = new LinkBtn(btnSize, new BitmapData(48, 48), "AAAA");
			var bw:int = lb.width;
			var bh:int = lb.height;
			var bx:int = (spaceX - lb.width) / 2;
			var by:int = (spaceY - lb.height) / 2;

			var coords:Vector.<Point> = new Vector.<Point>();

			var n:int = 0;
			var m:int = 0;
			for (var i:int = 0; i < dtoList.length; i++) {
				var x:int = n * spaceX + bx;
				var y:int = m * spaceY + by;
				var p:Point = new Point(x, y);
				coords.push(p);

				n++;
				if (i != 0 && i % columnNum == 0) {
					n = 0;
					m++;
				}
			}

			for (var k:int = 0; k < dtoList.length; k++) {
				var dto:DataDTO = dtoList[k];
				var tft:TextFormat = new TextFormat(null, 13, 0xffffff);
				var dbtn:LinkBtn = new LinkBtn(btnSize, dto.img, dto.text, null, tft, false);
				dbtn.buttonMode = true;
				dbtn.x = coords[k].x;
				dbtn.y = coords[k].y;
				dbtn.data = dto;
				btns.addChild(dbtn);
				btnV.push(dbtn);
				dbtn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
			}

		}

		private function handlerBtnClick(e:Event):void {
			_clickObj = e.currentTarget as LinkBtn;
			this.dispatchEvent(new Event(EVENT_BTN_CLICK));
		}

		public function get btnV():Vector.<LinkBtn> {
			return _btnV;
		}

		public function get clickObj():LinkBtn {
			return _clickObj;
		}

	}
}
