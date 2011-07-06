package com.snsoft.ens {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 展位空间
	 * @author Administrator
	 *
	 */
	public class EnsSpace extends Sprite {

		public static const EVENT_SELECT_PANE:String = "EVENT_SELECT_PANE";

		private var _row:int = 0;

		private var _col:int = 0;

		private var paneWidth:int;

		private var paneHeight:int;

		private var vv:Vector.<Vector.<EnsPane>> = new Vector.<Vector.<EnsPane>>();

		private var _currentPane:EnsPane;

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
			ep.addEventListener(MouseEvent.CLICK, hanlderPaneMouseClick);
			v.push(ep);
			vv.push(v);
			this._row = 1;
			this._col = 1;

			addRow(row - 1);
			addCol(col - 1);

		}

		/**
		 * 增加行
		 * @param num
		 *
		 */
		public function addRow(num:int):void {
			var sign:Boolean = false;
			for (var i:int = 0; i < Math.abs(num); i++) {
				if (num > 0) {
					var v:Vector.<EnsPane> = new Vector.<EnsPane>();
					for (var j:int = 0; j < col; j++) {
						var ensp:EnsPaneDO = new EnsPaneDO();
						ensp.width = paneWidth;
						ensp.height = paneHeight;
						ensp.row = row + i;
						ensp.col = j;
						var ep:EnsPane = new EnsPane(ensp);
						ep.x = j * paneWidth;
						ep.y = (row + i) * paneHeight;
						this.addChild(ep);
						v.push(ep);
						ep.addEventListener(MouseEvent.CLICK, hanlderPaneMouseClick);
					}
					this.vv.push(v);
					sign = true;
				}
				else if (num < 0) {
					if (this.vv.length > 1) {
						var v2:Vector.<EnsPane> = this.vv.pop();
						for (var j2:int = 0; j2 < v2.length; j2++) {
							var dp:EnsPane = v2[j2];
							this.removeChild(dp);
							dp.removeEventListener(MouseEvent.CLICK, hanlderPaneMouseClick);
						}
						sign = true;
					}
				}
			}
			if (sign) {
				this._row += num;
			}
		}

		/**
		 * 增加列
		 * @param num
		 *
		 */
		public function addCol(num:int):void {
			var sign:Boolean = false;
			for (var i:int = 0; i < row; i++) {
				var v:Vector.<EnsPane> = vv[i];
				if (num > 0) {
					for (var j:int = 0; j < num; j++) {
						var ensp:EnsPaneDO = new EnsPaneDO();
						ensp.width = paneWidth;
						ensp.height = paneHeight;
						ensp.row = i;
						ensp.col = col + j;
						var ep:EnsPane = new EnsPane(ensp);
						this.addChild(ep);
						ep.x = (j + col) * paneWidth;
						ep.y = i * paneHeight;
						v.push(ep);
						ep.addEventListener(MouseEvent.CLICK, hanlderPaneMouseClick);
					}
					sign = true;
				}
				else if (num < 0) {
					if (v.length > 1) {
						var dp:EnsPane = v.pop();
						this.removeChild(dp);
						dp.removeEventListener(MouseEvent.CLICK, hanlderPaneMouseClick);
						sign = true;
					}
				}
			}
			if (sign) {
				this._col += num;
			}
		}

		private function hanlderPaneMouseClick(e:Event):void {
			_currentPane = e.currentTarget as EnsPane;
			this.dispatchEvent(new Event(EVENT_SELECT_PANE));
		}

		public function get currentPane():EnsPane {
			return _currentPane;
		}

		/**
		 * 行数
		 */
		public function get row():int {
			return _row;
		}

		/**
		 * 列数
		 */
		public function get col():int {
			return _col;
		}

	}
}
