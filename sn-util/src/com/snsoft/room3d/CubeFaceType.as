package com.snsoft.room3d{
	
	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class CubeFaceType{
		
		public function CubeFaceType()
		{
		}
		
		/**
		 * 类型转换 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function transTypeToInt(type:String):int{
			var typeInt:int = 0;
			if(type == SeatDO.RIGHT){
				typeInt = 1;
			}
			else if(type == SeatDO.BACK){
				typeInt = 2;
			}
			else if(type == SeatDO.LEFT){
				typeInt = 3;
			}
			else if(type == SeatDO.TOP){
				typeInt = 4;
			}
			else if(type == SeatDO.BOTTOM){
				typeInt = 5;
			}
			else{
				typeInt = 0;
			}
			return typeInt;
		}
		
		/**
		 * 类型转换 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function transTypeToStr(type:int):String{
			var typeStr:String;
			if(type == 1){
				typeStr = SeatDO.RIGHT;
			}
			else if(type == 2){
				typeStr = SeatDO.BACK;
			}
			else if(type == 3){
				typeStr = SeatDO.LEFT;
			}
			else if(type == 4){
				typeStr = SeatDO.TOP;
			}
			else if(type == 5){
				typeStr = SeatDO.BOTTOM;
			}
			else{
				typeStr = SeatDO.FRONT;
			}
			return typeStr;
		}
	}
}