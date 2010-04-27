package com.snsoft.util
{
	import com.snsoft.map.util.MapUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *  
	 * @author Administrator
	 * 
	 */	
	public class SpriteMouseAction extends EventDispatcher
	{
		//正在拖动事件名称
		public static const DRAG_MOVE_EVENT:String = "DRAG_MOVE_EVENT";
		
		//拖动完成事件名称
		public static const DRAG_COMPLETE_EVENT:String = "DRAG_COMPLETE_EVENT";
		
		//鼠标动作对象
		private var dragDisplayObject:DisplayObject;
		
		//鼠标动作对象动作时初始鼠标位置
		private var cuntryNameMousePoint:Point = new Point();
		
		//鼠标动作对象是否动作的标记
		private var cuntryNameMoveSign:Boolean = false;
		
		//拖动时限制拖动位置的其它对象
		private var dragLimitDisplayObject:DisplayObject;
		
		//拖动时拖动对象的显示位置，小地图中的移动框
		private var viewDrag:DisplayObject;
		
		//拖动时限制对象的显示位置，小地图中的限制框
		private var viewLimit:DisplayObject;
		
		//拖动对象可拖动区域起始坐标和可拖动区域的宽高
		private var dragRect:Rectangle = null;
		
		//显示位置对象可拖动区域起始坐标和可拖动区域的宽高
		private var viewDragRect:Rectangle = null;
		
		private var viewEvent:String = "DRAG_MOVE_EVENT";
		
		public function SpriteMouseAction(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * 
		 * @param drag
		 * @param dragLimit
		 * @param viewDrag
		 * @param viewLimit
		 * @param dragRect
		 * @param viewDragRect
		 * @param viewEvent
		 * 
		 */				
		public function addMouseDragEvents(drag:DisplayObject,
										   dragLimit:DisplayObject = null,
										   viewDrag:DisplayObject = null,
										   viewLimit:DisplayObject = null,
										   dragRect:Rectangle = null,
										   viewDragRect:Rectangle = null,
										   viewEvent:String = "DRAG_MOVE_EVENT"):void{
			
			this.dragDisplayObject = drag;
			this.dragLimitDisplayObject = dragLimit;
			this.viewDrag = viewDrag;
			this.viewLimit = viewLimit;
			this.viewEvent = viewEvent;
			this.dragRect = dragRect;
			this.viewDragRect = viewDragRect;
			var doc:DisplayObject = this.dragDisplayObject;
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
			var doc:DisplayObject = this.dragDisplayObject;
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
		 * 把当前拖动对象和限制对象，算出小地图中拖动对象的位置并置属性。 
		 * @param d
		 * @param l
		 * @param vd
		 * @param vl
		 * 
		 */		
		private function setViewPlace(d:DisplayObject,l:DisplayObject,vd:DisplayObject,vl:DisplayObject):void{
			var dlp:Point = new Point(d.width - l.width,d.height - l.height);
			var dlsp:Point = new Point(vd.width - vl.width,vd.height - vl.height);
			
			var dpp:Point = new Point();
			if(this.dragRect != null){
				var dragSize:Point = RectangleUtil.getSize(this.dragRect);
				var lSize:Point = new Point(l.width,l.height); 
				dlp = MapUtil.subPoint(dragSize,lSize);
				
				var dragPlace:Point = RectangleUtil.getPlace(this.dragRect);
				dpp = dragPlace;
			}
			
			var vdpp:Point = new Point();
			if(this.viewDragRect != null){
				var viewDragSize:Point = RectangleUtil.getSize(this.viewDragRect);
				var vlSize:Point = new Point(vl.width,vl.height); 
				dlsp = MapUtil.subPoint(viewDragSize,vlSize);
				
				var viewDragPlace:Point = RectangleUtil.getPlace(this.viewDragRect);
				vdpp = viewDragPlace;
			}
			
			if(dlp.x != 0){
				vd.x =  vl.x - vdpp.x + (d.x + dpp.x - l.x) * dlsp.x / dlp.x;
			}
			if(dlp.y != 0){
				vd.y =  vl.y - vdpp.y + (d.y + dpp.y - l.y) * dlsp.y / dlp.y;
			}
		}
		
		private function setView():void{
			if(this.dragLimitDisplayObject != null && this.viewDrag != null && this.viewLimit != null){
				this.setViewPlace(this.dragDisplayObject,this.dragLimitDisplayObject,this.viewDrag,this.viewLimit);
			}
		}
		
		/**
		 * MouseDown 事件 
		 * @param e
		 * 
		 */		
		private function handlerCnMouseDown(e:Event):void{
			var doc:DisplayObject = this.dragDisplayObject;
			var poc:DisplayObject = this.dragDisplayObject.parent;
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
			var doc:DisplayObject = this.dragDisplayObject;
			var poc:DisplayObject = this.dragDisplayObject.parent;
			var sign:Boolean = this.cuntryNameMoveSign;
			if(poc != null && sign){
				this.cuntryNameMoveSign = false;
				
				if(this.viewEvent == DRAG_COMPLETE_EVENT){
					this.setView();
				}
				this.dispatchEvent(new Event(DRAG_COMPLETE_EVENT));
			}
		}
		
		/**
		 * MouseMove 事件 
		 * @param e
		 * 
		 */		
		private function handlerCnMouseMove(e:Event):void{
			var doc:DisplayObject = this.dragDisplayObject;
			var poc:DisplayObject = this.dragDisplayObject.parent;
			if(poc != null){
				if(this.cuntryNameMoveSign){
					var p:Point = this.cuntryNameMousePoint;
					var docx:Number = poc.mouseX - p.x;
					var docy:Number = poc.mouseY - p.y;
					var docp:Point = new Point(docx,docy); 
					docp = calculateMoveLimitPoint(docp);
					MapUtil.setSpritePlace(doc,docp);
					if(this.viewEvent == DRAG_MOVE_EVENT){
						this.setView();
					}
					this.dispatchEvent(new Event(DRAG_MOVE_EVENT));
				}
			}
		}
		
		private function calculateMoveLimitPoint(dragDisplayObjectPlace:Point):Point{
			
			var ddoPlace:Point = new Point();
			
			//拖动对象
			var ddo:DisplayObject = this.dragDisplayObject;
			//限制对象
			var ldo:DisplayObject = this.dragLimitDisplayObject;
			
			if(ldo != null){
				//宽高
				var dsp:Point = MapUtil.getSpriteSize(ddo);//拖动对象
				var lsp:Point = MapUtil.getSpriteSize(ldo);//限制对象
				
				if(this.dragRect != null){
					dsp = RectangleUtil.getSize(this.dragRect);
				}
				
				//宽高差
				var ssp:Point = MapUtil.subPoint(dsp,lsp);
				
				//位置
				var dpp:Point = dragDisplayObjectPlace;//拖动对象
				var lpp:Point = MapUtil.getSpritePlace(ldo);//限制对象
				
				if(this.dragRect != null){
					var dragPlace:Point = RectangleUtil.getPlace(this.dragRect);
					lpp = MapUtil.subPoint(lpp,dragPlace);
				}
				
				//位置差
				var spp:Point = MapUtil.subPoint(dpp,lpp);
				
				if(ssp.x == 0){ // x方向拖动对象和限制区域重合
					ddoPlace.x = lpp.x;
				}
				else if(ssp.x < 0){ // x方向拖动对象在限制区域里面
					if(spp.x < 0){
						ddoPlace.x = lpp.x;
					}
					else if(spp.x > - ssp.x){
						ddoPlace.x = lpp.x + lsp.x - dsp.x;
					} 
					else {
						ddoPlace.x = dpp.x;
					}
				}
				else if(ssp.x > 0){ // x方向拖动对象在限制区域外面
					if(spp.x < -ssp.x){
						ddoPlace.x = lpp.x + lsp.x - dsp.x;
					}
					else if(spp.x > 0){
						ddoPlace.x = lpp.x;
					}
					else {
						ddoPlace.x = dpp.x;
					}
				}
				
				if(ssp.y == 0){ // y方向拖动对象和限制区域重合
					ddoPlace.y = lpp.y;
				}
				else if(ssp.y < 0){ // y方向拖动对象在限制区域里面
					if(spp.y < 0){
						ddoPlace.y = lpp.y;
					}
					else if(spp.y > - ssp.y){
						ddoPlace.y = lpp.y + lsp.y - dsp.y;
					} 
					else {
						ddoPlace.y = dpp.y;
					}
				}
				else if(ssp.y > 0){ // y方向拖动对象在限制区域外面
					if(spp.y < -ssp.y){
						ddoPlace.y = lpp.y + lsp.y - dsp.y;
					}
					else if(spp.y > 0){
						ddoPlace.y = lpp.y;
					} 
					else {
						ddoPlace.y = dpp.y;
					}
				}
			}
			else {
				
				ddoPlace.x = dragDisplayObjectPlace.x;
				ddoPlace.y = dragDisplayObjectPlace.y;
			}
			return ddoPlace;
		}
	}
}