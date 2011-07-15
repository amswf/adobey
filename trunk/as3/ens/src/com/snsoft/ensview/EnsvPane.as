package com.snsoft.ensview {
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
	public class EnsvPane extends Sprite {

		private var _ensPaneDO:EnsvPaneDO;

		private var shape:Shape;

		public function EnsvPane(ensPaneDO:EnsvPaneDO) {
			super();
			this._ensPaneDO = ensPaneDO;
			init();
		}

		private function init():void {
			shape = new Shape();
			this.addChild(shape);
			var gra2:Graphics = shape.graphics;
			gra2.beginFill(0xf6f1d2, 1);
			gra2.drawRect(0, 0, _ensPaneDO.width, _ensPaneDO.height);
			gra2.endFill();
		}

		public function get ensPaneDO():EnsvPaneDO {
			return _ensPaneDO;
		}

	}
}
