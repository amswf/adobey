package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.html.HtmlExplorer;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsBoardI extends NewsBoardBase {

		private var backLayer:Sprite = new Sprite();

		private var infoLayer:Sprite = new Sprite();

		private var itemsLayer:Sprite = new Sprite();

		private var btnLayer:Sprite = new Sprite();

		private var hMax:int = 100;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		public function NewsBoardI(infoSize:Point, data:DataDTO) {
			this.infoSize = infoSize;
			this._data = data;
			super();
		}

		override protected function configMS():void {
			this.addChild(backLayer);
			this.addChild(infoLayer);
			this.addChild(itemsLayer);
			this.addChild(btnLayer);
		}

		override protected function draw():void {

			var ndp:NewsDataParam = new NewsDataParam(data.params);

			SpriteUtil.deleteAllChild(backLayer);
			SpriteUtil.deleteAllChild(infoLayer);
			SpriteUtil.deleteAllChild(itemsLayer);
			SpriteUtil.deleteAllChild(btnLayer);

			var cw:int = infoSize.x - boader - boader;

			var title:TextField = new TextField();
			title.defaultTextFormat = tft;
			title.autoSize = TextFieldAutoSize.CENTER;
			title.text = ndp.titleParam.content;
			this.addChild(title);
			title.x = boader;
			title.width = cw;

			var line2:Sprite = new Sprite();
			this.addChild(line2);
			line2.y = title.getRect(this).bottom + boader;

			var keywrd:TextField = new TextField();
			keywrd.defaultTextFormat = tft;
			keywrd.autoSize = TextFieldAutoSize.CENTER;
			keywrd.text = ndp.keywordsParam.text + "：" + ndp.keywordsParam.content;
			line2.addChild(keywrd);
			keywrd.x = boader;

			var date:TextField = new TextField();
			date.defaultTextFormat = tft;
			date.autoSize = TextFieldAutoSize.CENTER;
			keywrd.text = ndp.dateParam.text + "：" + ndp.dateParam.content;
			line2.addChild(date);
			date.x = boader + keywrd.getRect(line2).right;

			line2.x = (infoSize.x - line2.width) / 2;

			var heY:int = line2.getRect(this).bottom + boader;
			var heH:int = infoSize.y - heY - boader;
			var he:HtmlExplorer = new HtmlExplorer(new Point(cw, heH));
			this.addChild(he);
			he.loadString(ndp.digestParam.content);
			he.x = boader;
			he.y = heY;
		}
	}
}
