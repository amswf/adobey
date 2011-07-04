package com.snsoft.ens {
	import flash.display.Sprite;

	/**
	 * 展位空间
	 * @author Administrator
	 *
	 */
	public class EnsSpace extends Sprite {

		/**
		 * 行数
		 */
		private var row:int = 0;

		/**
		 * 列数
		 */
		private var col:int = 0;

		private var paneWidth:int;

		private var paneHeight:int;

		private var vv:Vector.<Vector.<EnsPane>> = new Vector.<Vector.<EnsPane>>();

		/**
		 *
		 * @param row 行数
		 * @param col 列数
		 * @param paneWidth
		 * @param paneHeight
		 *
		 */
		public function EnsSpace(row:int, col:int, paneWidth:int, paneHeight:int) {
			super();

			var v:Vector.<EnsPane> = new Vector.<EnsPane>();
			this.paneWidth = paneWidth;
			this.paneHeight = paneHeight;

			var ensp:EnsPaneDO = new EnsPaneDO();
			ensp.width = paneWidth;
			ensp.height = paneHeight;
			var ep:EnsPane = new EnsPane(ensp);
			this.addChild(ep);
			v.push(ep);
			vv.push(v);
			this.row = 1;
			this.col = 1;

			addRow(row);
			addCol(col);

		}

		/**
		 * 增加行
		 * @param num
		 *
		 */
		public function addRow(num:int):void {
			for (var i:int = 0; i < num; i++) {
				var v:Vector.<EnsPane> = new Vector.<EnsPane>();
				for (var j:int = 0; j < col; j++) {
					var ensp:EnsPaneDO = new EnsPaneDO();
					ensp.width = paneWidth;
					ensp.height = paneHeight;
					var ep:EnsPane = new EnsPane(ensp);
					ep.x = j * paneWidth;
					ep.y = (row + i) * paneHeight;
					trace(ep.x,ep.y);
					this.addChild(ep);
					v.push(ep);
				}
				this.vv.push(v);
			}
			this.row += num;
		}

		/**
		 * 增加列
		 * @param num
		 *
		 */
		public function addCol(num:int):void {
			for (var i:int = 0; i < row; i++) {
				var v:Vector.<EnsPane> = vv[i];
				for (var j:int = 0; j < num; j++) {
					var ensp:EnsPaneDO = new EnsPaneDO();
					ensp.width = paneWidth;
					ensp.height = paneHeight;
					var ep:EnsPane = new EnsPane(ensp);
					this.addChild(ep);
					ep.x = (j + col) * paneWidth;
					ep.y = i * paneHeight;
					trace(ep.x,ep.y);
					v.push(ep);
				}
			}
			this.col += num;
		}

	}
}
