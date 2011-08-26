package com.snsoft.tsp3 {
	import com.snsoft.tsp3.compatible.CompatibleAir;
	import com.snsoft.tsp3.compatible.CompatibleIE;
	import com.snsoft.tsp3.compatible.ICompatible;

	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;

	public class Test {

		private var cpt:ICompatible = null;

		public function Test() {

			var Compatible:Class = null;
			if (Capabilities.playerType == "Desktop") {
				new CompatibleAir();
				Compatible = getDefinitionByName("com.snsoft.tsp3.compatible.CompatibleAir") as Class;
			}
			else {
				new CompatibleIE();
				Compatible = getDefinitionByName("com.snsoft.tsp3.compatible.CompatibleIE") as Class;
			}

			if (Compatible != null) {
				cpt = new Compatible();
			}
		}

		public function getData():String {
			return cpt.saveData("asdfasd");
		}
	}
}
