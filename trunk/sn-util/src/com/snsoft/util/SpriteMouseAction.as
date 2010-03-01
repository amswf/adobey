package com.snsoft.util
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SpriteMouseAction extends EventDispatcher
	{
		//正在拖动事件名称
		public static const DRAG_MOVE_EVENT:String = "DRAG_MOVE_EVENT";
		
		//拖动完成事件名称
		public static const DRAG_COMPLETE_EVENT:String = "DRAG_COMPLETE_EVENT";
		
		//鼠标动作对象
		private var _dragDisplayObject:DisplayObjectContainer ;
		
		//鼠标动作对象动作时初始鼠标位置
		private var cuntryNameMousePoint:Point = new Point();
		
		//鼠标动作对象是否动作的标记
		private var cuntryNameMoveSign:Boolean = false;
		
		public function SpriteMouseAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * 注册鼠标拖动 
		 * 
		 */		
		public function addMouseDragEvents():void{
			var doc:DisplayObjectContainer = this.dragDisplayObject;
			
			if(doc != null){
				doc.addEventListener(MouseEvent.MOUSE_DOWN,handlerCnMouseDown);
				doc.addEventListener(MouseEvent.MOUSE_UP,handlerCnMouseUp);
				doc.addEventListener(MouseEvent.MOUSE_MOVE,handlerCnMouseMove);
				var stg:Stage = doc.stage;
				if(stg != null){
					stg.addEventListener(MouseEvent.MOUSE_UP,handlerCnMouseUp);
				}
			}
		}
		
		public function removeMouseDragEvents():void{
			var doc:DisplayObjectContainer = this.dragDisplayObject;
			if(doc != null){
				doc.removeEventListener(MouseEvent.MOUSE_DOWN,handlerCnMouseDown);
				doc.removeEventListener(MouseEvent.MOUSE_UP,handlerCnMouseUp);
				doc.removeEventListener(MouseEvent.MOUSE_MOVE,handlerCnMouseMove);
				var stg:Stage = doc.stage;
				if(stg != null){
					stg.addEventListener(MouseEvent.MOUSE_UP,handlerCnMouseUp);
				}
			}
		}
		
		/**
		 * MouseDown 事件 
		 * @param e
		 * 
		 */		
		private function handlerCnMouseDown(e:Event):void{
			var doc:DisplayObjectContainer = this.dragDisplayObject;
			var poc:DisplayObjectContainer = this.dragDisplayObject.parent;
			if(poc != null){
				if(this.cuntryNameMoveSign == false){
					var p:Point = this.cuntryNameMousePoint;
					p.x = poc.mouseX - doc.x;
					p.y = poc.mouseY - doc.y;
					this.cuntryNameMoveSign = true;
				}
			}
		}
		
		/**
		 * MouseUp 事件 
		 * @param e
		 * 
		 */		
		private function handlerCnMouseUp(e:Event):void{
			var doc:DisplayObjectContainer = this.dragDisplayObject;
			var poc:DisplayObjectContainer = this.dragDisplayObject.parent;
			var sign:Boolean = this.cuntryNameMoveSign;
			if(poc != null && sign){
				this.cuntryNameMoveSign = false;		
				this.dispatchEvent(new Event(DRAG_COMPLETE_EVENT));
			}
		}
		
		/**
		 * MouseMove 事件 
		 * @param e
		 * 
		 */		
		private function handlerCnMouseMove(e:Event):void{
			var doc:DisplayObjectContainer = this.dragDisplayObject;
			var poc:DisplayObjectContainer = this.dragDisplayObject.parent;
			if(poc != null){
				if(this.cuntryNameMoveSign){
					var p:Point = this.cuntryNameMousePoint;
					doc.x = poc.mouseX - p.x;
					doc.y = poc.mouseY - p.y;
					this.dispatchEvent(new Event(DRAG_MOVE_EVENT));
				}
			}
		}

		public function get dragDisplayObject():DisplayObjectContainer
		{
			return _dragDisplayObject;
		}

		public function set dragDisplayObject(value:DisplayObjectContainer):void
		{
			_dragDisplayObject = value;
		}

	}
}