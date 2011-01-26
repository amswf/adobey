package com.snsoft.peopleRes8{
	
	/**
	 * 八方向编码 
	 * @author Administrator
	 * 
	 */	
	public class Direction8{
		
		private static const TOP:int = 2;
		
		private static const TOP_RIGHT:int = 3;
		
		private static const RIGHT:int = 4;
		
		private static const BOTTOM_RIGHT:int = 5;
		
		private static const BOTTOM:int = 6;
		
		private static const BOTTOM_LEFT:int = 7;
		
		private static const LEFT:int = 0;
		
		private static const TOP_LEFT:int = 1;
		
		public function Direction8()
		{
		}
		
		public static function tranDirection(direction:int):int{
			var code:int = -1;
			switch (direction) {
				case LEFT:
					code = 1;
					break;
				case TOP_LEFT:
					code = 6;
					break;
				case TOP:
					code = 3;
					break;
				case TOP_RIGHT:
					code = 7;
					break;
				case RIGHT:
					code = 2;
					break;
				case BOTTOM_RIGHT:
					code = 5;
					break;
				case BOTTOM:
					code = 0;
					break;
				case BOTTOM_LEFT:
					code = 4;
					break;
				default:
					code = -1;
			}
			return code;
		}
	}
}