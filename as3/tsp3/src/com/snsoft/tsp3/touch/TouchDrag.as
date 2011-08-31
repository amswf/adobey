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

	public class TouchDrag extends EventDispatcher {

		private var dragObj:Sprite;

		private var stage:Stage;

		private var dragType:String;

		/**
		 * 水平拖动
		 */
		public static const DRAG_TYPE_HORIZONTAL:String = "horizontal";

		/**
		 * 垂直拖动
		 */
		public static const DRAG_TYPE_VERTICAL:String = "vertical";

		private var dragBounds:Rectangle = new Rectangle();

		/**
		 * 鼠标按下时鼠标的坐标
		 */
		private var mdp:Point = new Point();

		/**
		 * 鼠标按下时拖动物体的坐标
		 */
		private var ddp:Point = new Point();

		private var _clickObj:Sprite;

		private var cDownObj:Sprite;

		private var clickObjs:Vector.<Sprite> = new Vector.<Sprite>();

		private var sensitivity:int = 0;

		private var isClick:Boolean = false;

		public function TouchDrag(dragObj:Sprite, stage:Stage, size:int, dragType:String = "horizontal", sensitivity:int = 5) {
			this.dragObj = dragObj;
			this.stage = stage;
			this.dragType = dragType;
			this.sensitivity = sensitivity;

			if (dragType == DRAG_TYPE_VERTICAL) {
				dragBounds.height = size;
			}
			else if (dragType == DRAG_TYPE_HORIZONTAL) {
				dragBounds.width = size;
			}
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
			isClick = false;
			this._clickObj = null;

			ddp.x = dragObj.x;
			ddp.y = dragObj.y;

			mdp.x = stage.mouseX;
			mdp.y = stage.mouseY;
			dragObj.startDrag(false, dragBounds);
		}

		private function handlerDragObjMouseUp(e:Event):void {
			var cx:int = stage.mouseX;
			var cy:int = stage.mouseY;

			var property:String = null;
			var start:int = 0;
			var end:int = 0;
			var sign = false;
			if (dragType == DRAG_TYPE_VERTICAL) {
				if (Math.abs(cy - mdp.y) < sensitivity && mdp.y > 0) {
					sign = true;
				}
				property = "y";
				start = dragObj.y;
				end = ddp.y;
			}
			else if (dragType == DRAG_TYPE_HORIZONTAL) {
				if (Math.abs(cx - mdp.x) < sensitivity && mdp.x > 0) {
					sign = true;
				}
				property = "x";
				start = dragObj.x;
				end = ddp.x;
			}

			if (sign && isClick) {
				this._clickObj = cDownObj;
				this.dispatchEvent(new Event(MouseEvent.CLICK));
				var twn:Tween = new Tween(dragObj, property, Regular.easeOut, start, end, 0.3, true);
				twn.start();
			}
			else {

			}
			dragObj.stopDrag();
		}

		public function get clickObj():Sprite {
			return _clickObj;
		}

	}
}
