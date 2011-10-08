package com.snsoft.tsp3.plugin {
	import flash.events.Event;

	public class BPluginEvent extends Event {

		public static const PLUGIN_MINIMIZE:String = "pluginMinimize";

		public static const PLUGIN_CLOSE:String = "pluginClose";

		public function BPluginEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
