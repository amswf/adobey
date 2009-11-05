package com.snsoft.util{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;


	/**
	 * Shape相对于某个DisplayObject固定上下左右边距。
	 */
	public class RelativePlace {
		//控制元件相对定位于某个DisplayObject
		private var displayObject:DisplayObject = null;

		private var spriteArray:Array = new Array();

		public static var TOP:String = "TOP";

		public static var BOTTOM:String = "BOTTOM";

		public static var TOP_BOTTOM:String = "TOP_BOTTOM";

		public static var CENTER:String = "CENTER";

		public static var LEFT:String = "LEFT";

		public static var RIGHT:String = "RIGHT";

		public static var LEFT_RIGHT:String = "LEFT_RIGHT";

		public static var MIDDLE:String = "MIDDLE";

		public static var UNVISIBLE_SPRITE_NAME:String = "UNVISIBLE_SPRITE_NAME";



		/**
		 * 构造方法
		 */
		public function RelativePlace(displayObject:DisplayObject) {

			this.displayObject = displayObject;

			doDisplayObjectResize();

		}

		public function addSprite(sprite:Sprite,relativeXType:String,relativeYType:String,leftSpase:Number = NaN,rightSpase:Number = NaN,topSpase:Number = NaN,bottomSpase:Number = NaN):void {
			if (sprite != null) {
				if (displayObject != null) {

					var doWidth:Number = 0;
					var doHeight:Number = 0;
					if (displayObject is Stage) {
						var stage:Stage = Stage(displayObject);
						doWidth = stage.stageWidth;
						doHeight = stage.stageHeight;
					}
					else if (displayObject is Sprite) {
						var spr:Sprite = Sprite(displayObject);
						var uvSprite:Sprite = spr.getChildByName(UNVISIBLE_SPRITE_NAME) as Sprite;
						var ly:Number = 0;
						var lx:Number = 0;
						for(var i:int=0;i<spr.numChildren;i++){
							var cspr:Sprite = spr.getChildAt(i) as Sprite;
							if(cspr.x <lx){
								lx = cspr.x;
							}
							if(cspr.y < ly){
								ly = cspr.y;
							}
						}
						if (uvSprite == null) {
							uvSprite = this.createUnvisibleSprite(spr.width,spr.height,true);
							uvSprite.x = lx;
							uvSprite.y = ly;
							uvSprite.name = UNVISIBLE_SPRITE_NAME;
							spr.addChildAt(uvSprite,0);
							spr.scaleX = 1;
							spr.scaleY = 1;
						}
						if (spr != null) {
							doWidth = spr.width;
							doHeight = spr.height;
						}
					}
					var ro:RelativeObject = new RelativeObject();
					ro.setRelativeXType(relativeXType);
					ro.setRelativeYType(relativeYType);
					var stg:Stage = sprite.stage;
					if (isNaN(leftSpase)) {
						ro.setLeftSpase(sprite.x);
					}
					else {
						ro.setLeftSpase(leftSpase);
					}
					if (isNaN(rightSpase)) {
						ro.setRightSpase(doWidth - sprite.width - sprite.x);
					}
					else {
						ro.setRightSpase(rightSpase);
					}
					if (isNaN(topSpase)) {
						ro.setTopSpase(sprite.y);
					}
					else {
						ro.setTopSpase(topSpase);
					}
					if (isNaN(rightSpase)) {
						ro.setBottomSpase(doHeight - sprite.height - sprite.y);
					}
					else {
						ro.setBottomSpase(bottomSpase);
					}
					ro.setSpriteBaseWidth(sprite.width);
					ro.setSpriteBaseHeight(sprite.height);
					ro.setSprite(sprite);
					this.spriteArray.push(ro);
				}
			}
		}

		/**
		 * DisplayObject改变宽高后的，设置元件的宽高及位置
		 */
		private function doDisplayObjectResize():void {
			if (displayObject != null) {
				var stage:Stage = displayObject.stage;
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.addEventListener(Event.RESIZE,handlerResize);
			}
		}

		private function handlerResize(e:Event):void {

			var doWidth:Number = 0;
			var doHeight:Number = 0;
			if (displayObject is Stage) {
				var stage:Stage = Stage(displayObject);
				doWidth = stage.stageWidth;
				doHeight = stage.stageHeight;
			}
			else if (displayObject is Sprite) {
				var spr:Sprite = Sprite(displayObject);
				var unspr:Sprite = spr.getChildByName(UNVISIBLE_SPRITE_NAME) as Sprite;
				if (unspr != null) {
					unspr.width = spr.width;
					unspr.height = spr.height;
					spr.scaleX = 1;
					spr.scaleY = 1;
					doWidth = unspr.width;
					doHeight = unspr.height;
				}
				else{
					doWidth = spr.width;
					doHeight = spr.height;
				}
			}
			if (spriteArray.length > 0 && doWidth > 0 && doHeight > 0) {
				for (var i:int=0; i<spriteArray.length; i++) {
					var ro:RelativeObject = spriteArray[i] as RelativeObject;
					if (ro != null) {
						var sprite:Sprite = ro.getSprite() as Sprite;
						if (sprite != null) {
							var rxt:String = ro.getRelativeXType() as String;
							if (rxt != null && rxt != "") {
								if (rxt.toUpperCase() == RelativePlace.LEFT) {
									sprite.x = ro.getLeftSpase();
								}
								else if (rxt.toUpperCase() == RelativePlace.RIGHT) {
									sprite.x = doWidth - ro.getRightSpase() - sprite.width;
								}
								else if (rxt.toUpperCase() == RelativePlace.LEFT_RIGHT) {
									sprite.x = ro.getLeftSpase();
									var w:Number = doWidth - ro.getLeftSpase() - ro.getRightSpase();
									if (w < ro.getSpriteBaseWidth()) {
										w = ro.getSpriteBaseWidth();
									}
									sprite.width = w;
								}
								else if (rxt.toUpperCase() == RelativePlace.CENTER) {
									sprite.x = (doWidth - sprite.width ) / 2;
								}
							}
							var ryt:String = ro.getRelativeYType() as String;
							if (ryt != null && ryt != "") {
								if (ryt.toUpperCase() == RelativePlace.TOP) {
									sprite.y = ro.getTopSpase();
								}
								else if (ryt.toUpperCase() == RelativePlace.BOTTOM) {
									sprite.y = doHeight - ro.getBottomSpase() - sprite.height;
								}
								else if (ryt.toUpperCase() == RelativePlace.TOP_BOTTOM) {
									sprite.y = ro.getTopSpase();
									var h:Number = doHeight - ro.getTopSpase() - ro.getBottomSpase();
									if (h < ro.getSpriteBaseHeight()) {
										h = ro.getSpriteBaseHeight();
									}
									sprite.height = h;
								}
								else if (ryt.toUpperCase() == RelativePlace.MIDDLE) {
									sprite.y = (doHeight - sprite.height ) / 2;
								}
							}
						}
					}
				}
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