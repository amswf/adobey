package com.snsoft.util.wayfd {

	public class WayUtil {
		public function WayUtil() {
		}

		/**
		 *  克隆  Vector.<Vector.<Boolean>>
		 * @param ivv
		 * @return
		 *
		 */
		public static function copyVectorVectorBoolean(ivv:Vector.<Vector.<Boolean>>):Vector.<Vector.<Boolean>> {
			var civv:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>();
			for (var i:int = 0; i < ivv.length; i++) {
				var iv:Vector.<Boolean> = ivv[i];
				var civ:Vector.<Boolean> = copyVectorBoolean(iv);
				civv.push(civ);
			}
			return civv;
		}

		/**
		 * 克隆  Vector.<Boolean>
		 * @param pv
		 * @return
		 *
		 */
		public static function copyVectorBoolean(pv:Vector.<Boolean>):Vector.<Boolean> {
			var cpv:Vector.<Boolean> = new Vector.<Boolean>();
			for (var i:int = 0; i < pv.length; i++) {
				cpv.push(pv[i]);
			}
			return cpv;
		}
	}
}
