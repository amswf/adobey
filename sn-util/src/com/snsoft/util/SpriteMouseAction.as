package com.snsoft.util
{
	import com.snsoft.map.util.MapUtil;
	
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
		private var dragDisplayObject:DisplayObjectContainer;
		
		//鼠标动作对象动作时初始鼠标位置
		private var cuntryNameMousePoint:Point = new Point();
		
		//鼠标动作对象是否动作的标记
		private var cuntryNameMoveSign:Boolean = false;
		
		//拖动时限制拖动位置的其它对象
		private var dragLimitDisplayObject:DisplayObjectContainer;
		
		//拖动时拖动对象的显示位置，小地图中的移动框
		private var viewDrag:DisplayObjectContainer;
		
		//拖动时限制对象的显示位置，小地图中的限制框
		private var viewLimit:DisplayObjectContainer;
		
		private var viewEvent:String = "DRAG_MOVE_EVENT";
		
		public function SpriteMouseAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * 把当前拖动对象和限制对象，算出小地图中拖动对象的位置并置属性。 
		 * @param d
		 * @param l
		 * @param vd
		 * @param vl
		 * 
		 */		
		private function setViewPlace(d:DisplayObjectContainer,l:DisplayObjectContainer,vd:DisplayObjectContainer,vl:DisplayObjectContainer):void{
			var dlp:Point = new Point(d.width - l.width,d.height - l.height);
			var dlsp:Point = new Point(vd.width - vl.width,vd.height - vl.height);
			vd.x =  vl.x + (d.x - l.x) * dlsp.x / dlp.x;
			vd.y =  vl.y + (d.y - l.y) * dlsp.y / dlp.y;
		}
		
		private function setView():void{
			if(this.dragLimitDisplayObject != null && this.viewDrag != null && this.viewLimit != null){
				this.setViewPlace(this.dragDisplayObject,this.dragLimitDisplayObject,this.viewDrag,this.viewLimit);
			}
		}
		
		/**
		 * 注册鼠标拖动 
		 * 
		 */		
		public function addMouseDragEvents(dragDisplayObject:DisplayObjectContainer,dragLimitDisplayObject:DisplayObjectContainer = null,viewDrag:DisplayObjectContainer = null,viewLimit:DisplayObjectContainer = null,viewEvent:String = "DRAG_MOVE_EVENT"):void{
			this.dragDisplayObject = dragDisplayObject;
			this.dragLimitDisplayObject = dragLimitDisplayObject;
			this.viewDrag = viewDrag;
			this.viewLimit = viewLimit;
			this.viewEvent = viewEvent;
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
				this.setView();
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
					var docx:Number = poc.mouseX - p.x;
					var docy:Number = poc.mouseY - p.y;
					var docp:Point = new Point(docx,docy); 
					docp = calculateMoveLimitPoint(docp);
					MapUtil.setSpritePlace(doc,docp);
					this.setView();
					this.dispatchEvent(new Event(DRAG_MOVE_EVENT));
				}
			}
		}
		
		public function calculateMoveLimitPoint(dragDisplayObjectPlace:Point):Point{
			
			var ddoX:Number = 0;
			var ddoY:Number = 0;
			
			//拖动对象
			var ddo:DisplayObjectContainer = this.dragDisplayObject;
			//限制对象
			var ldo:DisplayObjectContainer = this.dragLimitDisplayObject;
			
			if(ldo != null){
				//宽高
				var dsp:Point = MapUtil.getSpriteSize(ddo);//拖动对象
				var lsp:Point = MapUtil.getSpriteSize(ldo);//限制对象
				
				//宽高差
				var ssp:Point = MapUtil.subPoint(dsp,lsp);
				
				//位置
				var dpp:Point = dragDisplayObjectPlace;//拖动对象
				var lpp:Point = MapUtil.getSpritePlace(ldo);//限制对象
				
				//位置差
				var spp:Point = MapUtil.subPoint(dpp,lpp);
				
				if(ssp.x == 0){ // x方向拖动对象和限制区域重合
					ddoX = lpp.x;
				}
				else if(ssp.x < 0){ // x方向拖动对象在限制区域里面
					if(spp.x < 0){
						ddoX = lpp.x;
					}
					else if(spp.x > - ssp.x){
						ddoX = lpp.x + lsp.x - dsp.x;
					} 
					else {
						ddoX = dpp.x;
					}
				}
				else if(ssp.x > 0){ // x方向拖动对象在限制区域外面
					if(spp.x < -ssp.x){
						ddoX = lpp.x + lsp.x - dsp.x;
					}
					else if(spp.x > 0){
						ddoX = lpp.x;
					}
					else {
						ddoX = dpp.x;
					}
				}
				
				if(ssp.y == 0){ // y方向拖动对象和限制区域重合
					ddoY = lpp.y;
				}
				else if(ssp.y < 0){ // y方向拖动对象在限制区域里面
					if(spp.y < 0){
						ddoY = lpp.y;
					}
					else if(spp.y > - ssp.y){
						ddoY = lpp.y + lsp.y - dsp.y;
					} 
					else {
						ddoY = dpp.y;
					}
				}
				else if(ssp.y > 0){ // y方向拖动对象在限制区域外面
					if(spp.y < -ssp.y){
						ddoY = lpp.y + lsp.y - dsp.y;
					}
					else if(spp.y > 0){
						ddoY = lpp.y;
					} 
					else {
						ddoY = dpp.y;
					}
				}
			}
			else {
				ddoX = dragDisplayObjectPlace.x;
				ddoY = dragDisplayObjectPlace.y;
			}
			return new Point(ddoX,ddoY);
		}
	}
}