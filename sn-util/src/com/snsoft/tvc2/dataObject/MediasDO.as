package com.snsoft.tvc2.dataObject{
	import com.snsoft.util.HashVector;

	/**
	 * 多媒体（图片、动画）数据对象组对象
	 * @author Administrator
	 * 
	 */	
	public class MediasDO{
		
		//多媒体（图片、动画）数据对象列表
		private var _mediaDOHv:Vector.<MediaDO>;
		
		public function MediasDO()
		{
		}

		public function get mediaDOHv():Vector.<MediaDO>
		{
			return _mediaDOHv;
		}

		public function set mediaDOHv(value:Vector.<MediaDO>):void
		{
			_mediaDOHv = value;
		}

	}
}