package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.tsp3.touch.TouchDragEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class NewsBtnBox extends MySprite {

		public static const EVENT_BTN_CLICK:String = "event_btn_click";

		private var btnv:Vector.<NewsBtn>;

		private var boxHeight:int;

		private var btnsLayer:Sprite = new Sprite();

		private var maskLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var _clickBtn:NewsBtn;

		public function NewsBtnBox(btnv:Vector.<NewsBtn>, boxHeight:int) {
			super();
			this.btnv = btnv;
			this.boxHeight = boxHeight;
		}

		override protected function init():void {

			this.addChild(backLayer);
			this.addChild(btnsLayer);
			this.addChild(maskLayer);

			var btnH:int;
			for (var i:int = 0; i < btnv.length; i++) {
				var btn:NewsBtn = btnv[i];
				btn.y = i * btn.height;
				btnsLayer.addChild(btn);
				btnH = btn.height;
			}

			//var mskH:int = boxHeight - boxHeight % btnH;
			var mskH:int = boxHeight;

			var back:Sprite = ViewUtil.creatRect(btnsLayer.width, boxHeight, 0xffffff, 1);
			backLayer.addChild(back);

			var msk:Sprite = ViewUtil.creatRect(btnsLayer.width, mskH, 0xffffff, 1);
			maskLayer.addChild(msk);
			btnsLayer.mask = msk;

			var y:int = btnsLayer.height - mskH;
			y = y < 0 ? 0 : y;
			var rect:Rectangle = new Rectangle(0, -y, 0, y);

			var td:TouchDrag = new TouchDrag(btnsLayer, stage, rect);
			for (var j:int = 0; j < btnv.length; j++) {
				var b:NewsBtn = btnv[j];
				b.buttonMode = true;
				b.mouseChildren = false;
				td.addClickObj(b);
			}

			td.addEventListener(TouchDragEvent.TOUCH_CLICK, handlerClick);
		}

		private function handlerClick(e:Event):void {
			var td:TouchDrag = e.currentTarget as TouchDrag;
			this._clickBtn = td.clickObj as NewsBtn;
			this.dispatchEvent(new Event(EVENT_BTN_CLICK));
		}

		public function get clickBtn():NewsBtn {
			return _clickBtn;
		}

	}
}
