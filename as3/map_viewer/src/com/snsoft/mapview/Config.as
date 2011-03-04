package com.snsoft.mapview{
	public class Config{
		public function Config()
		{
		}
		
		public static const AREA_MOUSE_EVENT_TYPE_LINK:String = "link";
		
		
		public static const AREA_MOUSE_EVENT_TYPE_DOUBLE_CLICK:String = "doubleClick";
		/**
		 * 地图块点击类型  打开链接:LINK / 双击:DOUBLE_CLICK 
		 */		
		private static var _areaMouseEventType:String;
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function get areaMouseEventType():String
		{
			return _areaMouseEventType;
		}

		/**
		 * 
		 * @param value
		 * 
		 */		
		public static function setAreaMouseEventType(value:String):void
		{
			_areaMouseEventType = value;
		}

	}
}