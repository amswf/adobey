package com.snsoft.room3d{
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
	import flash.ui.Mouse;
	import com.snsoft.room3d.dataObject.RoomDO;
	import com.snsoft.room3d.dataObject.SeatDO;
	
	/**
	 * 房间平面图组件 
	 * @author Administrator
	 * 
	 */	
	public class RoomMap extends UIComponent{
		
		/**
		 * 房间平面图初始化完成事件类型 
		 */		
		public static const EVENT_ROOM_MAP_COMPLETE:String = "EVENT_ROOM_MAP_COMPLETE";

		/**
		 * 房间数据对象 
		 */		
		private var _roomDO:RoomDO;
		
		/**
		 * 是否绘制完 
		 */		
		private var isDraw:Boolean = false;
		
		public function RoomMap(room:RoomDO){
			this.roomDO = room;
			super();
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {};
		
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
				loadBgImg();
			}
		}
		
		/**
		 * 加载房间平面图 
		 * 
		 */		
		public function loadBgImg():void{
			if(roomDO.bgImgBitmap == null && roomDO.bgImgUrl != null){
				var imgl:ImageLoader = new ImageLoader();
				imgl.loadImage(roomDO.bgImgUrl);
				imgl.addEventListener(Event.COMPLETE,handlerLoaderBgImgCmp);
			}
			if(roomDO.bgImgBitmap != null) {
				init();
			}
		}
		
		/**
		 * 加载房间平面图，完成事件 
		 * @param e
		 * 
		 */		
		private function handlerLoaderBgImgCmp(e:Event):void{
			var imgl:ImageLoader = e.currentTarget as ImageLoader;
			roomDO.bgImgBitmap = imgl.bitmapData.clone();
			init();
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		private function init():void{
			var sourceSpr:Sprite = new Sprite();
			
			var bm:Bitmap = new Bitmap(roomDO.bgImgBitmap.clone(),"auto",true);
			sourceSpr.addChild(bm);			
			this.addChild(sourceSpr);
			this.width = bm.width;
			this.height = bm.height;
			this.dispatchEvent(new Event(EVENT_ROOM_MAP_COMPLETE));
		}
		
		public function get roomDO():RoomDO
		{
			return _roomDO;
		}
		
		public function set roomDO(value:RoomDO):void
		{
			_roomDO = value;
		}		
	}
}



