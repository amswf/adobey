package com.snsoft.tsp3.pagination {
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 分页标签
	 * @author Administrator
	 *
	 */
	public class Pagination extends Sprite {

		/**
		 * 分页按钮显示个数
		 */
		private var pageBtnNum:int;

		/**
		 *页号
		 */
		private var pageNum:int

		/**
		 * 总页数
		 */
		private var pageCount:int;

		/**
		 * 元件之间的间距
		 */
		private var boader:int  = 5;

		/**
		 * 首页和末页按钮和中间几个按钮的间隔数
		 */
		private var more:int = 2;

		/**
		 * 两个按钮的间距
		 */
		private var w:int;

		/**
		 * 首页按钮
		 */
		private var firstBtn:PaginationBtn;

		/**
		 * 末页按钮
		 */
		private var lastBtn:PaginationBtn;

		private var middleBtnsLayer:Sprite = new Sprite();

		private var middleBtns:Vector.<PaginationBtn>;

		/**
		 *
		 * @param pageBtnNum 显示的页号数量
		 *
		 */
		public function Pagination(pageBtnNum:int = 5) {
			this.pageBtnNum = pageBtnNum;
			super();
			init();
		}

		/**
		 *
		 * 绘制组件显示
		 */
		private function init():void {
			var back:MovieClip =  SkinsUtil.createSkinByName("PaginationBack_defSkin");
			this.addChild(back);
			var pbtn:PaginationBtn = new PaginationBtn("");
			w = pbtn.width + boader;
			back.width = (pageBtnNum + more * 2) * w + boader;

			this.addChild(middleBtnsLayer);

			firstBtn = new PaginationBtn("1");
			firstBtn.visible = false;
			firstBtn.x = boader;
			firstBtn.y = boader;
			this.addChild(firstBtn);

			lastBtn = new PaginationBtn(String(pageCount));
			lastBtn.visible = false;
			lastBtn.x = back.width - w;
			lastBtn.y = boader;
			this.addChild(lastBtn);

			var firstSep:MovieClip = SkinsUtil.createSkinByName("PaginationSep_defSkin");
			firstSep.visible = false;
			firstSep.x = boader + w;
			firstSep.y = boader;
			this.addChild(firstSep);

			var lastSep:MovieClip = SkinsUtil.createSkinByName("PaginationSep_defSkin");
			lastSep.visible = false;
			lastSep.x = back.width - w - w;
			lastSep.y = boader;
			this.addChild(lastSep);

		}

		/**
		 *
		 * @param pageNum 页号
		 * @param pageCount 总页数
		 *
		 */
		public function setPageNum(pageNum:int, pageCount:int):void {

			pageNum = Math.max(1, pageNum);
			pageNum = Math.min(pageCount, pageNum);

			if (pageCount != this.pageCount) {
				middleBtns = new Vector.<PaginationBtn>();
				var min:int = pageBtnNum <= pageCount ? pageBtnNum : pageCount;
				for (var i:int = 0; i < min; i++) {
					var btn:PaginationBtn =  new PaginationBtn("");
					btn.x = w * i;
					btn.y = boader;
					this.addChild(btn);
					middleBtns.push(btn);
				}
			}

			var d:int = (pageBtnNum / 2);
			var m:int =   (pageBtnNum % 2);
			var p:int = d + m;

			var maxl:int = pageNum - 1;
			var maxr:int = pageCount - pageNum;

			var pl:int = Math.max((p - m) - maxr, 0);
			var cl:int = Math.min(maxl, p - 1 + pl);

			var fn:int = pageNum - cl;
			for (var i2:int = 0; i2 < middleBtns.length; i2++) {
				var btn2:PaginationBtn = middleBtns[i2];
				btn2.setStateText(String(fn++));
			}

			if (pageNum != this.pageNum) {
				this.pageNum = pageNum;
			}
		}
	}
}
