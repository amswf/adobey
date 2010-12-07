package com.snsoft.sndoor{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class LoadingProgress extends UIComponent{
				
		private var loadingBar:MovieClip;
		
		private var loadingText:TextField;
		
		private var loadingTextFormat:TextFormat;
		
		public function LoadingProgress(width:Number,height:Number){
			super();
			this.width = width;
			this.height = height;
			
			loadingTextFormat = new TextFormat();
			loadingTextFormat.font ="宋体";
			loadingTextFormat.align = TextFormatAlign.CENTER;
			loadingTextFormat.size = 12;
			loadingTextFormat.color = 0x4F921F;
			loadingTextFormat.leading = 4;
			
			loadingText = new TextField();
			loadingText.mouseEnabled = false;
			loadingText.width = this.width;
			loadingText.height = 18;
			loadingText.x = - this.width / 2;
			loadingText.y = this.height;
			loadingText.htmlText = "<b>0%</b>";

			loadingBar = getDisplayObjectInstance(getStyleValue(loadingProgressBarCircleSkin)) as MovieClip;
			loadingBar.width = this.width;
			loadingBar.height = this.height;
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			loadingProgressBackDefaultSkin:"LoadingProgressBack_defaultSkin",
			loadingProgressBarDefaultSkin:"LoadingProgressBar_defaultSkin",
			loadingProgressBarCircleSkin:"LoadingProgressBar_circleSkin"
		};
		
		private static const loadingProgressBackDefaultSkin:String = "loadingProgressBackDefaultSkin";
		
		private static const loadingProgressBarDefaultSkin:String = "loadingProgressBarDefaultSkin";
		
		private static const loadingProgressBarCircleSkin:String = "loadingProgressBarCircleSkin";
		
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
			this.addChild(loadingBar);
			this.addChild(loadingText);
			loadingText.setTextFormat(loadingTextFormat);
		}
		
		public function setProgressValue(num:Number):void{
			var v:int = int(num * 100);
			loadingText.htmlText = "<b>"+v+"%</b>";
			loadingText.setTextFormat(loadingTextFormat);
		}
	}
}