package com.snsoft.tsp3 {
	import flash.display.Screen;

	public class ScreenMng {

		private static var lock:Boolean = false;

		private var _mainScreen:Screen;

		private var _topScreen:Screen;

		private static var sm:ScreenMng = new ScreenMng();

		public function ScreenMng() {
			if (lock) {
				throw(new Error("ScreenMng can not new"));
			}
			lock = true;
			init();
		}

		public static function instance():ScreenMng {
			return sm;
		}

		private function init():void {
			_mainScreen = Screen.mainScreen;
			for (var i:int = 0; i < Screen.screens.length; i++) {
				var scrn:Screen = Screen.screens[i];
				if (!(scrn.bounds.x == 0 && scrn.bounds.y == 0)) {
					_topScreen = scrn;
					break;
				}
			}
		}

		public function get topScreen():Screen {
			return _topScreen;
		}

		public function get mainScreen():Screen {
			return _mainScreen;
		}

	}
}
