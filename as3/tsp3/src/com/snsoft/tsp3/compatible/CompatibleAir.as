package com.snsoft.tsp3.compatible {
	import flash.filesystem.File;

	public class CompatibleAir implements ICompatible {
		public function CompatibleAir() {
		}

		public function saveData(data:String):String {
			var file:File = new File();
			return ("air:" + data);
		}
	}
}
