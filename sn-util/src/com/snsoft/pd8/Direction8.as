package com.snsoft.pd8{
	
	/**
	 * 八方向编码 
	 * @author Administrator
	 * 
	 */	
	public class Direction8{
		
		/**
		 * 向上走 
		 */		
		public static const TOP:int = 2;
		
		/**
		 * 右上走 
		 */		
		public static const TOP_RIGHT:int = 3;
		
		/**
		 * 向右走 
		 */		
		public static const RIGHT:int = 4;
		
		/**
		 * 右下走 
		 */		
		public static const BOTTOM_RIGHT:int = 5;
		
		/**
		 * 向下走 
		 */		
		public static const BOTTOM:int = 6;
		
		/**
		 * 左下走 
		 */		
		public static const BOTTOM_LEFT:int = 7;
		
		/**
		 *向左走 
		 */		
		public static const LEFT:int = 0;
		
		/**
		 * 左上走 
		 */		
		public static const TOP_LEFT:int = 1;
		
		public function Direction8()
		{
		}
		
		/**
		 * 把图片中的方向映射到代码中的方向，从左顺时针转一圈为0 ~ 7的编号
		 * @param direction
		 * @return 
		 * 
		 */		
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