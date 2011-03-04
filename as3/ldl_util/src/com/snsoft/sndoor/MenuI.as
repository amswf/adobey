package com.snsoft.sndoor{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	
	public class MenuI extends UIComponent{
		
		/**
		 * 样式 
		 */		
		private static const menuIBackDefaultSkin:String = "menuIBackDefaultSkin";
		
		private static const menuISeparatorDefaultSkin:String = "menuISeparatorDefaultSkin";
		
		/**
		 * 背景 
		 */		
		private var menuIBack:MovieClip;
		
		/**
		 * 间隔 
		 */		
		private var menuISeparator:MovieClip;
		
		public function MenuI()
		{
			super();
		}
		
		/**
		 * 
		 */			
		private static var defaultStyles:Object = {
			menuIBackDefaultSkin:"MenuIBack_defaultSkin",
			menuISeparatorDefaultSkin:"MenuISeparator_defaultSkin"
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