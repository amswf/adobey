package com.snsoft.util.complexEvent{
	import com.snsoft.map.util.MapUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * 不好使，需要改进！！！！！！！！！！！！！！
	 * 
	 * 随鼠标移动，物体能够在在限制区内显示不同位置，最终实现在较小区域内移动显示物体的所有角落。 
	 * @author Administrator
	 * 
	 */	
	public class CplxMouseMove extends EventDispatcher{
		
		/**
		 * 移动的对象 
		 */		
		private var moveDobj:DisplayObject;
		
		/**
		 * 限制区域对象 
		 */		
		private var limitDobj:DisplayObject;
		
		/**
		 * 移动的对象 Rectangle
		 */		
		private var moveDobjRect:Rectangle;
		
		/**
		 * 限制区域对象 Rectangle
		 */		
		private var limitDobjRect:Rectangle;
		
		/**
		 * moveDobj 的 stage 属性 
		 */		
		private var moveDobjStage:Stage;
		
		private var addCount:int = 0;
		
		public function CplxMouseMove(moveDobj:DisplayObject,
									  limitDobj:DisplayObject,
									  moveDobjRect:Rectangle = null,
									  limitDobjRect:Rectangle = null,
									  target:IEventDispatcher=null){
			this.moveDobj = moveDobj;
			this.limitDobj = limitDobj;
			this.moveDobjRect = moveDobjRect;
			this.limitDobjRect = limitDobjRect;
			
			super(target);
		}
		
		/**
		 * 添加事件 
		 * @param moveDobj
		 * @param limitDobj
		 * @param moveDobjRect
		 * @param limitDobjRect
		 * 
		 */		
		public function addEvents():void{
			if(moveDobj != null && limitDobj != null){
				if(moveDobj.stage == null){
					addCount ++;
					this.moveDobj.addEventListener(Event.ADDED_TO_STAGE,handlerAddedToStageMoveDobj);
				}
				if(limitDobj.stage == null){
					addCount ++;
					limitDobj.addEventListener(Event.ADDED_TO_STAGE,handlerAddedToStageMoveDobj);
				}
				if(moveDobj.stage != null && limitDobj.stage != null){
					stageAddEventListener();
				}
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerAddedToStageMoveDobj(e:Event):void{
			if(moveDobj != null && limitDobj != null){
				stageAddEventListener();
			}
		}
		
		private function stageAddEventListener():void{
			trace("stageAddEventListener");
			if(addCount == 0){
				if(moveDobj.stage != null && limitDobj.stage != null){
					trace("stageAddEventListener");
					moveDobjStage = moveDobj.stage;
					moveDobj.stage.addEventListener(MouseEvent.MOUSE_MOVE,handlerMouseMove);
				}
			}
			else {
				addCount --;
			}
		}
			
			/**
			 * 
			 * @param e
			 * 
			 */		
			private function handlerMouseMove(e:Event):void{
				trace("handlerMouseMove");
				if(this.moveDobj != null && this.limitDobj != null){
					if(this.moveDobj.stage != null && this.limitDobj.stage != null){
						
						//限制区域对象 Rectangle
						var lrect:Rectangle = null;
						if(this.limitDobjRect != null){
							lrect = this.limitDobjRect.clone();
						}
						else{
							lrect = this.limitDobj.getRect(this.limitDobj.parent).clone();
						}
						
						//移动对象 Rectangle
						var mrect:Rectangle = null;
						if(this.moveDobjRect != null){
							mrect = this.moveDobjRect.clone();
						}
						else{
							mrect = this.moveDobj.getRect(this.moveDobj.parent).clone();
						}
						
						var mouseP:Point = new Point(this.moveDobj.mouseX,this.moveDobj.mouseY);
						
						var mpp:Point = MapUtil.getSpritePlace(this.moveDobj);
						if(mrect.x > lrect.x){
							mpp.x = mouseP.x * mrect.x / lrect.x;
						}
						
						if(mrect.y > lrect.y){
							mpp.y = mouseP.y * mrect.y / lrect.y;
						}
						MapUtil.setSpritePlace(this.moveDobj,mpp);
					}
				}
			}
			
			/**
			 * 删除事件 
			 * 
			 */		
			public function removeEvents():void{
				if(this.moveDobj != null && this.limitDobj != null){
					if(this.moveDobj.stage != null && this.limitDobj.stage != null){
						moveDobj.stage.removeEventListener(MouseEvent.MOUSE_MOVE,handlerMouseMove);
					}
				}
			}
		}
	}