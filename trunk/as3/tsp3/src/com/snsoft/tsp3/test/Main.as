package com.snsoft.tsp3.test {
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSSwf;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Main extends MovieClip {

		private var rss:RSSwf = new RSSwf();

		public function Main() {
			super();

			var rlm:ResLoadManager = new ResLoadManager();

			rss.addResUrl("plugin.swf");

			rlm.addResSet(rss);
			rlm.addEventListener(Event.COMPLETE, handler);
			rlm.load();

		}

		private function handler(e:Event):void {
			var plugin:Plugin = rss.getSwfByUrl("plugin.swf") as Plugin;
			plugin.x = 100;
			this.addChild(plugin);

			plugin.addEventListener(MouseEvent.CLICK, handlerClick);
		}

		private function handlerClick(e:Event):void {
			var mm:MovieClip = Skins.getSkin("Skin2");
			this.addChild(mm);

		}
	}
}
