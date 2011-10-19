package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.html.HtmlExplorer;
	import com.snsoft.tsp3.net.DataDTO;
	import com.snsoft.tsp3.net.DataParam;
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

		private var titleLayer:Sprite = new Sprite();

		private var scrollLayer:Sprite = new Sprite();

		private var maskLayer:Sprite = new Sprite();

		private var hMax:int = 100;

		private var titletft:TextFormat = new TextFormat(null, 24, 0xffffff);

		private var texttft:TextFormat = new TextFormat(null, 14, 0xffffff);

		private var ctnttft:TextFormat = new TextFormat(null, 12, 0xffffff);

		public function NewsBoardI(infoSize:Point, data:DataDTO) {
			this.infoSize = infoSize;
			this._data = data;
			super();
		}

		override protected function configMS():void {
			this.addChild(titleLayer);
			this.addChild(scrollLayer);
			this.addChild(maskLayer);
		}

		override protected function draw():void {

			var ndp:NewsDataParam = new NewsDataParam(data.params);

			SpriteUtil.deleteAllChild(titleLayer);
			SpriteUtil.deleteAllChild(scrollLayer);
			SpriteUtil.deleteAllChild(maskLayer);

			var cw:int = infoSize.x - boader - boader;

			var title:Sprite = creatTitle(ndp.titleParam, cw);
			this.addChild(title);
			title.x = boader;

			var line2:Sprite =  creatLineText(ndp.keywordsParam, ndp.dateParam);
			this.addChild(line2);
			line2.x = (infoSize.x - line2.width) / 2;
			line2.y = title.getRect(this).bottom;

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

			var sfile:Sprite = creatSrc("附件", SRC_FILES, "NewsSrcBtn_fileSkin", data.files);
			scrollLayer.addChild(sfile);

			var t:Sprite = creatItemText(ndp.dateParam);
			scrollLayer.addChild(t);
			t.y = sfile.getRect(scrollLayer).bottom;

			var html:Sprite = creatItemHtml(ndp.digestParam, handler);
			html.y = t.getRect(scrollLayer).bottom;
			scrollLayer.addChild(html);
		}

		private function handler(e:Event):void {

		}

		private function creatSrc(text:String, type:String, skin:String, data:Vector.<DataParam>):Sprite {
			var sprite:Sprite = new Sprite();
			var tfd:TextField = creatTextTfd(text);
			sprite.addChild(tfd);

			var nisb:NewsInfoSrcBox = new NewsInfoSrcBox(skin, data, 200);
			sprite.addChild(nisb);
			nisb.y = tfd.height;
			return sprite;
		}

		private function creatItemHtml(dataParam:DataParam, handler:Function):Sprite {
			var sprite:Sprite = new Sprite();
			var tfd:TextField = creatTextTfd(dataParam.text);
			sprite.addChild(tfd);

			var hl:HtmlExplorer = new HtmlExplorer(infoSize.x - boader - boader);
			hl.mouseEnabled = false;
			sprite.addChild(hl);
			hl.y = tfd.height;
			hl.loadString(dataParam.content);
			hl.addEventListener(Event.COMPLETE, handler);
			return sprite;
		}

		private function creatItemText(dataParam:DataParam):Sprite {
			var sprite:Sprite = new Sprite();
			var tfd:TextField = creatTextTfd(dataParam.text);
			sprite.addChild(tfd);

			var ctfd:TextField = creatCtntTfd(dataParam.content);
			sprite.addChild(ctfd);
			ctfd.width = infoSize.x - boader - boader;
			ctfd.y = tfd.height;
			return sprite;
		}

		private function creatLineText(... dataParam):Sprite {
			var spr:Sprite = new Sprite();
			var x:int = 0;
			for (var i:int = 0; i < dataParam.length; i++) {
				var prm:DataParam = dataParam[i];
				var tt:TextField = creatTextTfd(prm.text);
				spr.addChild(tt);
				tt.x = x;
				x += tt.width;
				var tc:TextField = creatCtntTfd(prm.content);
				spr.addChild(tc);
				tc.x = x;
				x += tc.width;
			}
			return spr;
		}

		private function creatTitle(dataParam:DataParam, width:int):Sprite {
			var spr:Sprite = new Sprite();
			var title:TextField = new TextField();
			title.mouseEnabled = false;
			title.defaultTextFormat = titletft;
			title.autoSize = TextFieldAutoSize.CENTER;
			title.text = dataParam.content;
			title.width = width;
			spr.addChild(title);
			return spr;
		}

		private function creatTextTfd(text:String):TextField {
			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.defaultTextFormat = texttft;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = text + "：";
			return txt;
		}

		private function creatCtntTfd(text:String):TextField {
			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.defaultTextFormat = ctnttft;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = text;
			return txt;
		}
	}
}
