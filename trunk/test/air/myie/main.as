package {
	import flash.html.HTMLLoader;

	import flash.net.URLRequest;

	import flash.display.MovieClip;

	import flash.display.NativeWindow;

	import flash.text.TextField;

	import flash.display.SimpleButton;

	import flash.events.MouseEvent;

	import flash.display.Stage;

	import flash.display.StageDisplayState;

	import flash.display.StageAlign;

	import flash.display.StageScaleMode;
	
	import flash.events.Event;


	public class main extends MovieClip {

		private var window:NativeWindow;

		private var mytxt:TextField;

		public function main() {
			startrun();
		}

		private function startrun():void {

			var stg:Stage = stage;

			stg.displayState = StageDisplayState.FULL_SCREEN;

			stg.align = StageAlign.TOP_LEFT;

			stg.scaleMode = StageScaleMode.NO_SCALE;

			window=stage.nativeWindow;

			window.title="我自定义窗体";

			closeBtn.addEventListener(MouseEvent.CLICK,closethis);

			titleBar.addEventListener(MouseEvent.MOUSE_DOWN,drag);

			var html:HTMLLoader = new HTMLLoader();

			var urlReq:URLRequest = new URLRequest("http://www.qq.com/");

			html.width = bak.width;

			html.height = bak.width;

			html.x = bak.x;

			html.y = bak.y;

			html.load(urlReq);
			
			urlStr.text = html.location;

			//html.addEventListener(Event.COMPLETE,hanerCmp);

			hl.addChild(html);

		}

		private function clickclose(event:MouseEvent):void {

			play();

		}

		private function closethis(event:MouseEvent):void {

			window.close();

		}

		private function drag(event:MouseEvent):void {

			window.startMove();

		}

	}

}