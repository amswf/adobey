package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.plugin.news.layout.Util;
	import com.snsoft.tsp3.touch.TouchDrag;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.html.HTMLLoader;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class NewsBoardBase extends MySprite {

		protected static const PARAM_TYPE_TEXT:String = "text";
		protected static const PARAM_TYPE_MULTY_TEXT:String = "mtext";
		protected static const PARAM_TYPE_HTML:String = "html";

		protected const SRC_PARAMS:String = "params";
		protected const SRC_IMAGES:String = "images";
		protected const SRC_FILES:String = "files";
		protected const SRC_AUDIOS:String = "audios";
		protected const SRC_VIDEOS:String = "videos";

		public static const INFO_TYPE_I:String = "I";
		public static const INFO_TYPE_II:String = "II";
		public static const INFO_TYPE_III:String = "III";

		protected var _data:DataDTO;

		protected var infoSize:Point;

		protected var boader:int = 10;

		protected var ctntWidth:int;

		protected var titleLayer:Sprite = new Sprite();

		protected var scrollLayer:Sprite = new Sprite();

		protected var maskLayer:Sprite = new Sprite();

		protected var scrollBack:Sprite;

		protected var titletft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 18, 0x0657b7);

		protected var subheadtft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 13, 0x9f9f9f);

		protected var itemtft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName(Common.FONT_YH), 14, 0x575757);

		protected var nextY:int = boader;

		public function NewsBoardBase() {
			super();
		}

		protected function addBaseItems(ndp:NewsDataParam):void {
			var cw:int = ctntWidth;

			var h:int = 0;

			var titleBack:Sprite = SkinsUtil.createSkinByName("NewsBoard_titleBackSkin");
			this.addChild(titleBack);
			titleBack.x = boader;

			var titledp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_TITLE);
			if (titledp != null) {
				var title:TextField = Util.ctntSameLine(titledp.content, titletft, cw);
				this.addChild(title);
				title.x = (infoSize.x - title.width) / 2;
				h += title.getRect(this).bottom;
			}

			var l2v:Vector.<DataParam> = new Vector.<DataParam>();
			l2v.push(ndp.getIntrParam(NewsDataParam.PARAM_COMEFROM));
			l2v.push(ndp.getIntrParam(NewsDataParam.PARAM_AUTHOR));
			l2v.push(ndp.getIntrParam(NewsDataParam.PARAM_KEYWORDS));
			l2v.push(ndp.getIntrParam(NewsDataParam.PARAM_DATE));
			var line2:Sprite =  Util.lineItemsSameLine(l2v, subheadtft, subheadtft, cw, boader);
			this.addChild(line2);
			line2.x = (infoSize.x - line2.width) / 2;
			line2.y = h + boader;

			titleBack.width = cw;
			titleBack.height = line2.getRect(this).bottom + boader;

			var sx:int = boader;
			var sy:int = titleBack.getRect(this).bottom + boader;
			var sw:int = cw;
			var sh:int = infoSize.y - sy;

			var msk:Sprite = ViewUtil.creatRect(sw, sh);
			maskLayer.addChild(msk);
			maskLayer.x = sx;
			maskLayer.y = sy;

			scrollLayer.mask = maskLayer;
			scrollLayer.x = sx;
			scrollLayer.y = sy;

			scrollBack = ViewUtil.creatRect(100, 100);
			scrollLayer.addChild(scrollBack);
		}

		protected function addExpItems(ndp:NewsDataParam):void {
			//扩展信息输出
			var eps:Vector.<DataParam> = ndp.extParams;
			if (eps != null) {
				var spr:Sprite = Util.rowItemsMultiLine(eps, itemtft, itemtft, infoSize.x - boader - boader);
				scrollLayer.addChild(spr);
				spr.y = nextY;
				nextY = spr.getRect(scrollLayer).bottom + boader;
			}
		}

		protected function addDigest(ndp:NewsDataParam):void {
			//内容单独输出，并且在最后
			var dp:DataParam = ndp.getIntrParam(NewsDataParam.PARAM_DIGEST);
			if (dp.type == PARAM_TYPE_HTML) {
				if (dp != null) {
					var html:Sprite = creatItemHtml(dp);
					scrollLayer.addChild(html);
					html.y = nextY;
				}
			}
			else {
				if (dp != null) {
					var v:Vector.<DataParam> = new Vector.<DataParam>();
					v.push(dp);
					var dig:Sprite = Util.rowItemsMultiLine(v, itemtft, itemtft, infoSize.x - boader - boader);
					scrollLayer.addChild(dig);
					dig.y = nextY;
				}
				addDragEvent();
			}
		}

		protected function addSrcs(data:DataDTO):void {
			addSrcItem("附件", SRC_FILES, "NewsSrcBtn_fileSkin", data.files);
			addSrcItem("图片", SRC_IMAGES, "NewsSrcBtn_imgSkin", data.images);
			addSrcItem("音乐", SRC_AUDIOS, "NewsSrcBtn_audioSkin", data.audios);
			addSrcItem(" 影片", SRC_VIDEOS, "NewsSrcBtn_videoSkin", data.videos);
		}

		private function addSrcItem(text:String, type:String, skin:String, data:Vector.<DataParam>):void {
			if (data != null && data.length > 0) {
				var sprite:Sprite = null;
				if (type == SRC_IMAGES) {
					sprite = new ImageBook(data, ctntWidth, maskLayer.height - boader - boader);
					sprite.addEventListener(ImageBook.EVENT_BTN_CLICK, handlerImageBookBtnClick);
				}
				else {
					sprite = creatSrc(text, type, skin, data);
				}
				scrollLayer.addChild(sprite);
				sprite.y = nextY;
				nextY = sprite.getRect(scrollLayer).bottom + boader;
			}
		}

		private function handlerImageBookBtnClick(e:Event):void {
			var ib:ImageBook = e.currentTarget as ImageBook;
			var endy:int = maskLayer.y - ib.y + boader;

			var twn1:fl.transitions.Tween = new Tween(scrollLayer, "y", Regular.easeOut, scrollLayer.y, endy, 0.3, true);
		}

		protected function creatItemHtml(dataParam:DataParam):Sprite {
			var sprite:Sprite = new Sprite();
			var tfd:TextField = Util.label(dataParam.text, itemtft);
			sprite.addChild(tfd);

			var html:HTMLLoader = new HTMLLoader();
			sprite.addChild(html);
			html.y = tfd.height;
			html.width = ctntWidth;
			html.addEventListener(Event.COMPLETE, handlerHtmlLoadCmp);
			html.loadString(dataParam.content);
			return sprite;
		}

		protected function handlerHtmlLoadCmp(e:Event):void {
			var html:HTMLLoader = e.currentTarget as HTMLLoader;
			html.height = html.contentHeight;

			var hid:Sprite = ViewUtil.creatRect(ctntWidth, html.contentHeight);
			html.parent.addChild(hid);

			addDragEvent();
		}

		protected function addDragEvent():void {

			scrollBack.width = ctntWidth;
			scrollBack.height = scrollLayer.height;
			var y:int = Math.max(scrollLayer.height - maskLayer.height, 0);
			var h:int = y;
			var rect:Rectangle  = new Rectangle(scrollLayer.x, scrollLayer.y - y, 0, h);
			var td:TouchDrag = new TouchDrag(scrollLayer, stage, rect, 0);
		}

		protected function creatSrc(text:String, type:String, skin:String, data:Vector.<DataParam>):Sprite {
			var sprite:Sprite = new Sprite();
			var tfd:TextField = Util.label(text, itemtft);
			sprite.addChild(tfd);

			var nisb:NewsInfoSrcBox = new NewsInfoSrcBox(skin, data, 200);
			sprite.addChild(nisb);
			nisb.y = tfd.height;
			return sprite;
		}

		protected function creatImage(bmd:BitmapData, width:int, height:int):Sprite {
			var sprite:Sprite = new Sprite();
			var bm:Bitmap = new Bitmap(bmd, "auto", true);
			sprite.addChild(bm);
			bm.width = width;
			bm.height = height;
			return sprite;
		}

		public function get data():DataDTO {
			return _data;
		}

		public function set data(value:DataDTO):void {
			_data = value;
		}

	}
}
