package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.hand.Hand;
	import com.snsoft.tsp3.hand.HandGroup;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.tsp3.touch.TouchDragEvent;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class NewsBtnBox extends MySprite {

		public static const EVENT_BTN_CLICK:String = "event_btn_click";

		private var btnv:Vector.<NewsImgBtn>;

		private var boxHeight:int;

		private var btnsLayer:Sprite = new Sprite();

		private var maskLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var handLayer:Sprite = new Sprite();

		private var _clickBtn:NewsImgBtn;

		private var handg:HandGroup;

		private var td:TouchDrag;

		public function NewsBtnBox(btnv:Vector.<NewsImgBtn>, boxHeight:int) {
			this.btnv = btnv;
			this.boxHeight = boxHeight;
			super();
		}

		override protected function configMS():void {

		}

		override protected function draw():void {

			this.addChild(backLayer);
			this.addChild(btnsLayer);
			this.addChild(maskLayer);
			this.addChild(handLayer);

			handLayer.mouseChildren = false;
			handLayer.mouseEnabled = false;

			var btnH:int;
			for (var i:int = 0; i < btnv.length; i++) {
				var btn:NewsImgBtn = btnv[i];
				btn.y = i * btn.height;
				btnsLayer.addChild(btn);
				btnH = btn.height;
			}

			//var mskH:int = boxHeight - boxHeight % btnH;
			var mskH:int = boxHeight;

			var back:Sprite = SkinsUtil.createSkinByName("NewsBtnBox_backSkin");
			backLayer.addChild(back);
			back.width = btnsLayer.width;
			back.height = boxHeight;

			var msk:Sprite = ViewUtil.creatRect(btnsLayer.width, mskH, 0xffffff, 1);
			maskLayer.addChild(msk);
			btnsLayer.mask = msk;

			var y:int = btnsLayer.height - mskH;
			y = y < 0 ? 0 : y;
			var rect:Rectangle = new Rectangle(0, -y, 0, y);

			td = new TouchDrag(btnsLayer, stage, rect);
			for (var j:int = 0; j < btnv.length; j++) {
				var b:NewsImgBtn = btnv[j];
				b.buttonMode = true;
				b.mouseChildren = false;
				td.addClickObj(b);
			}

			td.addEventListener(TouchDragEvent.TOUCH_CLICK, handlerClick);
			td.addEventListener(TouchDragEvent.TOUCH_DRAG_MOUSE_UP, handlerDragOver);

			handg = new HandGroup(40, 40);

			handg.down.visible = false;
			handLayer.addChild(handg.down);
			handg.down.x = btnsLayer.width - handg.down.width;

			handg.up.visible = false;
			handLayer.addChild(handg.up);
			handg.up.x = handg.down.x;
			handg.up.y = boxHeight - handg.up.height;
			setHandsState();
		}

		private function handlerDragOver(e:Event):void {
			setHandsState();
		}

		private function handlerClick(e:Event):void {
			var td:TouchDrag = e.currentTarget as TouchDrag;
			setSelectBtn(td.clickObj as NewsImgBtn);
			this.dispatchEvent(new Event(EVENT_BTN_CLICK));
		}

		private function setHandsState():void {
			handg.up.visible = !td.isEnd;
			handg.down.visible = !td.isStart;
		}

		private function setSelectBtn(btn:NewsImgBtn):void {
			if (this.clickBtn != null) {
				this.clickBtn.setSectcted(false);
			}
			btn.setSectcted(true);
			_clickBtn = btn;
		}

		public function selectedDef(i:int):void {
			if (i >= 0 && i < btnv.length) {
				setSelectBtn(btnv[i]);
			}
		}

		public function get clickBtn():NewsImgBtn {
			return _clickBtn;
		}

	}
}
