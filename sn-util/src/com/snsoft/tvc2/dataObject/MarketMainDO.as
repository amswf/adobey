package com.snsoft.tvc2.dataObject{
	import ascb.util.StringUtilities;
	
	import com.snsoft.util.HashVector;
	
	public class MarketMainDO{
		
		private var _marketCoordsDOHV:HashVector;
		
		
		public function putMarketCoordsDO(marketCoordsDO:MarketCoordsDO):void{
			if(marketCoordsDO != null){
				var name:String = marketCoordsDO.name;
				if( name != null && StringUtilities.trim(name).length > 0){
					marketCoordsDOHV.put(name,marketCoordsDO);
				}
			}
		}
		
		public function findMarketCoordsDO(marketCoordsName:String):MarketCoordsDO{
			return marketCoordsDOHV.findByName(marketCoordsName) as MarketCoordsDO;
		}

		public function get marketCoordsDOHV():HashVector
		{
			return _marketCoordsDOHV;
		}

		public function set marketCoordsDOHV(value:HashVector):void
		{
			_marketCoordsDOHV = value;
		}

		
		public function MarketMainDO()
		{
			marketCoordsDOHV = new HashVector();
		}
	}
}