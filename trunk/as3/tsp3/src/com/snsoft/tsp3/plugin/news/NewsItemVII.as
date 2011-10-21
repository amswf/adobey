package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 *    图片
	 *    标题
	 *    日期
	 *
	 *   可点击图片播放，点击文字进入
	 * @author Administrator
	 *
	 */
	public class NewsItemVII extends NewsItemBase {

		private var boader:int = 20;

		private var hMax:int = 180;

		private var wMax:int = 150;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var defBack:MovieClip;

		private var selBack:MovieClip;

		private var isPlayMouseDown:Boolean = false;
		private var isInfoMouseDown:Boolean = false;

		public function NewsItemVII(data:DataDTO) {
			super();
			_autoRow = true;
			this._data = data;
		}

		override public function draw():void {
			var ndp:NewsDataParam = new NewsDataParam(data.params);

			itemHeight = hMax;
			itemWidth = wMax;
			defBack = SkinsUtil.createSkinByName("NewsItemsVII_backDefSkin");
			defBack.width = itemWidth;
			defBack.height = itemHeight;
			this.addChild(defBack);

			selBack = SkinsUtil.createSkinByName("NewsItemsVII_backSelSkin");
			selBack.width = itemWidth;
			selBack.height = itemHeight;
			selBack.visible = false;
			this.addChild(selBack);

			var date:TextField = new TextField();
			date.mouseEnabled = false;
			date.defaultTextFormat = tft;
			date.autoSize = TextFieldAutoSize.LEFT;
			var dp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DATE);
			date.text = dp.text + "：" + dp.content;
			this.addChild(date);
			date.x = (itemWidth - date.width) / 2;
			date.y = itemHeight - boader - date.height;

			var title:TextField = new TextField();
			title.mouseEnabled = false;
			title.defaultTextFormat = tft;
			title.autoSize = TextFieldAutoSize.LEFT;
			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);
			title.text = tp.text + "：" + tp.content;
			this.addChild(title);
			title.x = (itemWidth - title.width) / 2;
			title.y = date.y - title.height;

			var infoH:int = itemHeight - title.y - boader;
			var infoBtn:Sprite = ViewUtil.creatRect(itemWidth, infoH);
			this.addChild(infoBtn);
			infoBtn.x = boader;
			infoBtn.y = title.y;
			infoBtn.buttonMode = true;
			infoBtn.addEventListener(MouseEvent.MOUSE_DOWN, handlerInfoMouseDown);
			infoBtn.addEventListener(MouseEvent.MOUSE_UP, handlerInfoMouseUp);

			var imgspr:Sprite = new Sprite();
			this.addChild(imgspr);
			imgspr.x = boader;
			imgspr.y = boader;

			var img:Bitmap = new Bitmap(_data.img, "auto", true);
			imgspr.addChild(img);
			img.width = itemWidth - boader - boader;
			img.height = title.y - boader;
			imgspr.addChild(img);

			var play:MovieClip = SkinsUtil.createSkinByName("NewsItemsVII_playDefSkin");
			imgspr.addChild(play);
			play.x = (img.width - play.width) / 2;
			play.y = (img.height - play.height) / 2;

			play.buttonMode = true;
			play.addEventListener(MouseEvent.MOUSE_DOWN, handlerPlayMouseDown);
			play.addEventListener(MouseEvent.MOUSE_UP, handlerPlayMouseUp);
		}

		private function handlerInfoMouseDown(e:Event):void {
			isInfoMouseDown = true;
		}

		private function handlerInfoMouseUp(e:Event):void {
			if (isInfoMouseDown) {
				_clickType = CLICK_TYPE_INFO;
				isInfoMouseDown = false;
			}
		}

		private function handlerPlayMouseDown(e:Event):void {
			isPlayMouseDown = true;
		}

		private function handlerPlayMouseUp(e:Event):void {
			if (isPlayMouseDown) {
				_clickType = CLICK_TYPE_PLAY;
				isPlayMouseDown = false;
			}

		}
	}
}
