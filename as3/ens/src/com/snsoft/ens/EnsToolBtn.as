package com.snsoft.ens {
	import com.snsoft.util.SpriteUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class EnsToolBtn extends UIComponent {

		private var def:MovieClip;

		private var down:MovieClip;

		private var over:MovieClip;

		private var _btndo:EnsToolBtnDO;

		private var _order:int;

		public function EnsToolBtn(btndo:EnsToolBtnDO) {
			super();
			this._btndo = btndo;
		}

		/**
		 *
		 */
		private static var defaultStyles:Object = {
				defaultSkin: "ToolSelectDefaultSkin",
				downSkin: "ToolSelectDownSkin",
				overSkin: "ToolSelectOverSkin"
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
			SpriteUtil.deleteAllChild(this);
			this.setStyle("defaultSkin", btndo.defaultSkin);
			this.setStyle("downSkin", btndo.downSkin);
			this.setStyle("overSkin", btndo.overSkin);

			def = getDisplayObjectInstance(getStyleValue("defaultSkin")) as MovieClip;
			down = getDisplayObjectInstance(getStyleValue("downSkin")) as MovieClip;
			over = getDisplayObjectInstance(getStyleValue("overSkin")) as MovieClip;

			this.addChild(def);
			this.addChild(down);
			this.addChild(over);
			
			visibleSkin(def);

			this.mouseChildren = false;
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_OVER, handlerMouserOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, handlerMouserOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN, handlerMouserDown);
		}

		private function handlerMouserOver(e:Event):void {
			visibleSkin(down);
		}

		private function handlerMouserOut(e:Event):void {
			visibleSkin(def);
		}

		private function handlerMouserDown(e:Event):void {
			_btndo.selected = true;
			visibleSkin(down);
			this.dispatchEvent(new Event(EnsToolsBar.EVENT_CHANGE_TYPE));
		}

		public function setStateDefault():void {
			_btndo.selected = false;
			visibleSkin(def);
		}

		private function visibleSkin(skin:MovieClip):void {
			if (_btndo.selected) {
				over.visible = false;
				down.visible = true;
				def.visible = false;
			}
			else {
				over.visible = false;
				down.visible = false;
				def.visible = false;
				skin.visible = true;
			}
		}

		public function get order():int {
			return _order;
		}

		public function set order(value:int):void {
			_order = value;
		}

		public function get btndo():EnsToolBtnDO {
			return _btndo;
		}

	}
}
