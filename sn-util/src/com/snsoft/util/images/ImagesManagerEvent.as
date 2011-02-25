package com.snsoft.util.images{
	import flash.events.Event;
	
	public class ImagesManagerEvent extends Event{
		
		/**
		 * 加载完成某一个图片时触发 
		 */		
		public static const PROGRESS:String = "progress";
		
		private var _progressValue:Number = 0;
		
		public function ImagesManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,progressValue:Number = 0)
		{
			super(type, bubbles, cancelable);
			this._progressValue = progressValue;
		}

		public function get progressValue():Number
		{
			return _progressValue;
		}
	}
}