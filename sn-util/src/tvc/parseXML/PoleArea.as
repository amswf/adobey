package tvc.parseXML
{
	public class PoleArea
	{
		private var areaName:String = "*";
		private var prices:Array = new Array();
		private var oldprices:Array = new Array();
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
		public function setOldprices(oldprices:Array):void{
			this.oldprices = oldprices;
		}
		
		
		/**
		 * 
		 */
		public function getOldprices():Array{
			return this.oldprices;
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