﻿package com.snsoft.tsp3.plugin.news {
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
	public class NewsItemIV extends NewsItemBase {

		private var boader2:int = 20;

		private var hMax:int = 35;

		private var wMax:int = 150;

		private var tft:TextFormat = new TextFormat(null, 14, 0xffffff);

		private var tft2:TextFormat = new TextFormat(null, 12, 0xaaaaaa);

		public function NewsItemIV(data:DataDTO) {
			super();
			this._data = data;
			itemHeight = hMax;
		}

		override public function draw():void {
			_clickType = null;
			boader = 20;

			addBack("IV");

			var pv:Vector.<DataParam> = data.params;

			if (pv != null) {
				var sv:Vector.<Sprite> = new Vector.<Sprite>();
				var pb:int = (itemWidth - boader - boader) / pv.length;
				for (var i:int = 0; i < pv.length; i++) {
					var pm:DataParam = pv[i];
					var spr:Sprite = new Sprite();
					this.addChild(spr);
					var ctnt:TextField = Util.ctntSameLine(pm.content, ctnttft, pb);
					spr.addChild(ctnt);
					sv.push(spr);
				}

				var sx:int = boader2;
				for (var j:int = 0; j < sv.length; j++) {
					var spr2:Sprite = sv[j];
					spr2.x = sx;
					sx += pb;
					spr2.y = (itemHeight - spr2.height) / 2;
				}

			}
		}

	}
}
