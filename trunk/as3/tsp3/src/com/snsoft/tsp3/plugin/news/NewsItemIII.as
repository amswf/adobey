package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *    图片
	 *    标题
	 * @author Administrator
	 *
	 */
	public class NewsItemIII extends NewsItemBase {

		private var hMax:int = 150;

		private var wMax:int = 150;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		public function NewsItemIII(data:DataDTO) {
			super();
			_autoRow = true;
			this._data = data;
		}

		override public function draw():void {
			var ndp:NewsDataParam = new NewsDataParam(data.params);

			itemHeight = hMax;
			itemWidth = wMax;

			addBack("III");

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);
			var title:TextField = Util.creatTextInline(tp.content, ctnttft, itemWidth - boader - boader);
			this.addChild(title);
			title.x = (itemWidth - title.width) / 2;
			title.y = itemHeight - boader - title.height;

			var img:Bitmap = new Bitmap(_data.img, "auto", true);
			this.addChild(img);
			img.x = boader;
			img.y = boader;
			img.width = itemWidth - boader - boader;
			img.height = title.y - boader;
			this.addChild(img);

		}
	}
}
