package com.snsoft.tsp3.plugin {
	import com.snsoft.tsp3.MySprite;
	import com.snsoft.tsp3.PromptMsgMng;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSSwf;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class BPlugin extends MySprite {

		private var _promptMsgMng:PromptMsgMng;
		
		public function BPlugin() {
			super();

		}

		public function get promptMsgMng():PromptMsgMng
		{
			return _promptMsgMng;
		}

		public function set promptMsgMng(value:PromptMsgMng):void
		{
			_promptMsgMng = value;
		}

	}
}
