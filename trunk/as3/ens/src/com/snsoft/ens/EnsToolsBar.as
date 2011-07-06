package com.snsoft.ens {
	import fl.core.InvalidationType;
	import fl.core.UIComponent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class EnsToolsBar extends UIComponent {

		public var btnList:Vector.<EnsToolBtn> = new Vector.<EnsToolBtn>();

		private var _type:String;

		public static const EVENT_CHANGE_TYPE:String = "EVENT_CHANGE_TYPE";

		public function EnsToolsBar() {
			super();
		}

		/**
		 *
		 */
		private static var defaultStyles:Object = {
				backSkin: "ToolsBarBack"
			};

		/**
		 *
		 * @return
		 *
		 */
		public static function getStyleDefinition():Object {
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
		}

		/**
		 *
		 *
		 */
		override protected function configUI():void {
			this.invalidate(InvalidationType.ALL, true);
			this.invalidate(InvalidationType.SIZE, true);
			super.configUI();
		}

		/**
		 *
		 * 绘制组件显示
		 */
		override protected function draw():void {
			var btnx:int = 3;
			var btny:int = 3;

			var stepX:int = 30;
			var stepY:int = 30;

			var back:MovieClip = getDisplayObjectInstance(getStyleValue("backSkin")) as MovieClip;
			this.addChild(back);

			for (var i:int = 0; i < btnList.length; i++) {
				var btn:EnsToolBtn = btnList[i];
				btn.x = btnx;
				btn.y = btny;
				this.addChild(btn);
				btn.drawNow();
				btny += stepY;
				btn.addEventListener(EVENT_CHANGE_TYPE, handlerMouseDown);
			}

			btny += 3;
			back.width = stepX;
			back.height = btny;
		}

		private function handlerMouseDown(e:Event):void {
			var cbtn:EnsToolBtn = e.currentTarget as EnsToolBtn;
			type = cbtn.btndo.type;
			this.dispatchEvent(new Event(EVENT_CHANGE_TYPE));

			for (var i:int = 0; i < btnList.length; i++) {
				var btn:EnsToolBtn = btnList[i];
				if (btn.order != cbtn.order) {
					btn.setStateDefault();
				}
			}
		}

		public function addBtn(btndo:EnsToolBtnDO):void {
			if (btndo.selected) {
				this.type = btndo.type;
			}
			var btn:EnsToolBtn = new EnsToolBtn(btndo);
			btn.order = btnList.length;
			btnList.push(btn);
		}

		public function get type():String {
			return _type;
		}

		public function set type(value:String):void {
			_type = value;
		}

	}
}
