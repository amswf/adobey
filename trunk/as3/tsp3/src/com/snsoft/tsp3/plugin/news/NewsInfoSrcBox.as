package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.net.DataParam;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NewsInfoSrcBox extends MySprite {

		public static const EVENT_SRC_BTN_CLICK:String = "eventSrcBtnClick";

		private var btnSkin:String;

		private var params:Vector.<DataParam>;

		private var btnWidth:int;

		private var _clickData:DataParam;

		public function NewsInfoSrcBox(btnSkin:String, params:Vector.<DataParam>, btnWidth:int) {

			this.btnSkin = btnSkin;
			this.params = params;
			this.btnWidth = btnWidth;
			super();
		}

		override protected function draw():void {
			if (params != null) {
				for (var i:int = 0; i < params.length; i++) {
					var param:DataParam = params[i];
					var nsb:NewsSrcBtn = new NewsSrcBtn(btnSkin, param.text, btnWidth);
					nsb.data = param;
					this.addChild(nsb);
					nsb.buttonMode = true;
					nsb.addEventListener(MouseEvent.CLICK, handlerMouseClick);
					nsb.y = nsb.height * i;
				}
			}
		}

		private function handlerMouseClick(e:Event):void {
			var nsb:NewsSrcBtn = e.currentTarget as NewsSrcBtn;
			_clickData = nsb.data as DataParam;
			this.dispatchEvent(new Event(EVENT_SRC_BTN_CLICK));
		}

		public function get clickData():DataParam {
			return _clickData;
		}

	}
}
