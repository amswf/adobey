package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
	import com.snsoft.tsp3.touch.TouchDrag;
	
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

		protected var titletft:TextFormat = new TextFormat(null, 24, 0xffffff);

		protected var texttft:TextFormat = new TextFormat(null, 14, 0xffffff);

		protected var ctnttft:TextFormat = new TextFormat(null, 12, 0xffffff);

		protected var nextY:int = boader;

		public function NewsBoardBase() {
			super();
		}

		protected function addBaseItems(ndp:NewsDataParam):void {
			var cw:int = ctntWidth;

			var title:Sprite = creatTitle(ndp.getIntrParam(NewsDataParam.PARAM_TITLE), cw);
			this.addChild(title);
			title.x = boader;

			var line2:Sprite =  creatLineText(ndp.getIntrParam(NewsDataParam.PARAM_COMEFROM),
				ndp.getIntrParam(NewsDataParam.PARAM_AUTHOR),
				ndp.getIntrParam(NewsDataParam.PARAM_KEYWORDS),
				ndp.getIntrParam(NewsDataParam.PARAM_DATE));
			this.addChild(line2);
			line2.x = (infoSize.x - line2.width) / 2;
			line2.y = title.getRect(this).bottom + boader;

			var sx:int = boader;
			var sy:int = line2.getRect(this).bottom + boader;
			var sw:int = cw;
			var sh:int = infoSize.y - sy - boader;

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

		protected function addLineText(... dataParam):void {
			//扩展信息输出
			if (dataParam != null) {
				for (var i:int = 0; i < dataParam.length; i++) {
					var ep:DataParam = dataParam[i];
					var spr:Sprite = creatLineText.apply(null, dataParam);
					scrollLayer.addChild(spr);
					spr.y = nextY;
					nextY = spr.getRect(scrollLayer).bottom + boader;
				}
			}
		}

		protected function addItems(params:Vector.<DataParam>):void {
			//扩展信息输出
			if (params != null) {
				for (var i:int = 0; i < params.length; i++) {
					var ep:DataParam = params[i];
					var spr:Sprite = creatItemTexts(ep);
					scrollLayer.addChild(spr);
					spr.y = nextY;
					nextY = spr.getRect(scrollLayer).bottom + boader;
				}
			}
		}

		protected function addExpItems(ndp:NewsDataParam):void {
			//扩展信息输出
			var eps:Vector.<DataParam> = ndp.extParams;
			if (eps != null) {
				for (var i:int = 0; i < eps.length; i++) {
					var ep:DataParam = eps[i];
					var spr:Sprite = creatItemTexts(ep);
					scrollLayer.addChild(spr);
					spr.y = nextY;
					nextY = spr.getRect(scrollLayer).bottom + boader;
				}
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
					var dig:Sprite = creatItemTexts(dp);
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
				}
				else {
					sprite = creatSrc(text, type, skin, data);
				}
				scrollLayer.addChild(sprite);
				sprite.y = nextY;
				nextY = sprite.getRect(scrollLayer).bottom + boader;
			}
		}

		protected function creatItemHtml(dataParam:DataParam):Sprite {
			var sprite:Sprite = new Sprite();
			var tfd:TextField = creatTextTfd(dataParam.text);
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
			var h:int = scrollLayer.height - maskLayer.height;
			var rect:Rectangle  = new Rectangle(scrollLayer.x, scrollLayer.y - h, 0, h);
			var td:TouchDrag = new TouchDrag(scrollLayer, stage, rect, 0);
		}

		protected function creatSrc(text:String, type:String, skin:String, data:Vector.<DataParam>):Sprite {
			var sprite:Sprite = new Sprite();
			var tfd:TextField = creatTextTfd(text);
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

		/**
		 * 属性多行显示，属性名和值不同在同一行
		 * @param dataParam
		 * @return
		 *
		 */
		protected function creatItemTexts(... dataParam):Sprite {
			var sprite:Sprite = new Sprite();
			for (var i:int = 0; i < dataParam.length; i++) {
				var prm:DataParam = dataParam[i] as DataParam;
				if (prm != null && prm.text != null && prm.content != null) {
					var tfd:TextField = creatTextTfd(prm.text);
					sprite.addChild(tfd);

					var ctfd:TextField = creatCtntTfd(prm.content);
					sprite.addChild(ctfd);
					ctfd.width = ctntWidth;
					ctfd.y = tfd.height;
				}
			}
			return sprite;
		}

		/**
		 * 属性名称和值在同一行，多个属性多行显示
		 * @param dataParam
		 * @return
		 *
		 */
		protected function creatItemsLine(... dataParam):Sprite {
			var spr:Sprite = new Sprite();
			var y:int = 0;
			for (var i:int = 0; i < dataParam.length; i++) {
				var prm:DataParam = dataParam[i] as DataParam;
				if (prm != null && prm.text != null && prm.content != null) {
					var lt:Sprite = creatLineText(prm);
					spr.addChild(lt);
					lt.y = y;
					y += lt.height;
				}
			}
			return spr;
		}

		/**
		 * 一行，多属性输出
		 * @param dataParam
		 * @return
		 *
		 */
		protected function creatLineText(... dataParam):Sprite {
			var spr:Sprite = new Sprite();
			var x:int = 0;
			for (var i:int = 0; i < dataParam.length; i++) {
				var prm:DataParam = dataParam[i] as DataParam;
				if (prm != null && prm.text != null && prm.content != null) {
					var tt:TextField = creatTextTfd(prm.text);
					spr.addChild(tt);
					tt.x = x;
					x += tt.width;
					var tc:TextField = creatCtntTfd(prm.content);
					spr.addChild(tc);
					tc.x = x;
					x += tc.width;
				}
			}
			return spr;
		}

		protected function creatTitle(dataParam:DataParam, width:int):Sprite {
			var spr:Sprite = new Sprite();
			if (dataParam != null && dataParam.content != null) {
				var title:TextField = new TextField();
				title.mouseEnabled = false;
				title.defaultTextFormat = titletft;
				title.autoSize = TextFieldAutoSize.CENTER;
				title.text = dataParam.content;
				title.width = width;
				spr.addChild(title);
			}
			return spr;
		}

		protected function creatTextTfd(text:String):TextField {
			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.defaultTextFormat = texttft;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = text + "：";
			return txt;
		}

		protected function creatCtntTfd(text:String):TextField {
			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.defaultTextFormat = ctnttft;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = text;
			txt.wordWrap = true;
			return txt;
		}

		public function get data():DataDTO {
			return _data;
		}

		public function set data(value:DataDTO):void {
			_data = value;
		}

	}
}
