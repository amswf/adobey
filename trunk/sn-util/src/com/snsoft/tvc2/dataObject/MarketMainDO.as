package com.snsoft.tvc2.dataObject{
	import ascb.util.StringUtilities;
	
	import com.snsoft.util.HashVector;
	
	/**
	 * 市场主数据对象 
	 * @author Administrator
	 * 
	 */	
	public class MarketMainDO{
		
		//市场组列表
		private var _marketCoordsDOHV:HashVector;
		
		
		public function putMarketCoordsDO(marketCoordsDO:MarketCoordsDO):void{
			if(marketCoordsDO != null){
				var name:String = marketCoordsDO.name;
				if( name != null && StringUtilities.trim(name).length > 0){
					marketCoordsDOHV.push(marketCoordsDO,name);
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