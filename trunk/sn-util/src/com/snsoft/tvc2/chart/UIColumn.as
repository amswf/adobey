package com.snsoft.tvc2.chart{
	import com.snsoft.util.SpriteUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	[Style(name="columnDownSkin", type="Class")]
	
	[Style(name="columnRightSkin", type="Class")]
	
	[Style(name="columnUpSkin", type="Class")]
	
	[Style(name="columnLeftSkin", type="Class")]
	
	/**
	 * 柱体 
	 * @author Administrator
	 * 
	 */	
	public class UIColumn extends UIComponent{
		
		//[Style(name="columnUpSkin", type="Class")]
		private static const COLUMN_DOWN_SKIN:String = "columnDownSkin";
		
		private static const COLUMN_RIGHT_SKIN:String = "columnRightSkin";
		
		private static const COLUMN_UP_SKIN:String = "columnUpSkin";
		
		private static const COLUMN_LEFT_SKIN:String = "columnLeftSkin";
		
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			columnDownSkin:"Column_down_skin",
			columnRightSkin:"Column_right_skin",
			columnUpSkin:"Column_up_skin",
			columnLeftSkin:"Column_left_skin"
		};
		
		private static const DIRECTION_DOWN:int = 0;
		
		private static const DIRECTION_RIGHT:int = 1;
		
		private static const DIRECTION_UP:int = 2;
		
		private static const DIRECTION_LEFT:int = 3;
		
		private var column:Sprite;
		
		private var _direction:int = 0;
		
		
		public function UIColumn(direction:int = 0){
			this.direction = direction;
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
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			com.snsoft.util.SpriteUtil.deleteAllChild(this);
			var columnSkin:String = COLUMN_DOWN_SKIN;
			if(this.direction == 0){
				columnSkin = COLUMN_DOWN_SKIN;
			}
			else if(this.direction == 1){
				columnSkin = COLUMN_RIGHT_SKIN;
			}
			else if(this.direction == 2){
				columnSkin = COLUMN_UP_SKIN;
			}
			else if(this.direction == 3){
				columnSkin = COLUMN_LEFT_SKIN;
			}
			column = getDisplayObjectInstance(getStyleValue(columnSkin)) as MovieClip;
			column.width = this.width;
			column.height = this.height;
			this.addChild(column);
		}

		public function get direction():int
		{
			return _direction;
		}

		public function set direction(value:int):void
		{
			_direction = value;
		}

	}
}