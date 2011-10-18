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
	 * 自动换行，不需要设置宽度
	 *    图片
	 *    标题
	 * @author Administrator
	 *
	 */
	public class NewsItemIV extends NewsItemBase {

		private var boader:int = 20;

		private var hMax:int = 150;

		private var wMax:int = 150;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		public function NewsItemIV(data:DataDTO) {
			super();
			_autoRow = true;
			this._data = data;
		}

		override public function draw():void {
			var ndp:NewsDataParam = new NewsDataParam(data.params);

			var title:TextField = new TextField();
			title.mouseEnabled = false;
			title.defaultTextFormat = tft;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.text = ndp.titleParam.content;
			this.addChild(title);
			title.x = (itemWidth - title.width) / 2;
			title.y = itemHeight - boader - title.height;
		}
	}
}
