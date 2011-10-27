package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	/**
	 *
	 *    标题   播放按钮  详细按钮
	 *
	 *
	 *   可点击图片播放，点击文字进入
	 * @author Administrator
	 *
	 */
	public class NewsItemVIII extends NewsItemBase {

		private var hMax:int = 88;

		private var wMax:int = 150;

		private var tft:TextFormat = new TextFormat(null, 12, 0xffffff);

		private var isPlayMouseDown:Boolean = false;

		private var isInfoMouseDown:Boolean = false;

		public function NewsItemVIII(data:DataDTO) {
			super();
			this._data = data;
		}

		override public function draw():void {
			boader = 20;

			var ndp:NewsDataParam = new NewsDataParam(data.params);

			itemHeight = hMax;

			addBack("VIII");

			var infoBtn:MovieClip = SkinsUtil.createSkinByName("NewsItemsVIII_ctntDefSkin");
			this.addChild(infoBtn);
			infoBtn.x = itemWidth - boader - infoBtn.width;
			infoBtn.y = (itemHeight - infoBtn.height) / 2;
			infoBtn.buttonMode = true;
			infoBtn.addEventListener(MouseEvent.MOUSE_DOWN, handlerInfoMouseDown);
			infoBtn.addEventListener(MouseEvent.MOUSE_UP, handlerInfoMouseUp);

			var playBtn:MovieClip = SkinsUtil.createSkinByName("NewsItemsVIII_playDefSkin");
			this.addChild(playBtn);
			playBtn.x = infoBtn.x - boader - playBtn.width;
			playBtn.y = (itemHeight - playBtn.height) / 2;
			playBtn.buttonMode = true;
			playBtn.addEventListener(MouseEvent.MOUSE_DOWN, handlerPlayMouseDown);
			playBtn.addEventListener(MouseEvent.MOUSE_UP, handlerPlayMouseUp);

			var tp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);
			var title:Sprite = Util.lineItem(tp.text, tp.content, texttft, ctnttft, playBtn.x - boader);
			this.addChild(title);
			title.x = boader;
			title.y = (itemHeight - title.height) / 2;

			this.addEventListener(MouseEvent.MOUSE_DOWN, handlerThisMouseDown);
		}

		private function handlerThisMouseDown(e:Event):void {
			_clickType = null;
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
