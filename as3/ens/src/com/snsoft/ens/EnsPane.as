package com.snsoft.ens {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * 方格子，展位基本信息元素，展位地图也用此画背景。
	 * @author Administrator
	 *
	 */
	public class EnsPane extends Sprite {

		private var _ensPaneDO:EnsPaneDO;

		private var shape:Shape;

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
		}

		public function get ensPaneDO():EnsPaneDO {
			return _ensPaneDO;
		}

	}
}
