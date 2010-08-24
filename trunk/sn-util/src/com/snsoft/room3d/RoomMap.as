package com.snsoft.room3d{
	import com.snsoft.util.HashVector;
	import com.snsoft.util.ImageLoader;
	
	import fl.containers.ScrollPane;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Style(name="seatPointSkin", type="Class")]
	
	[Style(name="visualAngleSkin", type="Class")]
	
	
	public class RoomMap extends UIComponent{
		
		public static const EVENT_SEAT_POINT_MOUSE_CLICK:String = "EVENT_SEAT_POINT_MOUSE_CLICK";
		
		public static const EVENT_ROOM_MAP_COMPLETE:String = "EVENT_ROOM_MAP_COMPLETE";
		
		private var _room:RoomDO;
		
		private var _currentSeatDO:SeatDO;
		
		private var visualAngle:MovieClip;
		
		private var isDraw:Boolean = false;
		
		public function RoomMap(room:RoomDO){
			this.room = room;
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
			trace("draw");
			if(!isDraw){
				isDraw = true;
				loadBgImg();
			}
		}
		
		public function loadBgImg():void{
			if(room.bgImgBitmap == null && room.bgImgUrl != null){
				var imgl:ImageLoader = new ImageLoader();
				imgl.loadImage(room.bgImgUrl);
				imgl.addEventListener(Event.COMPLETE,handlerLoaderBgImgCmp);
			}
			if(room.bgImgBitmap != null) {
				init();
			}
		}
		
		private function handlerLoaderBgImgCmp(e:Event):void{
			var imgl:ImageLoader = e.currentTarget as ImageLoader;
			room.bgImgBitmap = imgl.bitmapData.clone();
			init();
		}
		
		private function init():void{
			var sourceSpr:Sprite = new Sprite();
			
			var bm:Bitmap = new Bitmap(room.bgImgBitmap.clone(),"auto",true);
			sourceSpr.addChild(bm);
			var placeHV:HashVector = this.room.placeHV;
			
			if(placeHV.length > 0){
				var seatDefaultDO:SeatDO = placeHV.findByIndex(0) as SeatDO;
				this.visualAngle = getDisplayObjectInstance(getStyleValue("visualAngleSkin")) as MovieClip;
				this.visualAngle.x = seatDefaultDO.place.x;
				this.visualAngle.y = seatDefaultDO.place.y;
				sourceSpr.addChild(this.visualAngle);
			}
			
			 
			for(var i:int = 0;i<placeHV.length;i++){
				var seatDO:SeatDO = placeHV.findByIndex(i) as SeatDO;
				var seatPoint:MovieClip = getDisplayObjectInstance(getStyleValue("seatPointSkin")) as MovieClip;
				seatPoint.x = seatDO.place.x;
				seatPoint.y = seatDO.place.y;
				sourceSpr.addChild(seatPoint);
				seatPoint.seatDO = seatDO;
				seatPoint.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
				seatPoint.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
				seatPoint.addEventListener(MouseEvent.CLICK,handlerMouseClick);
				if(i == 0){
					this._currentSeatDO = seatDO;
				}
			}
			
			this.addChild(sourceSpr);
			this.width = bm.width;
			this.height = bm.height;
			this.dispatchEvent(new Event(EVENT_ROOM_MAP_COMPLETE));
			
		}
		
		public function setVisualAngleRotation(rotation:Number):void{
			this.visualAngle.rotation = rotation;
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
			
			this.visualAngle.x = seatPoint.x;
			this.visualAngle.y = seatPoint.y;
			this.dispatchEvent(new Event(EVENT_SEAT_POINT_MOUSE_CLICK));
		}
		

		public function get room():RoomDO
		{
			return _room;
		}

		public function set room(value:RoomDO):void
		{
			_room = value;
		}

		public function get currentSeatDO():SeatDO
		{
			return _currentSeatDO;
		}


	}
}



