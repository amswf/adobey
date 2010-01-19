package tvc.parseXML
{
	public class MapArea
	{
		private var areaName:String = "*";
		private var AreaValue:Number = 0;
		private var coorX:Number = 0;
		private var coorY:Number = 0;
		
		/**
		 * 
		 */
		public function setCoorY(cy:Number):void{
			this.coorY = cy;
		}
		
		
		/**
		 * 
		 */
		public function getCoorY():Number{
			return this.coorY;
		}
		
		
		/**
		 * 
		 */
		public function setCoorX(cx:Number):void{
			this.coorX = cx;
		}
		
		
		/**
		 * 
		 */
		public function getCoorX():Number{
			return this.coorX;
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
		
		/**
		 * 
		 */
		public function setAreaValue(value:Number):void{
			this.AreaValue = value;
		}
		
		
		/**
		 * 
		 */
		public function getAreaValue():Number{
			return this.AreaValue;
		}
	}
}