package tvc.parseXML
{
	public class PriceLine
	{
		
		private var areas:Array = new Array();//LineArea对象列表
		
		
		
		
		/**
		 * 
		 */
		public function setAreas(areas:Array):void{
			this.areas = areas;
		}
		
		
		/**
		 * 
		 */
		public function getAreas():Array{
			return this.areas;
		}
		
		
	}
}