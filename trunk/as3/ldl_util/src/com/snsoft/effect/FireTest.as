/**
 * Copyright ProjectNya ( http://wonderfl.net/user/ProjectNya )
 * MIT License ( http://www.opensource.org/licenses/mit-license.php )
 * Downloaded from: http://wonderfl.net/c/gOig
 */

////////////////////////////////////////////////////////////////////////////////
// [AS3.0] Fireクラスに挑戦！ (1)
// http://www.project-nya.jp/modules/weblog/details.php?blog_id=950
////////////////////////////////////////////////////////////////////////////////

package com.snsoft.effect {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="#000000", width="465", height="465", frameRate="30")]

	public class FireTest extends Sprite {

		private var fire:Fire;
		private var fired:Boolean = true;

		public function FireTest() {
			init();
		}

		private function init():void {
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 465, 465);
			graphics.endFill();
			fire = new Fire();
			addChild(fire);
			fire.init(80, 200, {x: 232, y: 340, offset: 10});
			fire.burn();
			stage.addEventListener(MouseEvent.CLICK, click, false, 0, true);
		}
		private function click(vet:MouseEvent):void {
			fired = !fired;
			if (fired) fire.burn();
			else fire.clear();
		}

	}
}
