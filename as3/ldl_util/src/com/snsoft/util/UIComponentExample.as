package com.snsoft.util{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	
	/**
	 * 组件基本范例 
	 * @author Administrator
	 * 
	 */	
	public class UIComponentExample extends UIComponent{
		public function UIComponentExample()
		{
			super();
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			testSkin:"Test_Skin"
			
		};
		
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
			getDisplayObjectInstance(getStyleValue("testSkin")) as MovieClip;
		}
	}
}