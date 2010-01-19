package tvc.parseXML
{
	public class PriceMap
	{
		private var subsections:Array = new Array();
		private var areas:Array = new Array();
		
		
		/**
		 * 
		 */
		public function setSubsections(subsections:Array):void{
			this.subsections = subsections;
		}
		
		
		/**
		 * 
		 */
		public function getSubsections():Array{
			return this.subsections;
		}
		
		
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