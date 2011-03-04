package test{
	public class User{
		
		private var _name:String;
		
		private var _num:Number;
		
		private var _i:int;
		
		public function User()
		{
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get num():Number
		{
			return _num;
		}

		public function set num(value:Number):void
		{
			_num = value;
		}

		public function get i():int
		{
			return _i;
		}

		public function set i(value:int):void
		{
			_i = value;
		}


	}
}