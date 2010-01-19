package tvc
{
	
	/**
	 * class: PointCoordinate
	 * 
	 * 描述：坐标系中点的坐标
	 * 
	 */
	public class PointCoordinate
	{
		private var x:Number = 0;
		private var y:Number = 0;
		
		
		public function PointCoordinate(x:Number, y:Number):void{
			this.x = x;
			this.y = y;
		}
		/**
		 * x  set器:
		 */
		public function setX(x:Number):void{
			this.x = x;
		}
		
		
		/**
		 * y set器：
		 */
		public function setY(y:Number):void{
			this.y= y;
		}

		
		/**
		 * x get器：
		 */
		public function getX():Number{
			return this.x;
		}
		
		
		/**
		 * y get器：
		 */
		public function getY():Number{
			return this.y;
		}
		 
	}
}