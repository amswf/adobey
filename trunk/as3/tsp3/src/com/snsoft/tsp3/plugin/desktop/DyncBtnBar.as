package com.snsoft.tsp3.plugin.desktop {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.plugin.desktop.dto.DesktopBtnDTO;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class DyncBtnBar extends Sprite {

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

		public function addBtn(dto:DesktopBtnDTO, uuid:String = null):void {
			var btn:DesktopBtn = new DesktopBtn(btnImgSize, dto.img, dto.text, uuid);
			btn.data = dto;
			btn.x = btnv.length * btnWidth;
			btnLayer.addChild(btn);
			btnv.push(btn);
		}

		public function removeBtn(uuid:String):void {
			for (var i:int = 0; i < btnv.length; i++) {
				var btn:DesktopBtn = btnv[i];
				if (btn.uuid == uuid) {
					btnv.splice(i, 1);
					btnLayer.removeChild(btn);
					break;
				}
			}

		}
	}
}
