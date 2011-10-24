package com.snsoft.tsp3.pagination {
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.rs.RSEmbedFonts;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class PaginationBtn extends Sprite {

		private var btnText:String = "";

		private var _btnNum:int = 0;

		private var btnTfd:TextField;

		private var defBtn:MovieClip;

		private var selBtn:MovieClip;

		private var selected:Boolean = false;

		private var btnTft:TextFormat = new TextFormat(RSEmbedFonts.findFontByName("HZGBYS"), 15, 0x333333, true);

		public function PaginationBtn(btnText:String = "", btnNum:int = 0) {
			this.btnText = btnText;
			super();
			init();
		}

		private function init():void {
			this.mouseChildren = false;
			this.buttonMode = true;

			defBtn = SkinsUtil.createSkinByName("PaginationBtn_defSkin");
			this.addChild(defBtn);

			selBtn = SkinsUtil.createSkinByName("PaginationBtn_selectedSkin");
			this.addChild(selBtn);

			setStateSelect(selected);

			btnTfd = new TextField();
			btnTfd.embedFonts = true;
			btnTfd.antiAliasType = AntiAliasType.ADVANCED;
			btnTfd.gridFitType = GridFitType.PIXEL;
			btnTfd.defaultTextFormat = btnTft;
			btnTfd.autoSize = TextFieldAutoSize.LEFT;
			setStateText(btnText);
			this.addChild(btnTfd);

			this.width = defBtn.width;
			this.height = defBtn.height;
		}

		public function setStateText(text:String):void {
			this.btnText = text;
			this.btnTfd.text = this.btnText;
			btnTfd.x = (defBtn.width - btnTfd.width) / 2;
			btnTfd.y = (defBtn.height - btnTfd.height) / 2;
		}

		public function setStateSelect(b:Boolean):void {
			this.selected = b;
			selBtn.visible = this.selected;
			defBtn.visible = !this.selected;
		}

		public function get btnNum():int {
			return _btnNum;
		}

		public function set btnNum(value:int):void {
			_btnNum = value;
		}

	}
}
