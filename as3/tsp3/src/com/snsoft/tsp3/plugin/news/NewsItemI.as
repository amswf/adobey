package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsItemI extends NewsItemBase {

		private var boader:int = 10;

		private var hMax:int = 100;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		private var data:DataDTO;

		public function NewsItemI(data:DataDTO) {
			super();
			this.data = data;
		}

		override public function draw():void {
			itemHeight = hMax;

			defBack = SkinsUtil.createSkinByName("NewsItems_backDefSkin");
			defBack.width = itemWidth;
			defBack.height = itemHeight;
			this.addChild(defBack);

			selBack = SkinsUtil.createSkinByName("NewsItems_backSelSkin");
			selBack.width = itemWidth;
			selBack.height = itemHeight;
			selBack.visible = false;
			this.addChild(selBack);

			var imgh:int = itemHeight - boader - boader;
			var imgw:int = imgh * 1.33;

			var img:Bitmap = new Bitmap(data.img, "auto", true);
			this.addChild(img);
			img.x = boader;
			img.y = boader;
			img.width = imgw;
			img.height = imgh;
			this.addChild(img);

			var title:TextField = new TextField();
			title.defaultTextFormat = tft;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.mouseEnabled = false;
			title.text = "标题：" + data.getParam(PARAM_TITLE);
			this.addChild(title);
			title.x = img.getRect(this).right + boader;
			title.y = boader;

			var date:TextField = new TextField();
			date.defaultTextFormat = tft;
			date.autoSize = TextFieldAutoSize.LEFT;
			date.mouseEnabled = false;
			date.text = "日期：" + data.getParam(PARAM_DATE);
			this.addChild(date);
			date.x = title.getRect(this).right + boader;
			date.y = boader;

			var keywords:TextField = new TextField();
			keywords.defaultTextFormat = tft;
			keywords.autoSize = TextFieldAutoSize.LEFT;
			keywords.mouseEnabled = false;
			keywords.text = "关键字：" + data.getParam(PARAM_KEYWORDS);
			this.addChild(keywords);
			keywords.x = date.getRect(this).right + boader;
			keywords.y = boader;

			var digest:TextField = new TextField();
			digest.defaultTextFormat = tft;
			digest.mouseEnabled = false;
			digest.multiline = true;
			digest.wordWrap = true;
			digest.text = "摘要：" + data.getParam(PARAM_DIGEST);
			this.addChild(digest);
			digest.x = img.getRect(this).right + boader;
			digest.y = title.getRect(this).bottom + boader;
			digest.width = itemWidth - boader - digest.x;
			digest.height = itemHeight - boader - digest.y;
		}
	}
}