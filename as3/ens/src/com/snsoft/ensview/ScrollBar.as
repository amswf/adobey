package com.snsoft.ensview {
	import com.snsoft.util.complexEvent.CplxMousePressing;

	import fl.core.InvalidationType;
	import fl.core.UIComponent;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ScrollBar extends UIComponent {

		public static const EVENT_SCROLLING:String = "EVENT_SCROLLING";

		private var scrollHeight:int;

		private var sourceHeight:int;

		private var upskin:MovieClip;

		private var downskin:MovieClip;

		private var thumbskin:MovieClip;

		private var isMouseDown:Boolean;

		private var thumbMinY:int;

		private var thumbMaxY:int;

		private var lastThumbY:int;

		public function ScrollBar(scrollHeight:int, sourceHeight:int) {

			this.scrollHeight = scrollHeight;
			this.sourceHeight = sourceHeight;
			super();
		}

		/**
		 *
		 */
		private static var defaultStyles:Object = {
				arrowDownSkin: "MyScrollBarArrowDown_skin",
				arrowUpSkin: "MyScrollBarArrowUp_skin",
				thumbSkin: "ScrollThumb_skin"
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
			upskin = getDisplayObjectInstance(getStyleValue("arrowUpSkin")) as MovieClip;
			downskin = getDisplayObjectInstance(getStyleValue("arrowDownSkin")) as MovieClip;
			thumbskin = getDisplayObjectInstance(getStyleValue("thumbSkin")) as MovieClip;

			this.addChild(upskin);
			this.addChild(downskin);
			this.addChild(thumbskin);

			downskin.buttonMode = true;
			downskin.y = scrollHeight - downskin.height;
			var cmpd:CplxMousePressing = new CplxMousePressing(downskin);
			cmpd.addEventListener(MouseEvent.CLICK, handlerDownMouseClick);
			cmpd.addEventListener(CplxMousePressing.MOUSEEVENT_PRESSING, handlerDownMouseClick);

			upskin.buttonMode = true;
			var cmpu:CplxMousePressing = new CplxMousePressing(upskin);
			cmpu.addEventListener(MouseEvent.CLICK, handlerUpMouseClick);
			cmpu.addEventListener(CplxMousePressing.MOUSEEVENT_PRESSING, handlerUpMouseClick);

			thumbskin.buttonMode = true;
			thumbskin.y = upskin.height;
			var th:int = 0;

			if (sourceHeight > scrollHeight) {
				th = Math.pow((scrollHeight - downskin.height - upskin.height), 2) / sourceHeight;
				thumbskin.addEventListener(MouseEvent.MOUSE_DOWN, handlerMouseDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, handlerMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, handlerMouseMove);
			}
			else {
				th = scrollHeight - downskin.height - thumbskin.height;
			}
			thumbskin.height = th;
			thumbMinY = upskin.height;
			thumbMaxY = scrollHeight - downskin.height - thumbskin.height;
		}

		public function getScrollValue():Number {
			return Number(thumbskin.y - thumbMinY) / Number(thumbMaxY - thumbMinY);
		}

		private function handlerDownMouseClick(e:Event):void {
			setBtnskinY(thumbskin.y + 4);
		}

		private function handlerUpMouseClick(e:Event):void {
			setBtnskinY(thumbskin.y - 4);
		}

		private function handlerMouseDown(e:Event):void {
			thumbskin.startDrag();
			isMouseDown = true;
		}

		private function handlerMouseUp(e:Event):void {
			thumbskin.stopDrag();
			isMouseDown = false;
			setThumbskinY();
		}

		private function handlerMouseMove(e:Event):void {
			if (isMouseDown) {
				setThumbskinY();
			}
		}

		private function setThumbskinY():void {
			thumbskin.x = 0;
			if (thumbskin.y < thumbMinY) {
				thumbskin.y = thumbMinY;
			}
			else if (thumbskin.y > thumbMaxY) {
				thumbskin.y = thumbMaxY;
			}
			if (lastThumbY != thumbskin.y) {
				this.dispatchEvent(new Event(EVENT_SCROLLING));
			}
			lastThumbY = thumbskin.y;
		}

		private function setBtnskinY(y:int):void {
			if (y < thumbMinY) {
				y = thumbMinY;
			}
			else if (y > thumbMaxY) {
				y = thumbMaxY;
			}
			thumbskin.y = y;
			if (lastThumbY != thumbskin.y) {
				this.dispatchEvent(new Event(EVENT_SCROLLING));
			}
			lastThumbY = thumbskin.y;
		}
	}
}
