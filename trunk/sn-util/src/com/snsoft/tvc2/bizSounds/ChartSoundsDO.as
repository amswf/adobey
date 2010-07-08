package com.snsoft.tvc2.bizSounds{
	public class ChartSoundsDO{
		
		public static const DATE_TYPE_DAY:String = "day";
		
		public static const DATE_TYPE_WEEK:String = "week";
		
		public static const DATE_TYPE_MONTH:String = "month";
		
		private var _dateType:String = "week";//本周 /今天/本月
		
		private var _areaCode:String = null;//地区编号
		
		private var _areaText:String = null;//地区名称
		
		private var _goodsCode:String = null;//产品编号
		
		private var _goodsText:String = null;//产品名称
		
		private var _priceTrend:int = 0; //价格走势  1 上升  0 持平  -1 下降
		
		private var _highPrice:Number=0.00; //实况最高价格
		
		private var _lowPrice:Number=0.00;//实况最低价格
		
		private var _forecastTrend:int = 0;//预测走势  1 上升  0 持平  -1 下降
		
		private var _forecastPrice:int = NaN;//预测价格
		
		private var _historyContrastPrice:Number = NaN;//历史相差价格
		
		private var _forecastContrastPrice:Number = NaN;//预测相差价格
		
		private var _priceExponentialTrend:int = 0;
		
		private var _forecastPriceExponentialTrend:int = NaN;
		
		public function ChartSoundsDO()
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

		public function get areaCode():String
		{
			return _areaCode;
		}

		public function set areaCode(value:String):void
		{
			_areaCode = value;
		}

		public function get goodsCode():String
		{
			return _goodsCode;
		}

		public function set goodsCode(value:String):void
		{
			_goodsCode = value;
		}

		public function get priceTrend():int
		{
			return _priceTrend;
		}

		public function set priceTrend(value:int):void
		{
			_priceTrend = value;
		}

		public function get highPrice():Number
		{
			return _highPrice;
		}

		public function set highPrice(value:Number):void
		{
			_highPrice = value;
		}

		public function get lowPrice():Number
		{
			return _lowPrice;
		}

		public function set lowPrice(value:Number):void
		{
			_lowPrice = value;
		}

		public function get forecastTrend():int
		{
			return _forecastTrend;
		}

		public function set forecastTrend(value:int):void
		{
			_forecastTrend = value;
		}

		public function get forecastPrice():int
		{
			return _forecastPrice;
		}

		public function set forecastPrice(value:int):void
		{
			_forecastPrice = value;
		}

		public function get historyContrastPrice():Number
		{
			return _historyContrastPrice;
		}

		public function set historyContrastPrice(value:Number):void
		{
			_historyContrastPrice = value;
		}

		public function get forecastContrastPrice():Number
		{
			return _forecastContrastPrice;
		}

		public function set forecastContrastPrice(value:Number):void
		{
			_forecastContrastPrice = value;
		}

		public function get priceExponentialTrend():int
		{
			return _priceExponentialTrend;
		}

		public function set priceExponentialTrend(value:int):void
		{
			_priceExponentialTrend = value;
		}

		public function get forecastPriceExponentialTrend():int
		{
			return _forecastPriceExponentialTrend;
		}

		public function set forecastPriceExponentialTrend(value:int):void
		{
			_forecastPriceExponentialTrend = value;
		}

		public function get areaText():String
		{
			return _areaText;
		}

		public function set areaText(value:String):void
		{
			_areaText = value;
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