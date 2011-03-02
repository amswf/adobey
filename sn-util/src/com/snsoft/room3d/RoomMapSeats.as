package com.snsoft.room3d{
	import com.snsoft.room3d.dataObject.RoomDO;
	import com.snsoft.room3d.dataObject.SeatDO;
	import com.snsoft.util.HashVector;
	import com.snsoft.util.images.ImageLoader;
	
	import fl.containers.ScrollPane;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	
	[Style(name="seatPointSkin", type="Class")]
	
	[Style(name="visualAngleSkin", type="Class")]
	
	/**
	 * 房间平面图组件 
	 * @author Administrator
	 * 
	 */	
	public class RoomMapSeats extends UIComponent{
		
		/**
		 * 观察点鼠标点击事件类型 
		 */		
		public static const EVENT_SEAT_POINT_MOUSE_CLICK:String = "EVENT_SEAT_POINT_MOUSE_CLICK";
		
		/**
		 * 房间平面图初始化完成事件类型 
		 */		
		public static const EVENT_ROOM_MAP_COMPLETE:String = "EVENT_ROOM_MAP_COMPLETE";
		
		/**
		 * 旋转视角事件
		 */			
		public static const EVENT_VISUAL_ANGLE_ROTATE:String = "EVENT_VISUAL_ANGLE_ROTATE";
		
		/**
		 * 没有旋转事件 
		 */		
		public static const EVENT_VISUAL_ANGLE_ROTATE_STOP:String = "EVENT_VISUAL_ANGLE_ROTATE_STOP";
		
		
		/**
		 * 房间数据对象 
		 */		
		private var _roomDO:RoomDO;
		
		/**
		 *当前观察点3D显示对象 
		 */		
		private var _currentSeatDO:SeatDO;
		
		/**
		 * 当前视角，显示一个扇形
		 */		
		private var visualAngle:MovieClip;
		
		/**
		 * 是否绘制完 
		 */		
		private var isDraw:Boolean = false;
		
		/**
		 * 是否按下鼠标可旋转视角 
		 */		
		private var isRotation:Boolean = false;
		
		/**
		 * 鼠标按下时相对视角原点的角度 
		 */		
		private var mouseDownRotation:Number;
		
		/**
		 * 当前视视角的角度值 
		 */		
		private var visualAngleRotation:Number;
		
		
		private var seatPoints:Sprite;
		
		private var seatPointsMask:Sprite;
		
		public function RoomMapSeats(room:RoomDO){
			this.roomDO = room;
			super();
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			seatPointSkin:"SeatPoint_Skin",
			visualAngleSkin:"VisualAngle_Skin"
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
		override protected function configUI():void{			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			super.configUI();
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			trace("RoomMap draw");
			if(!isDraw){
				trace("RoomMap draw false");
				isDraw = true;
				init();
			}
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		private function init():void{
			seatPoints = new Sprite();
			var placeHV:HashVector = this.roomDO.placeHV;
			
			if(placeHV.length > 0){
				trace("creat visualAngle");
				var seatDefaultDO:SeatDO = placeHV.findByIndex(0) as SeatDO;
				this.visualAngle = getDisplayObjectInstance(getStyleValue("visualAngleSkin")) as MovieClip;
				
				trace("creat visualAngle",this.visualAngle);
				this.visualAngle.x = seatDefaultDO.place.x;
				this.visualAngle.y = seatDefaultDO.place.y;
				seatPoints.addChild(this.visualAngle);
				
				this.visualAngle.addEventListener(MouseEvent.MOUSE_DOWN,handlerVisualAngleMouseDown);
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE,handlerVisualAngleMouseMove);
				this.stage.addEventListener(MouseEvent.MOUSE_UP,handlerVisualAngleMouseUp);
			}
			
			for(var i:int = 0;i<placeHV.length;i++){
				var seatDO:SeatDO = placeHV.findByIndex(i) as SeatDO;
				var seatPoint:MovieClip = getDisplayObjectInstance(getStyleValue("seatPointSkin")) as MovieClip;
				seatPoint.x = seatDO.place.x;
				seatPoint.y = seatDO.place.y;
				seatPoints.addChild(seatPoint);
				seatPoint.seatDO = seatDO;
				seatPoint.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
				seatPoint.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
				seatPoint.addEventListener(MouseEvent.CLICK,handlerMouseClick);
				if(i == 0){
					this._currentSeatDO = seatDO;
				}
			}
			
			this.addChild(seatPoints);
			
			seatPointsMask = new Sprite();
			seatPointsMask.graphics.beginFill(0x000000);
			seatPointsMask.graphics.drawRect(0,0,this.width-15,this.height-15);
			seatPointsMask.graphics.endFill();
			this.addChild(seatPointsMask);
			seatPoints.mask = seatPointsMask;
			this.dispatchEvent(new Event(EVENT_ROOM_MAP_COMPLETE));
			
		}
		
		public function setScrollPosition(x:Number,y:Number):void{
			if(seatPoints != null){
				seatPoints.x = x;
				seatPoints.y = y;
			}
		}
		
		private function handlerVisualAngleMouseDown(e:Event):void{
			isRotation = true;
			mouseDownRotation = this.calculateRotation();
			visualAngleRotation = this.visualAngle.rotation;
		}
		
		private function handlerVisualAngleMouseUp(e:Event):void{
			isRotation = false;
		}
		
		private function handlerVisualAngleMouseMove(e:Event):void{
			if(isRotation){
				var nRotation:Number = this.calculateRotation();
				this.visualAngle.rotation = visualAngleRotation + nRotation - mouseDownRotation;
				this.dispatchEvent(new Event(EVENT_VISUAL_ANGLE_ROTATE));
			}
			else {
				this.dispatchEvent(new Event(EVENT_VISUAL_ANGLE_ROTATE_STOP));
			}
		}
		
		
		
		private function calculateRotation():Number{
			var rate:Number = 0;
			
			var py:Number = seatPoints.mouseY - this.visualAngle.y;
			var px:Number = seatPoints.mouseX - this.visualAngle.x;
			
			var brate:Number;
			if(px == 0){
				if(py > 0){
					rate = 90;
				}
				else if(py < 0){
					rate = -90;
				}
				else if(py == 0){
					rate = 0;
				}
			}
			else if(px > 0){
				brate = Math.atan(Math.abs(py/px)) * 180 / Math.PI;
				if(py > 0){
					rate = brate;
				}
				else if(py < 0){
					rate = 360 - brate;
				}
				else if(py == 0){
					rate = 0;
				}
			}
			else if(px < 0){
				brate = Math.atan(Math.abs(py/px)) * 180 / Math.PI;
				if(py > 0){
					rate = 180  - brate;
				}
				else if(py < 0){
					rate = 180 + brate;
				}
				else if(py == 0){
					rate = 180;
				}
			}
			return rate;
		}
		
		public function setVisualAngleRotation(rotation:Number):void{
			if(this.visualAngle != null){
				this.visualAngle.rotation = rotation;
			}
		}
		
		public function getVisualAngleRotation():Number{
			return this.visualAngle.rotation;
		}
		
		private function handlerMouseOver(e:Event):void{
			var seatPoint:MovieClip = e.currentTarget as MovieClip;
			seatPoint.scaleX = 1.2;
			seatPoint.scaleY = 1.2;
		}
		
		private function handlerMouseOut(e:Event):void{
			var seatPoint:MovieClip = e.currentTarget as MovieClip;
			seatPoint.scaleX = 1;
			seatPoint.scaleY = 1;
		}
		
		private function handlerMouseClick(e:Event):void{
			var seatPoint:MovieClip = e.currentTarget as MovieClip;
			this._currentSeatDO = seatPoint.seatDO;
			setVisualAngle(currentSeatDO);
			this.dispatchEvent(new Event(EVENT_SEAT_POINT_MOUSE_CLICK));
		}
		
		/**
		 * 设置视角位置 
		 * @param seatDO
		 * 
		 */		
		public function setVisualAngle(seatDO:SeatDO):void{
			this.visualAngle.x = seatDO.place.x;
			this.visualAngle.y = seatDO.place.y;
		}
		
		public function get roomDO():RoomDO
		{
			return _roomDO;
		}
		
		public function set roomDO(value:RoomDO):void
		{
			_roomDO = value;
		}
		
		public function get currentSeatDO():SeatDO
		{
			return _currentSeatDO;
		}
		
		
	}
}


