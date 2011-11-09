package com.snsoft.tsp3.html {
	import com.snsoft.util.SkinsUtil;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 *
	 * @author Administrator
	 *
	 */
	public class AirIE extends Sprite {

		private var backLayer:Sprite = new Sprite();

		private var titleLayer:Sprite = new Sprite();

		private var topBtnLayer:Sprite = new Sprite();

		private var ieWidth:int;

		private var ieHeight:int;

		private var closeBtn:MovieClip;

		private var btmH:int = 50;

		private var boader:int = 19;

		private var boader2:int = 10;

		private var ctntWidth:int = 0;

		private var ctntHeight:int = 0;

		public function AirIE(ieWidth:int, ieHeight:int) {
			this.ieWidth = ieWidth;
			this.ieHeight = ieHeight;
			init();
		}

		private function init():void {
			ctntWidth = ieWidth - boader - boader;
			ctntHeight = ieHeight - boader - boader;

			var back:MovieClip = SkinsUtil.createSkinByName("AirIE_backSkin");
			backLayer.addChild(back);
			back.width = ieWidth;
			back.height = ieHeight;

			closeBtn = SkinsUtil.createSkinByName("AirIE_closeBtnSkin");
			closeBtn.x = ieWidth - closeBtn.width;

			var titleBack:Sprite = SkinsUtil.createSkinByName("AirIE_titleBackSkin");
			titleLayer.addChild(titleBack);
			
			
		}
	}
}
