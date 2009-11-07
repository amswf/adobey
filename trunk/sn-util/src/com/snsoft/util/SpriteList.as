package com.snsoft.util{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;


	/**
	 * 在可变stage下保持MC相对位置及自动宽高
	 * @author Administrator
	 * 
	 */	
	public class SpriteList extends Sprite {

		private static var ROW:String = "ROW";

		private static var LIST:String = "LIST";

		private static var SPRITE_LIST:String = "SPRITE_LIST";

		private var spriteWidth:Number = 0;

		private var spriteHeight:Number = 0;

		private var childList:Array = new Array();

		private var childSpaseX:Number = 0;

		private var childSpaseY:Number = 0;

		private var listType:String = "ROW";
		
		private var rpuvs:RelativePlace = null;
		
		private var rplist:RelativePlace = null;


		/**
		 * 添加信息列表 
		 * @param spriteWidth
		 * @param spriteHeight
		 * @param childList
		 * @param childSpaseX
		 * @param childSpaseY
		 * @param listType
		 * 
		 */		
		public function createSpliteList(spriteWidth:Number,spriteHeight:Number,childList:Array,childSpaseX:Number,childSpaseY:Number,listType:String):void {
			
			this.spriteWidth = spriteWidth;
			this.spriteHeight = spriteHeight;
			this.childList = childList;
			this.childSpaseX = childSpaseX;
			this.childSpaseY = childSpaseY;
			this.listType = listType;
			var stg:Stage = this.stage;
			if (stg != null) {
				rplist = new RelativePlace(this);
				rplist.addUnvisibleSprite(this,spriteWidth,spriteHeight);
				stg.addEventListener(Event.RESIZE,handlerStageResize);
				stg.addEventListener(Event.ENTER_FRAME,handlerStageResize);
				refeshList();
			}
		}
		
		
		/**
		 * 刷新列表显示事件响应
		 * @param e
		 * 
		 */		
		public function handlerStageResize(e:Event):void {
			var stg:Stage = this.stage;
			if (stg != null) {
				stg.removeEventListener(Event.ENTER_FRAME,handlerStageResize)
			}
			refeshList();
		}
		
		
		/**
		 * 刷新显示列表 
		 * @return 
		 * 
		 */		
		public function refeshList() {

			var bWidth:Number = 0;
			var bHeight:Number = 0;

			var numX:Number = 0;
			var numY:Number = 0;
			try {
				for (var j:int = 0; j<this.numChildren; j++) {
					var sprite:Sprite = this.getChildAt(j) as Sprite;
					if (sprite != null) {
						var sname:String = sprite.name;
						if (sname.indexOf("CHILD_LIST") >= 0) {
							this.removeChildAt(j);
						}
					}
				}
			} catch (e:Error) {
			}
			
			var uvs:Sprite = this.getChildByName(RelativePlace.UNVISIBLE_SPRITE_NAME) as Sprite;
			if(uvs != null){
				bWidth = uvs.width;
				bHeight = uvs.height;
			}
			else{
				bWidth = spriteWidth;
				bHeight = spriteHeight;
			}
			for (var i:int; i<childList.length; i++) {
				var sp:Sprite = childList[i] as Sprite;
				sp.name = "CHILD_LIST" + i;
				sp.x = childSpaseX * numX;
				sp.y = childSpaseY * numY;
				rplist.addSprite(sp,"","");
				if (listType == ROW) {
					numX++;
					if (childSpaseX * (numX + 1) > bWidth) {
						numX = 0;
						numY++;
					}
				}
				if (listType == LIST) {
					numY++;
					if (childSpaseY * (numY + 1) > bHeight) {
						numY = 0;
						numX++;
					}
				}
				this.addChild(sp);
			}
		}
		
		
		/**
		 * 创建一个辅助用的不可见元件用来确定sprite相对位置信息
		 * @param width
		 * @param height
		 * @param visible
		 * @return 
		 * 
		 */
		private function createUnvisibleSprite(width:Number,height:Number,visible:Boolean = true):MovieClip {

			var uvmc:MovieClip = new MovieClip();
			uvmc.visible = visible;
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.beginFill(0x000000,1);
			gra.drawRect(0,0,width,height);
			gra.endFill();
			uvmc.addChild(shape);
			return uvmc;
		}
	}
}