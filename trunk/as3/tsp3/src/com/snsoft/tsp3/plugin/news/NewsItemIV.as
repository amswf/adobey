package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
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

		private var hMax:int = 80;

		private var wMax:int = 150;

		private var tft:TextFormat = new TextFormat(null, 14, 0xffffff);

		private var tft2:TextFormat = new TextFormat(null, 12, 0xaaaaaa);

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		public function NewsItemIV(data:DataDTO) {
			super();
			this._data = data;
		}

		override public function draw():void {
			boader = 20;

			itemHeight = hMax;

			defBack = SkinsUtil.createSkinByName("NewsItemsIV_backDefSkin");
			defBack.width = itemWidth;
			defBack.height = itemHeight;
			this.addChild(defBack);

			selBack = SkinsUtil.createSkinByName("NewsItemsIV_backSelSkin");
			selBack.width = itemWidth;
			selBack.height = itemHeight;
			selBack.visible = false;
			this.addChild(selBack);

			var pv:Vector.<DataParam> = data.params;

			if (pv != null) {
				var sv:Vector.<Sprite> = new Vector.<Sprite>();
				for (var i:int = 0; i < pv.length; i++) {
					var pm:DataParam = pv[i];
					var spr:Sprite = creatRowSpr(pm);
					this.addChild(spr);
					sv.push(spr);
				}

				var pb:int = (itemWidth - boader - boader) / sv.length;
				var sx:int = boader + boader2;
				for (var j:int = 0; j < sv.length; j++) {
					var spr2:Sprite = sv[j];
					spr2.x = sx;
					sx += pb;
					spr2.y = (itemHeight - spr2.height) / 2;
				}

			}
		}

		private function creatRowSpr(param:DataParam):Sprite {
			var spr:Sprite = new Sprite();

			var ctnt:TextField = new TextField();
			ctnt.mouseEnabled = false;
			ctnt.defaultTextFormat = tft;
			ctnt.autoSize = TextFieldAutoSize.LEFT;
			ctnt.text = param.content;
			spr.addChild(ctnt);

			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.defaultTextFormat = tft2;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = param.text;
			spr.addChild(txt);

			txt.y = ctnt.height;
			return spr;
		}
	}
}
