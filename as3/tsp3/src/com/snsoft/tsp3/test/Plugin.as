package com.snsoft.tsp3.test {
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSSwf;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;

	public class Plugin extends MovieClip {

		private var rss:RSSwf = new RSSwf();

		public function Plugin() {
			super();
			var rlm:ResLoadManager = new ResLoadManager();

			rss.addResUrl("skins.swf");

			rlm.addResSet(rss);
			rlm.addEventListener(Event.COMPLETE, handler);
			rlm.load();

		}

		private function handler(e:Event):void {
			var info:LoaderInfo = rss.getInfoByUrl("skins.swf");
			Skins.setDomain(info.applicationDomain);
			var mm:MovieClip = Skins.getSkin("Skin2");
			this.addChild(mm);
		}

		public function playit():void {
			var tfd:TextField = new TextField();
			tfd.text = "asdfasdfasdf";
			this.addChild(tfd);
		}
	}
}
