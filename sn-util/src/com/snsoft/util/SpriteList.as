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


		public function createSpliteList(spriteWidth:Number,spriteHeight:Number,childList:Array,childSpaseX:Number,childSpaseY:Number,listType:String):void {

			this.spriteWidth = spriteWidth;
			this.spriteHeight = spriteHeight;
			this.childList = childList;
			this.childSpaseX = childSpaseX;
			this.childSpaseY = childSpaseY;
			this.listType = listType;
			var uvs:Sprite = createUnvisibleSprite(spriteWidth,spriteHeight,true);
			this.addChild(uvs);
			refeshList();
			var stg:Stage = this.stage;
			if (stg != null) {
				stg.addEventListener(Event.RESIZE,handlerStageResize);
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
				var spr:Sprite = this.getChildByName(SPRITE_LIST) as Sprite;
				if (spr != null) {
					this.removeChild(spr);
				}
			} catch (e:Error) {
			}


			var sprite:Sprite = new Sprite();
			sprite.name = SPRITE_LIST;
			this.addChild(sprite);
			for (var i:int; i<childList.length; i++) {
				var sp:Sprite = childList[i] as Sprite;
				sp.x = childSpaseX * numX;
				sp.y = childSpaseY * numY;
				if (listType == ROW) {
					numX++;
					if (childSpaseX * (numX + 1) > spriteWidth) {
						numX = 0;
						numY++;
					}
				}
				if (listType == LIST) {
					numY++;
					if (childSpaseY * (numY + 1) > spriteHeight) {
						numY = 0;
						numX++;
					}
				}
				sprite.addChild(sp);
			}
		}


		private function createUnvisibleSprite(width:Number,height:Number,visible:Boolean = true):Sprite {
			var sprite:Sprite = new Sprite();
			sprite.visible = visible;
			var shape:Shape = new Shape();
			var gra:Graphics = shape.graphics;
			gra.beginFill(0x000000,1);
			gra.drawRect(0,0,width,height);
			gra.endFill();
			sprite.addChild(shape);
			return sprite;
		}
	}
}