package com.snsoft.ensview {
	import fl.core.InvalidationType;
	import fl.core.UIComponent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class EnsvListItem extends UIComponent {

		private var def:MovieClip;

		private var ovr:MovieClip;

		private var tfd:TextField;

		private var text:String = "";

		private var deftft:TextFormat = new TextFormat("", 13, 0x000000);

		private var overtft:TextFormat = new TextFormat("", 13, 0xffffff);

		private var _id:String;

		public function EnsvListItem(text:String) {
			super();
			this.height = 30;
			this.width = 215;
			if (text) {
				this.text = text;
			}
		}

		/**
		 *
		 */
		private static var defaultStyles:Object = {
				ensvListItemSkinDefault: "EnsvListItemSkin_default",
				ensvListItemSkinOver: "EnsvListItemSkin_over"
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

			ovr = getDisplayObjectInstance(getStyleValue("ensvListItemSkinOver")) as MovieClip;
			ovr.mouseEnabled = false;
			this.addChild(ovr);

			def = getDisplayObjectInstance(getStyleValue("ensvListItemSkinDefault")) as MovieClip;
			this.addChild(def);

			tfd = new TextField();
			tfd.text = this.text;
			tfd.width = 196;
			tfd.height = 18;
			tfd.x = 2;
			tfd.y = 6;
			tfd.mouseEnabled = false;
			this.addChild(tfd);

			this.mouseChildren = false;
			this.buttonMode = true;

			defState();

			this.addEventListener(MouseEvent.MOUSE_OVER, handlerOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, handlerOut);
		}

		private function handlerOver(e:Event):void {
			overState();
		}

		private function handlerOut(e:Event):void {
			defState();
		}

		private function overState():void {
			def.alpha = 0;
			ovr.visible = true;
			tfd.setTextFormat(overtft);
		}

		private function defState():void {
			def.alpha = 1;
			ovr.visible = false;
			tfd.setTextFormat(deftft);
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}


	}
}
