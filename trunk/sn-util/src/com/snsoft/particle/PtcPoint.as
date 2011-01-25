package com.snsoft.particle{
	/**
	 * 粒子点信息
	 * @author Administrator
	 * 
	 */	
	public class PtcPoint{
		public function PtcPoint(x:Number = 0,y:Number = 0,u:Boolean = false){
			this.u = u;
			this.x = x;
			this.y = y;
		}
		
		private var _x:Number;
		
		private var _y:Number;
		
		private var _u:Boolean;

		/**
		 * x坐标 
		 */
		public function get x():Number
		{
			return _x;
		}

		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			_x = value;
		}

		/**
		 * y坐标 
		 */
		public function get y():Number
		{
			return _y;
		}

		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			_y = value;
		}

		/**
		 * 是否有效 
		 */
		public function get u():Boolean
		{
			return _u;
		}

		/**
		 * @private
		 */
		public function set u(value:Boolean):void
		{
			_u = value;
		}


	}
}