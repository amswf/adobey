package  tvc.parseXML
{
	public class LineArea
	{
		private var areaName:String = "*";
		private var prices:Array = new Array();
		private var forecasts:Array = new Array();
		
		
		/**
		 * 
		 */
		public function setForecasts(fore:Array):void{
			this.forecasts = fore;
		}
		
		
		/**
		 * 
		 */
		public function getForecasts():Array{
			return this.forecasts;
		}
		
		/**
		 * 
		 */
		public function setPrices(prices:Array):void{
			this.prices = prices;
		}
		
		
		/**
		 * 
		 */
		public function getPrices():Array{
			return this.prices;
		}
		
		
		/**
		 * 
		 */
		public function setAreaName(name:String):void{
			this.areaName = name;
		}
		
		
		/**
		 * 
		 */
		public function getAreaName():String{
			return this.areaName;
		}
		
		
	}
}