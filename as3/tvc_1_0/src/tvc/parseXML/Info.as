package tvc.parseXML
{
	public class Info
	{
		private var time:String = "*";
		private var company:String = "*";
		private var cropName:String = "*";
		private var priceline:PriceLine = new PriceLine();
		private var pricepole:PricePole = new PricePole();
		private var pricemap:PriceMap = new PriceMap();
		
		
		/**
		 * 
		 */
		public function getPriceMap():PriceMap{
			return this.pricemap;
		}
		
		/**
		 * 
		 */
		public function setPriceMap(pricemap:PriceMap):void{
			this.pricemap = pricemap;
		}
		
		
		/**
		 * 
		 */
		public function getPricepole():PricePole{
			return this.pricepole;
		}
		
		/**
		 * 
		 */
		public function setPricepole(pricepole:PricePole):void{
			this.pricepole = pricepole;
		}
		
		
		/**
		 * 
		 */
		public function getPriceline():PriceLine{
			return this.priceline;
		}
		
		/**
		 * 
		 */
		public function setPriceline(priceline:PriceLine):void{
			this.priceline = priceline;
		}
		
		
		
		/**
		 * 
		 */
		public function getCompany():String{
			return this.company;
		}
		
		/**
		 * 
		 */
		public function setCompany(company:String):void{
			this.company = company;
		}
		
		
		/**
		 * 
		 */
		public function getTime():String{
			return this.time;
		}
		
		/**
		 * 
		 */
		public function setTime(time:String):void{
			this.time = time;
		}
		
		/**
		 * 
		 */
		public function setCropName(cropName:String):void{
			this.cropName = cropName;
		}
		
		
		/**
		 * 
		 */
		public function getCropName():String{
			return this.cropName;
		}
	}
}