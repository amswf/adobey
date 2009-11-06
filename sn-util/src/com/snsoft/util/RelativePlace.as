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

		private var childSpriteIsRelative:Boolean = false;

		/**
		 * 构造方法
		 */
		public function RelativePlace(displayObject:DisplayObject) {

			this.displayObject = displayObject;

			doDisplayObjectResize();

		}

		public function addSprite(sprite:Sprite,relativeXType:String,relativeYType:String,baseWidth:Number = 0,baseHeight:Number = 0,leftSpase:Number = NaN,rightSpase:Number = NaN,topSpase:Number = NaN,bottomSpase:Number = NaN):void {

			if (sprite != null) {

				//父元件的宽高值
				var doWidth:Number = 0;
				var doHeight:Number = 0;

				//父元件是场景时
				if (displayObject is Stage) {
					var stage:Stage = Stage(displayObject);
					doWidth = stage.stageWidth;
					doHeight = stage.stageHeight;
				}
				else if (displayObject is Sprite) {//父元件是Sprite时
					var dobj:Sprite = displayObject as Sprite;
					if (dobj != null) {
						var uvs:Sprite = this.getUnvisibleSprite(dobj) as Sprite;
						if (uvs != null) {
							doWidth = uvs.width;
							doHeight = uvs.height;
						}
					}
				}

				//添加的sprite的宽高
				var spriteWidth:Number = sprite.width;
				var spriteHeigh:Number = sprite.height;
				
				//sprite无缩放
				sprite.scaleX = 1;
				sprite.scaleY = 1;

				//如果指定了sprite的宽高，则sprite自身宽高无效
				if (baseWidth > 0) {
					spriteWidth = baseWidth;
				}
				if (baseHeight > 0) {
					spriteHeigh = baseHeight;
				}

				//子元件添加辅助用的不可见元件
				this.addUnvisibleSprite(sprite,spriteWidth,spriteHeigh);
				
				//创建并设置相对位置对像
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
					ro.setRightSpase(doWidth - spriteWidth - sprite.x);
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
					ro.setBottomSpase(doHeight - spriteHeigh - sprite.y);
				}
				else {
					ro.setBottomSpase(bottomSpase);
				}
				ro.setSpriteBaseWidth(spriteWidth);
				ro.setSpriteBaseHeight(spriteHeigh);
				ro.setSprite(sprite);

				//把添加的sprite放入列表中
				this.spriteArray.push(ro);
			}
		}

		/**
		 * DisplayObject改变宽高后的，设置元件的宽高及位置
		 * 
		 */
		private function doDisplayObjectResize():void {
			if (displayObject != null) {
				var stage:Stage = displayObject.stage;
				stage.align = StageAlign.TOP_LEFT;
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.addEventListener(Event.RESIZE,handlerResize);
			}
		}

		/**
		 * stage 重置大小后事件，调整相对位置 
		 * @param e
		 * 
		 */
		private function handlerResize(e:Event):void {

			var doWidth:Number = 0;
			var doHeight:Number = 0;
			if (displayObject is Stage) {
				var stage:Stage = Stage(displayObject);
				doWidth = stage.stageWidth;
				doHeight = stage.stageHeight;
			}
			else if (displayObject is Sprite) {
				var spr:Sprite = displayObject as Sprite;
				if (spr != null) {
					trace(doWidth);
					var uvs:Sprite = this.getUnvisibleSprite(spr);
					if (uvs != null) {
						spr.scaleX = 1;
						spr.scaleY = 1;
						doWidth = uvs.width;
						doHeight = uvs.height;
					}
				}
			}
			
			if (spriteArray.length > 0 && doWidth > 0 && doHeight > 0) {
				for (var i:int=0; i<spriteArray.length; i++) {
					var ro:RelativeObject = spriteArray[i] as RelativeObject;
					if (ro != null) {
						var sprite:Sprite = ro.getSprite() as Sprite;
						if (sprite != null) {
							var suvs:Sprite = this.getUnvisibleSprite(sprite);
							if (suvs != null) {
								var rxt:String = ro.getRelativeXType() as String;
								if (rxt != null && rxt != "") {
									if (rxt.toUpperCase() == RelativePlace.LEFT) {
										sprite.x = ro.getLeftSpase();
									}
									else if (rxt.toUpperCase() == RelativePlace.RIGHT) {
										sprite.x = doWidth - ro.getRightSpase() - suvs.width;
									}
									else if (rxt.toUpperCase() == RelativePlace.LEFT_RIGHT) {
										sprite.x = ro.getLeftSpase();
										var w:Number = doWidth - ro.getLeftSpase() - ro.getRightSpase();
										if (w < ro.getSpriteBaseWidth()) {
											w = ro.getSpriteBaseWidth();
										}
										suvs.width = w;
									}
									else if (rxt.toUpperCase() == RelativePlace.CENTER) {
										sprite.x = (doWidth - suvs.width ) / 2;
									}
								}
								var ryt:String = ro.getRelativeYType() as String;
								if (ryt != null && ryt != "") {
									if (ryt.toUpperCase() == RelativePlace.TOP) {
										sprite.y = ro.getTopSpase();
									}
									else if (ryt.toUpperCase() == RelativePlace.BOTTOM) {
										sprite.y = doHeight - ro.getBottomSpase() - suvs.height;
									}
									else if (ryt.toUpperCase() == RelativePlace.TOP_BOTTOM) {
										sprite.y = ro.getTopSpase();
										var h:Number = doHeight - ro.getTopSpase() - ro.getBottomSpase();
										if (h < ro.getSpriteBaseHeight()) {
											h = ro.getSpriteBaseHeight();
										}
										suvs.height = h;
									}
									else if (ryt.toUpperCase() == RelativePlace.MIDDLE) {
										sprite.y = (doHeight - suvs.height ) / 2;
									}
								}
							}
						}
					}
				}
			}
		}


		/**
		 * 给元件添加一个辅助用的不可见元件用来确定sprite相对位置信息
		 * @param sprite
		 * 
		 */
		private function addUnvisibleSprite(sprite:Sprite,uvsWidth:Number = NaN,uvsHeight:Number =NaN):void {

			var uvs:Sprite = sprite.getChildByName(UNVISIBLE_SPRITE_NAME) as Sprite;
			if (uvs == null) {
				if (isNaN(uvsWidth)) {
					uvsWidth = sprite.width;
				}
				if (isNaN(uvsHeight)) {
					uvsHeight = sprite.height;
				}
				uvs = createUnvisibleSprite(uvsWidth,uvsHeight,true);
				uvs.name = UNVISIBLE_SPRITE_NAME;
				sprite.addChildAt(uvs,0);
			}
		}

		/**
		 * 获得元件的辅助用的不可见元件用来确定sprite相对位置信息 
		 * @param sprite
		 * 
		 */
		public function getUnvisibleSprite(sprite:Sprite):Sprite {

			var uvs:Sprite = null;
			try {
				uvs = sprite.getChildByName(UNVISIBLE_SPRITE_NAME) as Sprite;
			} catch (e:Error) {
			}
			return uvs;
		}



		/**
		 * 创建一个辅助用的不可见元件用来确定sprite相对位置信息
		 * @param width
		 * @param height
		 * @param visible
		 * @return 
		 * 
		 */
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