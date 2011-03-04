package com.snsoft.sndoor{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	public class MenuII extends UIComponent{
		public function MenuII()
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
			
		}
		
	}
}