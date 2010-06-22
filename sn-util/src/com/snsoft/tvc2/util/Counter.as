package com.snsoft.tvc2.util{
	public class Counter{
		
		private var _count:int = 0;
		
		public function Counter()
		{
		}
		
		public function plus():void{
			count ++;
		}
		
		public function sub():void{
			count --;
		}

		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
		}

	}
}