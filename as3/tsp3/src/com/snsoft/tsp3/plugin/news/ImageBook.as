package com.snsoft.tsp3.plugin.news {

	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ImageBook extends MySprite {

		public static const EVENT_BTN_CLICK:String = "btnClick";

		public static const DISPLAY_STATE_DEF:String = "def";

		public static const DISPLAY_STATE_FULLSCREEN:String = "fullScreen";

		private var data:Vector.<DataParam>;

		private var bookWidth:int;

		private var bookHeight:int;

		private var backLayer:Sprite = new Sprite();

		private var btnLayer:Sprite = new Sprite();

		private var imgLayer:Sprite = new Sprite();

		private var mskLayer:Sprite = new Sprite();

		private var msk:Sprite;

		private var back:MovieClip;

		private var lbtn:MovieClip;

		private var rbtn:MovieClip;

		private var cbw:int;

		private var cbh:int;

		private var boader:int = 10;

		private var boader2:int = 0;

		private var currentImg:Sprite;

		private var nextImg:Sprite;

		private var currentIndex:int = 0;

		private var lock:Boolean = false;

		private var msgtfd:TextField;

		protected var texttft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_HZGBYS), 14, 0x575757);

		public function ImageBook(data:Vector.<DataParam>, bookWidth:int, bookHeight:int) {
			this.data = data;
			this.bookHeight = bookHeight;
			this.bookWidth = bookWidth;
			super();
		}

		override protected function draw():void {
			this.addChild(backLayer);
			this.addChild(mskLayer);
			this.addChild(imgLayer);
			this.addChild(btnLayer);

			back = SkinsUtil.createSkinByName("ImageBook_backDefSkin");
			backLayer.addChild(back);

			msk = ViewUtil.creatRect(100, 100);
			mskLayer.addChild(msk);

			lbtn = SkinsUtil.createSkinByName("ImageBook_btnLeftDefSkin");
			btnLayer.addChild(lbtn);
			lbtn.buttonMode = true;
			lbtn.addEventListener(MouseEvent.CLICK, handlerLClick);

			rbtn = SkinsUtil.createSkinByName("ImageBook_btnRightDefSkin");
			btnLayer.addChild(rbtn);
			rbtn.buttonMode = true;
			rbtn.addEventListener(MouseEvent.CLICK, handlerRClick);

			imgLayer.mask = mskLayer;
			imgLayer.x = boader + lbtn.width + boader;
			imgLayer.y = boader;

			mskLayer.x = boader + lbtn.width + boader;
			mskLayer.y = boader;

			msgtfd = Util.ctntSameLine("", texttft);
			btnLayer.addChild(msgtfd);

			setDisplayState(DISPLAY_STATE_DEF);

			if (data.length > 0) {
				currentImg = creatImg(0);
				imgLayer.addChild(currentImg);
				trace("currentImg", currentImg.width);
			}

			setMsg("(1/" + data.length + ")");
		}

		private function setMsg(msg:String):void {
			msgtfd.text = msg;
			msgtfd.x = cbw - msgtfd.width - boader;
			msgtfd.y = boader;
		}

		private function creatImg(index:int):Sprite {
			var dto:DataParam = data[index];
			var img:Bitmap = new Bitmap(dto.img, "auto", true);

			var imgw:int = msk.width;
			var imgh:int = msk.height;

			var scale:Number = 1;
			if (img.height > imgh || img.width > imgw) {
				var pw:Number = imgw / img.width;
				var ph:Number = imgh / img.height;
				if (pw <= ph) {
					scale = pw;
				}
				else {
					scale = ph;
				}
			}
			img.width = int(img.width * scale);
			img.height = int(img.height * scale);
			img.x = (imgw - img.width) / 2;
			img.y = (imgh - img.height) / 2;

			var sprite:Sprite = new Sprite();
			sprite.addChild(img);
			return sprite;
		}

		private function handlerLClick(e:Event):void {
			moveImg(currentIndex - 1);
			this.dispatchEvent(new Event(EVENT_BTN_CLICK));
		}

		private function handlerRClick(e:Event):void {
			moveImg(currentIndex + 1);
			this.dispatchEvent(new Event(EVENT_BTN_CLICK));
		}

		private function moveImg(index:int):void {
			trace("moveImg", index);
			if (!lock && index != currentIndex && index >= 0 && index < data.length) {
				lock = true;
				var sign:int = index > currentIndex ? 1 : -1;
				currentIndex = index;

				nextImg = creatImg(index);
				imgLayer.addChild(nextImg);

				var twn1:fl.transitions.Tween = new Tween(currentImg, "x", Regular.easeOut, 0, -sign * msk.width, 0.3, true);
				var twn2:fl.transitions.Tween = new Tween(currentImg, "alpha", Regular.easeOut, 1, 0, 0.3, true);

				var twn3:fl.transitions.Tween = new Tween(nextImg, "x", Regular.easeOut, sign * msk.width, 0, 0.3, true);
				var twn4:fl.transitions.Tween = new Tween(nextImg, "alpha", Regular.easeOut, 0, 1, 0.3, true);
				twn4.addEventListener(TweenEvent.MOTION_FINISH, handlerMotionFinish);
			}
		}

		private function handlerMotionFinish(e:Event):void {
			setMsg("(" + (currentIndex + 1) + "/" + data.length + ")");
			imgLayer.removeChild(currentImg);
			currentImg = nextImg;
			lock = false;
		}

		public function setDisplayState(state:String):void {

			if (DISPLAY_STATE_DEF == state) {
				cbw = bookWidth;
				cbh = bookHeight;
			}
			else if (DISPLAY_STATE_FULLSCREEN == state) {
				cbw = stage.stageWidth;
				cbh = stage.stageHeight;
			}

			msk.width = cbw - boader * 4 - lbtn.width - rbtn.width;
			msk.height = cbh - boader - boader - boader2;

			back.width = cbw;
			back.height = cbh;

			lbtn.x = boader;
			lbtn.y = (cbh + boader2 - lbtn.height) / 2;

			rbtn.x = cbw - boader - rbtn.width;
			rbtn.y = (cbh + boader2 - rbtn.height) / 2;

			setMsg(msgtfd.text);
		}

	}
}
