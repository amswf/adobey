package com.snsoft.physics{
	
	/**
	 * 加速度 
	 * @author Administrator
	 * 
	 */	
	public class Acceleration{
		
		/**
		 * 摩擦力或阻力加速度
		 */		
		public static const TYPE_FRICTION:int = 1;
		
		/**
		 * 引力加速度 
		 */		
		public static const TYPE_GRAVITATION:int = 0;
		
		private var _ax:Number;
		
		private var _ay:Number;
		
		private var _a:Number;
		
		private var _type:int = 0;
		
		public function Acceleration(a:Number = 0,ax:Number = 0,ay:Number = 0,type:Number = 0){
			this._a = a;
			this._ax = ax;
			this._ay = ay;
			this._type = type;
		}

		public function get ax():Number
		{
			return _ax;
		}

		public function set ax(value:Number):void
		{
			_ax = value;
			//_a = NaN;
		}

		public function get ay():Number
		{
			return _ay;
		}

		public function set ay(value:Number):void
		{
			_ay = value;
			//_a = NaN;
		}

		public function get a():Number
		{
			return _a;
		}

		public function set a(value:Number):void
		{
			_a = value;
			//_ax = NaN;
			//_ay = NaN;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}


	}
}