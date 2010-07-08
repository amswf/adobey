package com.snsoft.tvc2.bizSounds{
	public class DistributeAreaSoundsDO{
		
		public static const DATE_TYPE_DAY:String = "day";
		
		public static const DATE_TYPE_WEEK:String = "week";
		
		public static const DATE_TYPE_MONTH:String = "month";
		
		private var _dateType:String = "周";//本周 /今天/本月
		
		private var _goodsCode:String = null;//产品编号
		
		public function DistributeAreaSoundsDO()
		{
		}

		public function get dateType():String
		{
			return _dateType;
		}

		public function set dateType(value:String):void
		{
			_dateType = value;
		}

		public function get goodsCode():String
		{
			return _goodsCode;
		}

		public function set goodsCode(value:String):void
		{
			_goodsCode = value;
		}


	}
}