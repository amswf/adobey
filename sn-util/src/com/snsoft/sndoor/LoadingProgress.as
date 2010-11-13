package com.snsoft.sndoor{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class LoadingProgress extends UIComponent{
		
		
		private var loadingBack:MovieClip;
		
		private var loadingBar:MovieClip;
		
		private var loadingText:TextField;
		
		private var loadingTextFormat:TextFormat;
		
		public function LoadingProgress(width:Number,height:Number){
			super();
			this.width = width;
			this.height = height;
			
			loadingTextFormat = new TextFormat();
			loadingTextFormat.font ="宋体";
			loadingTextFormat.align = TextFormatAlign.RIGHT;
			loadingTextFormat.size = 12;
			loadingTextFormat.color = 0x4F921F;
			loadingTextFormat.leading = 4;
			
			loadingText = new TextField();
			loadingText.mouseEnabled = false;
			loadingText.width = 40;
			loadingText.height = 18;
			loadingText.x = this.width - loadingText.width;
			loadingText.y = 0;
			loadingText.htmlText = "<b>0%</b>";
		
			loadingBack = getDisplayObjectInstance(getStyleValue(loadingProgressBackDefaultSkin)) as MovieClip;
			loadingBack.width = this.width - loadingText.width;
			loadingBar = getDisplayObjectInstance(getStyleValue(loadingProgressBarDefaultSkin)) as MovieClip;
			loadingBar.width = 20;
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			loadingProgressBackDefaultSkin:"LoadingProgressBack_defaultSkin",
			loadingProgressBarDefaultSkin:"LoadingProgressBar_defaultSkin"
		};
		
		private static const loadingProgressBackDefaultSkin:String = "loadingProgressBackDefaultSkin";
		
		private static const loadingProgressBarDefaultSkin:String = "loadingProgressBarDefaultSkin";
		
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
		 * 绘制组件显示
		 */		
		override protected function draw():void{
			this.addChild(loadingBack);
			this.addChild(loadingBar);
			this.addChild(loadingText);
			loadingText.setTextFormat(loadingTextFormat);
		}
		
		public function setProgressValue(num:Number):void{
			var v:int = int(num * 100);
			loadingText.htmlText = "<b>"+v+"%</b>";
			loadingText.setTextFormat(loadingTextFormat);
			var len:Number = this.width * num;
			if(len > loadingBar.width){
				loadingBar.width = len;
			}
		}
	}
}