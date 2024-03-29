package com.snsoft.tvc2.bizSounds{
	import com.snsoft.tvc2.dataObject.TextPointDO;

	/**
	 * 价格分布语音合成数据对象
	 * @author Administrator
	 * 
	 */	
	public class DistributeSoundsDO{
		
		public static const DATE_TYPE_DAY:String = "day";
		
		public static const DATE_TYPE_WEEK:String = "week";
		
		public static const DATE_TYPE_MONTH:String = "month";
		
		private var _dateType:String = "week";//本周 /今天/本月 
		
		private var _goodsCode:String = null;//产品编号
		
		private var _goodsText:String = null;//产品名称
		
		private var _lowDisV:Vector.<TextPointDO>;//低价格分布点
		
		private var _highDisV:Vector.<TextPointDO>;//高价格分布点
		
		private var _lowDesV:Vector.<TextPointDO>;//低价格分布介绍
		
		private var _highDesV:Vector.<TextPointDO>;//高价格分布介绍
		
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

		public function get dateType():String
		{
			return _dateType;
		}

		public function set dateType(value:String):void
		{
			_dateType = value;
		}

		public function get goodsText():String
		{
			return _goodsText;
		}

		public function set goodsText(value:String):void
		{
			_goodsText = value;
		}

		public function get lowDesV():Vector.<TextPointDO>
		{
			return _lowDesV;
		}

		public function set lowDesV(value:Vector.<TextPointDO>):void
		{
			_lowDesV = value;
		}

		public function get highDesV():Vector.<TextPointDO>
		{
			return _highDesV;
		}

		public function set highDesV(value:Vector.<TextPointDO>):void
		{
			_highDesV = value;
		}


	}
}