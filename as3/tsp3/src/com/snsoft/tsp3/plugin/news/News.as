package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.plugin.BPlugin;

	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;

	public class News extends BPlugin {
		public function News() {
			super();

			pluginCfg = new Object();
		}

		override protected function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var btnv:Vector.<NewsBtn> = new Vector.<NewsBtn>();
			for (var i:int = 0; i < 20; i++) {
				var nb:NewsBtn = new NewsBtn(new Point(48, 48), new BitmapData(100, 100), "这里的山路十八", 126);
				nb.buttonMode = true;

				var dto:NewsBtnDTO = new NewsBtnDTO();
				dto.text = "asdfasdf";

				nb.data = dto;
				btnv.push(nb);
			}

			var nbb:NewsBtnBox = new NewsBtnBox(btnv, 400);
			this.addChild(nbb);
			nbb.addEventListener(NewsBtnBox.EVENT_BTN_CLICK, handlerBtnClick);
		}

		private function handlerBtnClick(e:Event):void {
			var nbb:NewsBtnBox = e.currentTarget as NewsBtnBox;
			var btn:NewsBtn = nbb.clickBtn;
			var dto:NewsBtnDTO = btn.data as NewsBtnDTO;
			trace(dto.text);
		}
	}
}
