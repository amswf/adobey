package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DyncBtnBar extends Sprite {

		public static const EVENT_BTN_CLICK:String = "EVENT_BTN_CLICK";

		private var max:int;

		private var btnLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var mskLayer:Sprite = new Sprite();

		private var btnImgSize:Point = new Point(48, 48);

		private var barWidth:int;

		private var barHeight:int;

		private var btnWidth:int;

		private var btnHeight:int;

		private var btnv:Vector.<DesktopBtn> = new Vector.<DesktopBtn>();

		private var _btn:DesktopBtn;

		public function DyncBtnBar(max:int) {
			super();
			this.max = max;

			this.addChild(backLayer);
			this.addChild(btnLayer);
			this.addChild(mskLayer);

			var btn:DesktopBtn = new DesktopBtn(btnImgSize, new BitmapData(48, 48), "");
			btnWidth = btn.width;
			btnHeight = btn.height;

			barWidth = max * btnWidth;
			barHeight = btnHeight;
			init();
		}

		private function init():void {
			var back:Sprite = ViewUtil.creatRect(barWidth, barHeight);
			backLayer.addChild(back);

			var msk:Sprite = ViewUtil.creatRect(barWidth, barHeight);
			mskLayer.addChild(msk);
			btnLayer.mask = mskLayer;
		}

		public function addBtn(dto:DataDTO, uuid:String = null):void {
			var btn:DesktopBtn = new DesktopBtn(btnImgSize, dto.img, dto.text, uuid);
			btn.data = dto;
			btn.x = btnv.length * btnWidth;
			btn.buttonMode = true;
			btnLayer.addChild(btn);
			btnv.push(btn);
			btn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
		}

		private function handlerBtnClick(e:Event):void {
			var dbtn:DesktopBtn = e.currentTarget as DesktopBtn;
			_btn = dbtn;
			this.dispatchEvent(new Event(EVENT_BTN_CLICK));
		}

		public function removeBtn(uuid:String):void {
			for (var i:int = 0; i < btnv.length; i++) {
				var btn:DesktopBtn = btnv[i];
				if (btn.uuid == uuid) {
					btnv.splice(i, 1);
					btnLayer.removeChild(btn);
					btn.removeEventListener(MouseEvent.CLICK, handlerBtnClick);
					break;
				}
			}

		}

		public function get btn():DesktopBtn {
			return _btn;
		}
	}
}
