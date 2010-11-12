package com.snsoft.sndoor{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ADSlideBtn extends UIComponent{
		
		
		 
		
		private var _index:int;
		
		private var btnAlpha:MovieClip;
		
		private var _isSlideVisible:Boolean = false;
		
		private var imageBitMap:Bitmap;
		
		public function ADSlideBtn(imageBitmapData:BitmapData,index:int,width:Number,height:Number){
			super();
			
			this.imageBitMap = new Bitmap(imageBitmapData,"auto",true);
			this._index = index;
			this.width = width;
			this.height = height;
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			slideBtnAlphaSkin:"SlideBtnAlpha_skin"
		};
		
		private static const slideBtnAlphaSkin:String = "slideBtnAlphaSkin";
		
		
		/**
		 * 
		 * 绘制组件显示
		 */		
		override protected function draw():void{
			trace("draw");
			imageBitMap.width = this.width;
			imageBitMap.height = this.height;
			this.addChild(imageBitMap);
			
			btnAlpha = getDisplayObjectInstance(getStyleValue(slideBtnAlphaSkin)) as MovieClip;
			btnAlpha.width = this.width;
			btnAlpha.height = this.height;
			this.addChild(btnAlpha);
			btnAlpha.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			btnAlpha.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
			btnAlpha.buttonMode = true;
		}
		
		private function handlerMouseOver(e:Event):void{
			setBalphaByMouseEvent(0);
		}
		
		private function handlerMouseOut(e:Event):void{
			setBalphaByMouseEvent(1);
		}
		
		private function setBalphaByMouseEvent(alpha:Number):void{
			if(!isSlideVisible){
				setBalpha(alpha);
			}
		}	
		
		private function setBalpha(alpha:Number):void{
			btnAlpha.alpha = alpha;
		}
		
		public function setBtnSlideVisible(visble:Boolean):void{
			this.isSlideVisible = visble;
			if(visble){
				setBalpha(0)
			}
			else {
				setBalpha(1)
			}
		}
		
		
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

		public function get isSlideVisible():Boolean
		{
			return _isSlideVisible;
		}

		public function set isSlideVisible(value:Boolean):void
		{
			_isSlideVisible = value;
		}

		public function get index():int
		{
			return _index;
		}
		
		
		
		
	}
}