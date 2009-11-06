package com.snsoft.util
{
	import flash.display.Sprite;
	
	public class RelativeObject
	{
		
		private var sprite:Sprite;
		
		private var relativeXType:String;
		
		private var relativeYType:String;
		
		private var leftSpase:Number = 0;
		
		private var rightSpase:Number = 0;
		
		private var topSpase:Number = 0;
		
		private var bottomSpase:Number = 0;
		
		private var spriteBaseWidth:Number = 0;
		
		private var spriteBaseHeight:Number = 0;
		
		private var childSpriteIsRelative:Boolean = false;
		
		public function RelativeObject()
		{
			
		}
		
		public function getSprite():Sprite{
			
			return this.sprite;
		}
		
		public function setSprite(sprite:Sprite):void{
			
			this.sprite =sprite;
		}
		
		public function getRelativeXType():String{
			
			return this.relativeXType;
		}
		
		public function setRelativeXType(relativeXType:String):void{
			
			this.relativeXType = relativeXType;
		}
		
		public function getRelativeYType():String{
			
			return this.relativeYType;
		}
		
		public function setRelativeYType(relativeYType:String):void{
			
			this.relativeYType = relativeYType;
		}
		
		public function getLeftSpase():Number{
			
			return this.leftSpase;
		}
		
		public function setLeftSpase(leftSpase:Number):void{
			
			this.leftSpase = leftSpase;
		}
		
		public function getRightSpase():Number{
			
			return this.rightSpase;
		}
		
		public function setRightSpase(rightSpase:Number):void{
			
			this.rightSpase = rightSpase;
		}
		
		public function getTopSpase():Number{
			
			return this.topSpase;
		}
		
		public function setTopSpase(topSpase:Number):void{
			
			this.topSpase = topSpase;
		}
		
		public function getBottomSpase():Number{
			
			return this.bottomSpase;
		}
		
		public function setBottomSpase(bottomSpase:Number):void{
			
			this.bottomSpase = bottomSpase;
		}
		
		public function getSpriteBaseWidth():Number{
			
			return this.spriteBaseWidth;
		}
		
		public function setSpriteBaseWidth(spriteBaseWidth:Number):void{
			
			this.spriteBaseWidth = spriteBaseWidth;
		}
		
		public function getSpriteBaseHeight():Number{
			
			return this.spriteBaseHeight;
		}
		
		public function setSpriteBaseHeight(spriteBaseHeight:Number):void{
			
			this.spriteBaseHeight = spriteBaseHeight;
		}
		
		public function getChildSpriteIsRelative():Boolean{
			
			return this.childSpriteIsRelative;
		}
		
		public function setChildSpriteIsRelative(childSpriteIsRelative:Boolean):void{
			
			this.childSpriteIsRelative = childSpriteIsRelative;
		}
	}
}