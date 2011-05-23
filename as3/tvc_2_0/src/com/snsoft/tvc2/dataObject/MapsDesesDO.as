package com.snsoft.tvc2.dataObject {
	import com.snsoft.util.HashVector;

	public class MapsDesesDO {

		private var mapDesDOHV:HashVector = new HashVector();

		public function MapsDesesDO() {
		}

		public function addMapDesDO(mapDesDO:MapDesDO):void {
			if (mapDesDO != null && mapDesDO.name != null) {
				mapDesDOHV.push(mapDesDO, mapDesDO.name);
			}
		}

		public function findMapDesDOByName(name:String):MapDesDO {
			return mapDesDOHV.findByName(name) as MapDesDO;
		}
	}
}
