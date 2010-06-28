package com.snsoft.tvc2.util{
	public class Counter{
		
		private var _count:int = 0;
		
		public function Counter()
		{
		}
		
		public function plus(i:int = 1):void{
			count += i;
			trace("Counter.plus",count);
		}
		
		public function sub():void{
			count --;
			trace("Counter.sub",count);
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