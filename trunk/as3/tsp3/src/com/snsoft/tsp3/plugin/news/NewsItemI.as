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

	/**
	 * 图片、标题、日期、关键字
	 * 详细信息
	 * @author Administrator
	 *
	 */
	public class NewsItemI extends NewsItemBase {

		private var boader:int = 10;

		private var hMax:int = 100;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		public function NewsItemI(data:DataDTO) {
			super();
			this._data = data;
		}

		override public function draw():void {

			var ndp:NewsDataParam = new NewsDataParam(data.params);

			itemHeight = hMax;

			defBack = SkinsUtil.createSkinByName("NewsItemsI_backDefSkin");
			defBack.width = itemWidth;
			defBack.height = itemHeight;
			this.addChild(defBack);

			selBack = SkinsUtil.createSkinByName("NewsItemsI_backSelSkin");
			selBack.width = itemWidth;
			selBack.height = itemHeight;
			selBack.visible = false;
			this.addChild(selBack);

			var imgh:int = itemHeight - boader - boader;
			var imgw:int = imgh * 1.33;

			var img:Bitmap = new Bitmap(_data.img, "auto", true);
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
			title.text = ndp.titleParam.text + "：" + ndp.titleParam.content;
			this.addChild(title);
			title.x = img.getRect(this).right + boader;
			title.y = boader;

			var date:TextField = new TextField();
			date.defaultTextFormat = tft;
			date.autoSize = TextFieldAutoSize.LEFT;
			date.mouseEnabled = false;
			date.text = ndp.dateParam.text + "：" + ndp.dateParam.content;
			this.addChild(date);
			date.x = title.getRect(this).right + boader;
			date.y = boader;

			var keywords:TextField = new TextField();
			keywords.defaultTextFormat = tft;
			keywords.autoSize = TextFieldAutoSize.LEFT;
			keywords.mouseEnabled = false;
			keywords.text = ndp.keywordsParam.text + "：" + ndp.keywordsParam.content;
			this.addChild(keywords);
			keywords.x = date.getRect(this).right + boader;
			keywords.y = boader;

			var digest:TextField = new TextField();
			digest.defaultTextFormat = tft;
			digest.mouseEnabled = false;
			digest.multiline = true;
			digest.wordWrap = true;
			digest.text = ndp.digestParam.text + "：" + ndp.digestParam.content;
			this.addChild(digest);
			digest.x = img.getRect(this).right + boader;
			digest.y = title.getRect(this).bottom + boader;
			digest.width = itemWidth - boader - digest.x;
			digest.height = itemHeight - boader - digest.y;
		}
	}
}
