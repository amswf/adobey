package com.snsoft.tsp3.touch {

	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	[Event(name = "touchDragMouseUp", type = "com.snsoft.tsp3.touch.TouchDragEvent")]
	[Event(name = "touchClick", type = "com.snsoft.tsp3.touch.TouchDragEvent")]

	/**
	 *
	 * @author Administrator
	 *
	 */
	public class TouchDrag extends EventDispatcher {

		private var dragObj:Sprite;

		private var stage:Stage;

		private var _dragBounds:Rectangle = new Rectangle();

		private var _mouseDownPoint:Point = new Point();

		private var _mouseUpPoint:Point = new Point();

		/**
		 * 鼠标按下时拖动物体的坐标
		 */
		private var ddp:Point = new Point();

		private var _clickObj:Sprite;

		private var cDownObj:Sprite;

		private var clickObjs:Vector.<Sprite> = new Vector.<Sprite>();

		private var sensitivity:int = 0;

		private var isClick:Boolean = false;

		private var isMouseDown:Boolean = false;

		public function TouchDrag(dragObj:Sprite, stage:Stage, dragBounds:Rectangle, sensitivity:int = 5) {
			this.dragObj = dragObj;
			this.stage = stage;
			this.sensitivity = sensitivity;
			this.dragBounds = dragBounds;
			init();
		}

		public function addClickObj(clickObj:Sprite):void {
			clickObjs.push(clickObj);
			clickObj.addEventListener(MouseEvent.MOUSE_DOWN, handlerClickObjMouseDown);
			clickObj.addEventListener(MouseEvent.MOUSE_UP, handlerClickObjMouseUp);
		}

		private function handlerClickObjMouseDown(e:Event):void {
			cDownObj = e.currentTarget as Sprite;
		}

		private function handlerClickObjMouseUp(e:Event):void {
			var s:Sprite = e.currentTarget as Sprite;
			if (s == cDownObj) {
				isClick = true;
			}
		}

		private function init():void {
			dragObj.addEventListener(MouseEvent.MOUSE_DOWN, handlerDragObjMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handlerDragObjMouseUp);
		}

		private function handlerDragObjMouseDown(e:Event):void {
			isMouseDown = true;
			isClick = false;
			this._clickObj = null;

			ddp.x = dragObj.x;
			ddp.y = dragObj.y;

			mouseDownPoint.x = stage.mouseX;
			mouseDownPoint.y = stage.mouseY;
			dragObj.startDrag(false, dragBounds);
		}

		private function handlerDragObjMouseUp(e:Event):void {

			mouseUpPoint.x = stage.mouseX;
			mouseUpPoint.y = stage.mouseY;

			var cx:int = stage.mouseX;
			var cy:int = stage.mouseY;

			var property:String = null;
			var start:int = 0;
			var end:int = 0;
			var sign:Boolean = false;

			var dragSign:Boolean = false;
			if (dragBounds.height > 0) {
				if (Math.abs(cy - mouseDownPoint.y) < sensitivity && mouseDownPoint.y > 0) {
					sign = true;
				}
				else {
					dragSign = true;
				}
				property = "y";
				start = dragObj.y;
				end = ddp.y;
			}
			else if (dragBounds.width > 0) {
				if (Math.abs(cx - mouseDownPoint.x) < sensitivity && mouseDownPoint.x > 0) {
					sign = true;
				}
				else {
					dragSign = true;
				}
				property = "x";
				start = dragObj.x;
				end = ddp.x;
			}

			dragObj.stopDrag();

			var twe:Boolean = false;

			if (sign && isClick) {
				this._clickObj = cDownObj;
				this.dispatchEvent(new Event(TouchDragEvent.TOUCH_CLICK));
				twe = true;
			}
			else if (dragSign && isMouseDown) {
				this.dispatchEvent(new Event(TouchDragEvent.TOUCH_DRAG_MOUSE_UP));
			}
			else {

				twe = true;
			}

			if (twe && isMouseDown) {
				var twn:Tween = new Tween(dragObj, property, Regular.easeOut, start, end, 0.3, true);
				twn.start();
			}
			isMouseDown = false;
		}

		public function get clickObj():Sprite {
			return _clickObj;
		}

		/**
		 * 鼠标按下时鼠标的坐标
		 */
		public function get mouseDownPoint():Point {
			return _mouseDownPoint;
		}

		/**
		 * 鼠标弹起时鼠标的坐标
		 */
		public function get mouseUpPoint():Point {
			return _mouseUpPoint;
		}

		public function get dragBounds():Rectangle
		{
			return _dragBounds;
		}

		public function set dragBounds(value:Rectangle):void
		{
			_dragBounds = value;
		}


	}
}
