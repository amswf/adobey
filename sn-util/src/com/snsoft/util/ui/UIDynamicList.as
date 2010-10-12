package com.snsoft.util.ui{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	[Style(name="backSkin", type="Class")]
	
	/**
	 * 动态列表展现 
	 * @author Administrator
	 * 
	 */	
	public class UIDynamicList extends UIComponent{
		public function UIDynamicList(){
		}
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {backSkin:"Map_backskin"};
		
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
			
			super.configUI();
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			
		}
	}
}