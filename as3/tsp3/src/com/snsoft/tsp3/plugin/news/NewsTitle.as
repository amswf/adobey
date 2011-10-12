package com.snsoft.tsp3.plugin.news {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.plugin.news.dto.NewsTitleDTO;
	import com.snsoft.util.SkinsUtil;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class NewsTitle extends Sprite {

		public static const EVENT_MIN:String = "event_min";

		public static const EVENT_CLOSE:String = "event_close";

		public static const EVENT_SEARCH:String = "event_search";

		private var dto:NewsTitleDTO;

		private var searchBtn:NewsTextBtn;

		private var minimizeBtn:Sprite;

		private var closeBtn:Sprite;

		private var minimiseBtn:Sprite;

		private var boader:int = 10;

		private var imgSize:Point = new Point(48, 48);

		private var titleWidth:int;

		private var titleHeight:int;

		private var titleTft:TextFormat = new TextFormat(null, 14, 0x000000);

		public function NewsTitle(dto:NewsTitleDTO, titleWidth:int, titleHeight:int) {
			this.titleHeight = titleHeight;
			this.titleWidth = titleWidth;
			this.dto = dto;
			init();
		}

		private function init():void {

			//背景
			var back:Sprite = ViewUtil.creatRect(titleWidth, titleHeight);
			this.addChild(back);

			//标题图片
			var titlebm:Bitmap = new Bitmap(dto.titleImg, "auto", true);
			titlebm.width = imgSize.x;
			titlebm.height = imgSize.y;
			titlebm.x = boader;
			titlebm.y = boader;
			this.addChild(titlebm);

			//标题
			var titleTfd:TextField = new TextField();
			titleTfd.defaultTextFormat = titleTft;
			titleTfd.autoSize = TextFieldAutoSize.LEFT;
			titleTfd.text = dto.text;
			titleTfd.x = titlebm.x + titlebm.width + boader;
			titleTfd.y = boader;
			titleTfd.selectable = false;
			this.addChild(titleTfd);

			//搜索输入
			var searchTfd:TextField = new TextField();
			searchTfd.type = TextFieldType.INPUT;
			searchTfd.border = true;
			searchTfd.width = 400;
			searchTfd.height = 30;
			searchTfd.x = titleTfd.x + titleTfd.width + boader;
			searchTfd.y = boader;
			this.addChild(searchTfd);

			//搜索按钮
			searchBtn = new NewsTextBtn("查询");
			searchBtn.x = searchTfd.x + searchTfd.width + boader;
			searchTfd.y = boader;
			this.addChild(searchBtn);
			searchBtn.addEventListener(MouseEvent.CLICK, handlerSearchBtnClick);

			//关闭按钮
			closeBtn = SkinsUtil.createSkinByName("News_closeBtnSkin");
			this.addChild(closeBtn);
			closeBtn.x = titleWidth - boader - closeBtn.width;
			closeBtn.y = boader;
			closeBtn.addEventListener(MouseEvent.CLICK, handlerCloseBtnClick);

			//关闭按钮
			minimiseBtn = SkinsUtil.createSkinByName("News_minimiseBtnSkin");
			this.addChild(minimiseBtn);
			minimiseBtn.x = closeBtn.x - boader - minimiseBtn.width;
			minimiseBtn.y = boader;
			minimiseBtn.addEventListener(MouseEvent.CLICK, handlerMinimizeBtnClick);
		}

		private function handlerMinimizeBtnClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_MIN));
		}

		private function handlerCloseBtnClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_CLOSE));
		}

		private function handlerSearchBtnClick(e:Event):void {
			this.dispatchEvent(new Event(EVENT_SEARCH));
		}
	}
}
