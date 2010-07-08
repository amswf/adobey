package com.snsoft.tvc2.bizSounds{
	import com.snsoft.tvc2.dataObject.TextPointDO;

	public class DistributeSoundsDO{
		
		 
		
		private var _goodsCode:String = null;//产品编号
		
		private var _lowDisV:Vector.<TextPointDO>;//低价格分布点
		
		private var _highDisV:Vector.<TextPointDO>;//高价格分布点
		
		public function DistributeSoundsDO(){
		}
		
		public function get goodsCode():String
		{
			return _goodsCode;
		}

		public function set goodsCode(value:String):void
		{
			_goodsCode = value;
		}

		public function get lowDisV():Vector.<TextPointDO>
		{
			return _lowDisV;
		}

		public function set lowDisV(value:Vector.<TextPointDO>):void
		{
			_lowDisV = value;
		}

		public function get highDisV():Vector.<TextPointDO>
		{
			return _highDisV;
		}

		public function set highDisV(value:Vector.<TextPointDO>):void
		{
			_highDisV = value;
		}


	}
}