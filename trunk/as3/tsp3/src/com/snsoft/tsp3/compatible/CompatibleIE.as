package com.snsoft.tsp3.compatible {

	public class CompatibleIE implements ICompatible {
		public function CompatibleIE() {
		}

		public function saveData(data:String):String {
			return ("ie:" + data);
		}
	}
}
