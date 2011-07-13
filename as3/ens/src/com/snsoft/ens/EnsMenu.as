package com.snsoft.ens {
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;

	import fl.controls.Button;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class EnsMenu extends MovieClip {

		public static const EVENT_STATE:String = "EVENT_STATE";

		public static const STATE_OUT:String = "out";

		public static const STATE_IN:String = "in";

		public static const STATE_ADD_ROW:String = "add_row";

		public static const STATE_DEL_ROW:String = "del_row";

		public static const STATE_ADD_COL:String = "add_col";

		public static const STATE_DEL_COL:String = "del_col";

		private var dOutBtn:Button;

		private var dInBtn:Button;

		private var dAddRowBtn:Button;

		private var dDelRowBtn:Button;

		private var dAddColBtn:Button;

		private var dDelColBtn:Button;

		private var _state:String;

		public function EnsMenu() {
			super();
			this.addEventListener(Event.ENTER_FRAME, handlerEnterFrame);
		}

		private function handlerEnterFrame(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, handlerEnterFrame);
			dOutBtn = this.getChildByName("outBtn") as Button;
			dInBtn = this.getChildByName("inBtn") as Button;
			dAddRowBtn = this.getChildByName("addRowBtn") as Button;
			dDelRowBtn = this.getChildByName("delRowBtn") as Button;
			dAddColBtn = this.getChildByName("addColBtn") as Button;
			dDelColBtn = this.getChildByName("delColBtn") as Button;

			dOutBtn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
			dInBtn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
			dAddRowBtn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
			dDelRowBtn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
			dAddColBtn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
			dDelColBtn.addEventListener(MouseEvent.CLICK, handlerBtnClick);
		}

		private function handlerBtnClick(e:Event):void {
			var sign:Boolean = true;
			switch (e.currentTarget as Button) {
				case dOutBtn:  {
					_state = STATE_OUT;
					break;
				}
				case dInBtn:  {
					_state = STATE_IN;
					break;
				}
				case dAddRowBtn:  {
					_state = STATE_ADD_ROW;
					break;
				}
				case dDelRowBtn:  {
					_state = STATE_DEL_ROW;
					break;
				}
				case dAddColBtn:  {
					_state = STATE_ADD_COL;
					break;
				}
				case dDelColBtn:  {
					_state = STATE_DEL_COL;
					break;
				}
				default:  {
					sign = false;
					break;
				}
			}
			if (sign) {
				this.dispatchEvent(new Event(EVENT_STATE));
			}
		}

		public function get state():String {
			return _state;
		}

	}
}
