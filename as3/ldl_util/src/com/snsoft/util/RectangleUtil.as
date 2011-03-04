package com.snsoft.util{
	import flash.display.DisplayObject;
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
		
		/**
		 * sprite x/y/width/height 加法 
		 * @param rect1
		 * @param rect2
		 * @return 
		 * 
		 */		
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
		
		/**
		 * sprite x/y/width/height 减法 
		 * @param rect1
		 * @param rect2
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 设置显示对象的  x/y/width/height
		 * @param dobj
		 * @param rect
		 * 
		 */		
		public static function setRect(dobj:DisplayObject,rect:Rectangle):void{
			dobj.x = rect.x;
			dobj.y = rect.y;
			dobj.width = rect.width;
			dobj.height = rect.height;
		}
		
		/**
		 * 复制  Rectangle
		 * @param rect
		 * @return 
		 * 
		 */		
		public static function cloneRect(rect:Rectangle):Rectangle{
			return new Rectangle(rect.x,rect.y,rect.width,rect.height);
		}
	}
}