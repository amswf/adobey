package com.snsoft.tsp3.plugin.news {
	import com.snsoft.util.SkinsUtil;

	import flash.display.Sprite;

	public class LinkBoardBtn extends Sprite {
		public function LinkBoardBtn(btnWidth:int, btnHeight:int) {
			super();

			var skin:Sprite = SkinsUtil.createSkinByName("LinkBoardBtn_defSkin");
			this.addChild(skin);
			skin.width = btnWidth;
			skin.height = btnHeight;
		}
	}
}
