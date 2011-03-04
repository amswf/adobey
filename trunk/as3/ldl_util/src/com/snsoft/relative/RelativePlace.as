package com.snsoft.relative{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
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
		
		//相对位置控制父结点DisplayObject
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
		
		private var childRelativeSpriteNum:int = 0;

		private static var IS_HIDE_UNVISIBLE_SPRITE:Boolean = false;
		/**
		 * 构造方法 
		 * @param displayObject
		 * 
		 */		
		public function RelativePlace(displayObject:DisplayObject) {

			this.displayObject = displayObject;

			doDisplayObjectResize();

		}

		/**
		 * 添加子相对位置Sprite 
		 * 
		 * @param sprite
		 * @param relativeXType
		 * @param relativeYType
		 * @param baseWidth
		 * @param baseHeight
		 * @param leftSpase
		 * @param rightSpase
		 * @param topSpase
		 * @param bottomSpase
		 * 
		 */		
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
				else if (displayObject is MovieClip) {//父元件是MovieClip时
					var dobj:MovieClip = displayObject as MovieClip;
					if (dobj != null) {
						doWidth = dobj.relativeWidth;
						doHeight = dobj.relativeHeight;
						dobj.hasChildRalative = true;
					}
				}
				else if(displayObject is UIComponent){
					var comp:UIComponent = displayObject as UIComponent;
					if(comp != null){
						comp.invalidate(InvalidationType.SIZE);
						doWidth = comp.width;
						doHeight = comp.height;
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
				
				if (sprite is MovieClip) {//父元件是Sprite时
					var mc:MovieClip = sprite as MovieClip;
					if (mc != null) {
						mc.relativeWidth = spriteWidth;
						mc.relativeHeight = spriteHeigh;
					}
				}				
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
				stage.addEventListener(Event.ENTER_FRAME,handlerResize);
			}
		}

		/**
		 * stage 重置大小后事件，调整相对位置 
		 * @param e
		 * 
		 */
		private function handlerResize(e:Event):void {
			var stg:Stage = displayObject.stage;
			if (stg != null) {
				stg.removeEventListener(Event.ENTER_FRAME,handlerResize)
			}
			
			var doWidth:Number = 0;
			var doHeight:Number = 0;
			if (displayObject is Stage) {
				var stage:Stage = Stage(displayObject);
				doWidth = stage.stageWidth;
				doHeight = stage.stageHeight;
			}
			else if (displayObject is MovieClip) {//父元件是MovieClip时
				var domc:MovieClip = displayObject as MovieClip;
				if (domc != null) {
					doWidth = domc.relativeWidth * domc.scaleX;
					doHeight = domc.relativeHeight * domc.scaleY;
					domc.scaleX = 1;
					domc.scaleY = 1;
				}
			}
			else if(displayObject is UIComponent){
				var docomp:UIComponent = displayObject as UIComponent;
				if(docomp != null){
					doWidth = docomp.width;
					doHeight = docomp.height;
				}
			}
			if (spriteArray.length > 0 && doWidth > 0 && doHeight > 0) {
				for (var i:int=0; i<spriteArray.length; i++) {
					var ro:RelativeObject = spriteArray[i] as RelativeObject;
					if (ro != null) {
						var sprite:Sprite = ro.getSprite() as Sprite;
						if (sprite != null) {
							var spriteWidth:Number = 0;
							var spriteHeight:Number = 0;
							var mc:MovieClip = null;
							var comp:UIComponent = null;
							if(sprite is MovieClip){
								mc = sprite as MovieClip;
								spriteWidth = mc.relativeWidth;
								spriteHeight = mc.relativeHeight;
							}
							else if(sprite is UIComponent){
								comp = sprite as UIComponent;
								spriteWidth = comp.width;
								spriteHeight = comp.height;
							}
							var rxt:String = ro.getRelativeXType() as String;
							if (rxt != null && rxt != "") {
								if (rxt.toUpperCase() == RelativePlace.LEFT) {
									sprite.x = ro.getLeftSpase();
								}
								else if (rxt.toUpperCase() == RelativePlace.RIGHT) {
									sprite.x = doWidth - ro.getRightSpase() - spriteWidth;
								}
								else if (rxt.toUpperCase() == RelativePlace.LEFT_RIGHT) {
									sprite.x = ro.getLeftSpase();
									var w:Number = doWidth - ro.getLeftSpase() - ro.getRightSpase();
									if (w < ro.getSpriteBaseWidth()) {
										w = ro.getSpriteBaseWidth();
									}
									if(sprite is MovieClip){
										mc.relativeWidth = w;
									}
									else if(sprite is UIComponent){
										comp.width = w;
									}
								}
								else if (rxt.toUpperCase() == RelativePlace.CENTER) {
									sprite.x = (doWidth - spriteWidth ) / 2;
								}
							}
							var ryt:String = ro.getRelativeYType() as String;
							if (ryt != null && ryt != "") {
								if (ryt.toUpperCase() == RelativePlace.TOP) {
									sprite.y = ro.getTopSpase();
								}
								else if (ryt.toUpperCase() == RelativePlace.BOTTOM) {
									sprite.y = doHeight - ro.getBottomSpase() - spriteHeight;
								}
								else if (ryt.toUpperCase() == RelativePlace.TOP_BOTTOM) {
									sprite.y = ro.getTopSpase();
									var h:Number = doHeight - ro.getTopSpase() - ro.getBottomSpase();
									if (h < ro.getSpriteBaseHeight()) {
										h = ro.getSpriteBaseHeight();
									}
									
									if(sprite is MovieClip){
										mc.relativeHeight = h;
									}
									else if(sprite is UIComponent){
										comp.height = h;
									}
								}
								else if (ryt.toUpperCase() == RelativePlace.MIDDLE) {
									sprite.y = (doHeight - spriteHeight ) / 2;
								}
							}
							if ((rxt != null && rxt != "") ||(ryt != null && ryt != "") ) {
								if(sprite is MovieClip){
									var hasCR:Boolean = mc.hasChildRalative;
									if(!hasCR){
										this.setAllChildSpriteSize(sprite,mc.relativeWidth,mc.relativeHeight);
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
		public function addUnvisibleSprite(sprite:Sprite,uvsWidth:Number = NaN,uvsHeight:Number =NaN):void {

			var uvmc:MovieClip = sprite.getChildByName(UNVISIBLE_SPRITE_NAME) as MovieClip;
			if (uvmc == null) {
				if (isNaN(uvsWidth)) {
					uvsWidth = sprite.width;
				}
				if (isNaN(uvsHeight)) {
					uvsHeight = sprite.height;
				}
				uvmc = createUnvisibleSprite(uvsWidth,uvsHeight,IS_HIDE_UNVISIBLE_SPRITE);
				uvmc.name = UNVISIBLE_SPRITE_NAME;
				sprite.addChild(uvmc);
			}
		}
		
		/**
		 * 设置 DisplayObject 是否有子相对位置控制
		 * 
		 * @param has
		 * @return 
		 * 
		 */		
		public function setDisplayObjectHasChildRalative(has:Boolean):Boolean{
			var dobj:Sprite = this.displayObject as Sprite;
			if(dobj != null){
				var uvmc:MovieClip = this.getUnvisibleSprite(dobj);
				uvmc.hasChildRalative = has;
				return true;
			}
			return false;
		}
		
		/**
		 * 获得 DisplayObject 是否有子相对位置控制 
		 * @return 
		 * 
		 */		
		public function getDisplayObjectHasChildRalative(sprite:Sprite):Boolean{
			if(sprite != null){
				var uvmc:MovieClip = this.getUnvisibleSprite(sprite);
				return Boolean(uvmc.hasChildRalative);
			}
			return false;
		}

		/**
		 * 获得元件的辅助用的不可见元件用来确定sprite相对位置信息 
		 * @param sprite
		 * 
		 */
		public function getUnvisibleSprite(sprite:Sprite):MovieClip {

			var uvmc:MovieClip = null;
			try {
				uvmc = sprite.getChildByName(UNVISIBLE_SPRITE_NAME) as MovieClip;
			} catch (e:Error) {
			}
			return uvmc;
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
			gra.beginFill(0x000000,0.1);
			gra.drawRect(0,0,width,height);
			gra.endFill();
			uvmc.addChild(shape);
			return uvmc;
		}
		
		public function setAllChildSpriteSize(sprite:Sprite,width:Number = NaN,height:Number = NaN):void{
			
			if(sprite != null){
				var mc:MovieClip = sprite as MovieClip;
				if(mc != null){
					if(isNaN(width)){
						width = mc.relativeWidth;
					}
					if(isNaN(height)){
						height = mc.relativeHeight;
					}
					var hasMC:Boolean = false;
					for(var i:int = 0;i<sprite.numChildren;i++){
						if( sprite.getChildAt(i) is MovieClip){
							hasMC = true;
						}
					}
					if(hasMC){
						for(var j:int = 0;j<sprite.numChildren;j++){
							var cs:DisplayObject = sprite.getChildAt(j) as DisplayObject;
							if(cs != null){
								cs.width = width;
								cs.height = height;
							}
						}
					}
					else{
						mc.width = width;
						mc.height = height;
					}
				}
			}
		}
	}
}