package com.snsoft.room3d{
	
	/**
	 * 壁画按钮数据对象 
	 * @author Administrator
	 * 
	 */	
	public class MuralDO{
		
		private var _x:Number;
		
		private var _y:Number;
		
		private var _type:Number;
		
		private var _text:String;
		
		private var _url:String;
		
		public function MuralDO()
		{
		}
		
		
		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get type():Number
		{
			return _type;
		}

		public function set type(value:Number):void
		{
			_type = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}


	}
}