package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 市场行情
	 *
	 *
	 * @author Administrator
	 *
	 */
	public class NewsItemHead extends NewsItemBase {

		//字间距
		private var boader2:int = 20;

		//文字高度修正
		private var boader3:int = 0;

		private var boaderlr:int = 20;

		private var hMax:int = 60;

		private var wMax:int = 150;

		public function NewsItemHead(data:DataDTO) {
			super();
			this._data = data;
			itemHeight = hMax;
		}

		override public function draw():void {
			_clickType = null;
			boader = 25;

			addBack("Head");

			var pv:Vector.<DataParam> = data.params;

			if (pv != null) {
				var sv:Vector.<Sprite> = new Vector.<Sprite>();
				var pb:int = (itemWidth - boader - boader - boaderlr - boaderlr) / pv.length;
				for (var i:int = 0; i < pv.length; i++) {
					var pm:DataParam = pv[i];
					var spr:Sprite = new Sprite();
					this.addChild(spr);
					spr.y = boader3;
					var txt:TextField = Util.ctntSameLine(pm.text, headtft);
					spr.addChild(txt);
					sv.push(spr);
				}

				var sx:int = boader2 + boader;
				for (var j:int = 0; j < sv.length; j++) {
					var spr2:Sprite = sv[j];
					spr2.x = sx;
					sx += pb;
					spr2.y = (itemHeight - spr2.height) / 2 + boader3;
				}

			}
		}

	}
}
