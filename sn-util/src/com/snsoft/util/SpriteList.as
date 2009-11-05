package com.snsoft.util{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * 在可变stage下保持MC相对位置及自动宽高
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


		public function createSpliteList(spriteWidth:Number,spriteHeight:Number,childList:Array,childSpaseX:Number,childSpaseY:Number,listType:String):void {
			
			
			this.spriteWidth = spriteWidth;
			this.spriteHeight = spriteHeight;
			this.childList = childList;
			this.childSpaseX = childSpaseX;
			this.childSpaseY = childSpaseY;
			this.listType = listType;
			var uvs:Sprite = createUnvisibleSprite(spriteWidth,spriteHeight,true);
			uvs.name = "UVS";
			this.addChild(uvs);
			var stg:Stage = this.stage;
			if (stg != null) {
				rpuvs = new RelativePlace(this);
				rpuvs.addSprite(uvs,"LEFT","TOP");
				stg.addEventListener(Event.RESIZE,handlerStageResize);
				refeshList();
			}

		}

		public function handlerStageResize(e:Event):void {
			refeshList();
		}

		public function refeshList() {

			var mainX:Number = 0;
			var mainY:Number = 0;

			var numX:Number = 0;
			var numY:Number = 0;
			try {
				for (var j:int = 0; j<this.numChildren; j++) {
					var sprite:Sprite = this.getChildAt(j) as Sprite;
					if (sprite != null) {
						var sname:String = sprite.name;
						trace(sname.indexOf("CHILD_LIST"));
						if (sname.indexOf("CHILD_LIST") >= 0) {
							this.removeChildAt(j);
						}
					}
				}
			} catch (e:Error) {
			}
			rplist = new RelativePlace(this);
			var uvs:Sprite = this.getChildByName(RelativePlace.UNVISIBLE_SPRITE_NAME) as Sprite;
			for (var i:int; i<childList.length; i++) {
				var sp:Sprite = childList[i] as Sprite;
				sp.name = "CHILD_LIST" + i;
				sp.x = childSpaseX * numX;
				sp.y = childSpaseY * numY;
				rplist.addSprite(sp,"LEFT","TOP");
				if (listType == ROW) {
					numX++;
					if (childSpaseX * (numX + 1) > uvs.width) {
						numX = 0;
						numY++;
					}
				}
				if (listType == LIST) {
					numY++;
					if (childSpaseY * (numY + 1) > uvs.height) {
						numY = 0;
						numX++;
					}
				}
				this.addChild(sp);
			}
		}


		private function createUnvisibleSprite(width:Number,height:Number,visible:Boolean = true):Sprite {
			var sprite:Sprite = new Sprite();
			sprite.visible = visible;
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.beginFill(0x00ff00,1);
			gra.drawRect(0,0,width,height);
			gra.endFill();
			sprite.addChild(shape);
			return sprite;
		}
	}
}