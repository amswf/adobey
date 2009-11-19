package {

	import flash.display.MovieClip;

	import flash.display.NativeWindow;

	import flash.text.TextField;

	import flash.display.SimpleButton;

	import flash.events.MouseEvent;
	
	import flash.display.Stage;
	
	import flash.display.StageDisplayState;

	import flash.display.StageAlign;
	
	import flash.display.StageScaleMode;
	
	

	public class main extends MovieClip {

		private var window:NativeWindow;

		private var mytxt:TextField;
		
		public function main(){
			startrun();
		}

		private function startrun():void {

			var stg:Stage = stage;
			
			stg.displayState = StageDisplayState.FULL_SCREEN;
			
			stg.align = StageAlign.TOP_LEFT;
			
			stg.scaleMode = StageScaleMode.NO_SCALE;
			
			window=stage.nativeWindow;

			window.title="我自定义窗体";

			mytxt=new TextField  ;

			mytxt.width=100;

			mytxt.height=20;

			mytxt.x=225;

			mytxt.y=180;

			mytxt.text="Hello AS3!";

			addChild(mytxt);

			close_btn.addEventListener(MouseEvent.CLICK,closethis);

			mainBg.addEventListener(MouseEvent.MOUSE_DOWN,drag);

		}

		private function clickclose(event:MouseEvent):void {

			play();

		}

		private function closethis(event:MouseEvent):void {

			window.close();

		}

		private function drag(event:MouseEvent):void {

			window.startMove();
			ttx.text = String(window.x);
			tty.text = String(window.y);
		}

	}

}