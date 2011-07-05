package com.snsoft.ens {
	import com.snsoft.util.ColorTransformUtil;

	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 方格子，展位基本信息元素，展位地图也用此画背景。
	 * @author Administrator
	 *
	 */
	public class EnsPane extends Sprite {

		private var _ensPaneDO:EnsPaneDO;

		private var shape:Shape;

		private var shape2:Shape;

		public function EnsPane(ensPaneDO:EnsPaneDO) {
			super();
			this._ensPaneDO = ensPaneDO;
			init();
		}

		private function init():void {
			trace("EnsPane");
			shape = new Shape();
			this.addChild(shape);
			var gra:Graphics = shape.graphics;
			gra.lineStyle(1, 0x000000);
			gra.beginFill(0xffffff, 1);
			gra.drawRect(0, 0, _ensPaneDO.width, _ensPaneDO.height);
			gra.endFill();

			shape2 = new Shape();
			shape2.visible = false;
			this.addChild(shape2);
			var gra2:Graphics = shape2.graphics;
			gra2.lineStyle(1, 0x0000ff);
			gra2.beginFill(0xdddddd, 1);
			gra2.drawRect(0, 0, _ensPaneDO.width, _ensPaneDO.height);
			gra2.endFill();

			//this.addEventListener(MouseEvent.MOUSE_OVER, handlerMouseOver);
			//this.addEventListener(MouseEvent.MOUSE_OUT, handlerMouseOut);
		}

//		private function handlerMouseOver(e:Event):void {
//			shape.visible = false;
//			shape2.visible = true;
//		}
//
//		private function handlerMouseOut(e:Event):void {
//			shape.visible = true;
//			shape2.visible = false;
//		}

		public function get ensPaneDO():EnsPaneDO {
			return _ensPaneDO;
		}

	}
}
