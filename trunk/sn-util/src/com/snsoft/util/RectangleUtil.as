package com.snsoft.util{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class RectangleUtil{
		public function RectangleUtil()
		{
		}
		
		/**
		 * 坐标 Point 
		 * @param rect Rectangle
		 * @return Point
		 * 
		 */		
		public static function getPlace(rect:Rectangle):Point{
			return new Point(rect.x,rect.y);
		}
		
		/**
		 * 宽高 Point 
		 * @param rect Rectangle
		 * @return Point
		 * 
		 */		
		public static function getSize(rect:Rectangle):Point{
			return new Point(rect.width,rect.height);
		}
		
		public static function subRect(rect1:Rectangle,rect2:Rectangle):Rectangle{
			var r:Rectangle = new Rectangle();
			var r1:Rectangle = new Rectangle();
			var r2:Rectangle = new Rectangle();
			if(r1 != null){
				r1 = rect1.clone();
			}
			if(r2 != null){
				r2 = rect2.clone();	
			}
			r.x = r1.x - r2.x;
			r.y = r1.y - r2.y;
			r.width = r1.width - r2.width;
			r.height = r1.height - r2.height;
			return r;
		}
		
		public static function plusRect(rect1:Rectangle,rect2:Rectangle):Rectangle{
			var r:Rectangle = new Rectangle();
			var r1:Rectangle = new Rectangle();
			var r2:Rectangle = new Rectangle();
			if(r1 != null){
				r1 = rect1.clone();
			}
			if(r2 != null){
				r2 = rect2.clone();	
			}
			r.x = r1.x + r2.x;
			r.y = r1.y + r2.y;
			r.width = r1.width + r2.width;
			r.height = r1.height + r2.height;
			return r;
		}
	}
}