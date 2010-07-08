package com.snsoft.tvc2.bizSounds{
	public class DistributeAreaSoundsDO{
		
		public static const DATE_TYPE_DAY:String = "day";
		
		public static const DATE_TYPE_WEEK:String = "week";
		
		public static const DATE_TYPE_MONTH:String = "month";
		
		private var _dateType:String = "week";//本周 /今天/本月
		
		private var _goodsCode:String = null;//产品编号
		
		private var _goodsText:String = null;//产品名称
		
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

		public function get goodsText():String
		{
			return _goodsText;
		}

		public function set goodsText(value:String):void
		{
			_goodsText = value;
		}


	}
}