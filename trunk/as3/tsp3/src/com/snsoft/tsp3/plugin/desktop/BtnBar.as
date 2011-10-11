package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.net.DataDTO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class BtnBar extends Sprite {

		public static const EVENT_BTN_CLICK:String = "EVENT_BTN_CLICK";

		private var dtoList:Vector.<DataDTO>;

		private var _btn:DesktopBtn;

		private var _btns:Vector.<DesktopBtn> = new Vector.<DesktopBtn>();

		public function BtnBar(dtoList:Vector.<DataDTO>) {
			super();
			this.dtoList = dtoList;
			init();
		}

		private function init():void {
			var bx:int = 0;
			for (var i:int = 0; i < dtoList.length; i++) {
				var dto:DataDTO = dtoList[i];
				var dbtn:DesktopBtn = new DesktopBtn(new Point(48, 48), dto.img, dto.text);
				dbtn.buttonMode = true;
				dbtn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
				dbtn.data = dto;
				dbtn.x = bx;
				this.addChild(dbtn);
				btns.push(dbtn);
				bx += dbtn.width;
			}
		}

		private function handlerBtnClick(e:Event):void {
			var dbtn:DesktopBtn = e.currentTarget as DesktopBtn;
			_btn = dbtn;
			this.dispatchEvent(new Event(EVENT_BTN_CLICK));
		}

		public function get btn():DesktopBtn {
			return _btn;
		}

		public function set btn(value:DesktopBtn):void {
			_btn = value;
		}

		public function get btns():Vector.<DesktopBtn> {
			return _btns;
		}

	}
}
