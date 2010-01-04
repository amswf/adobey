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

	import flash.events.Event;

	import flash.geom.Point;
	
	import flash.events.ScreenMouseEvent;
	
	import flash.desktop.NativeApplication;
	
	import flash.display.Loader;
	
	import flash.display.NativeMenu;
	
	import flash.display.NativeMenuItem;
	
	import flash.net.URLRequest;
	
	import flash.desktop.SystemTrayIcon;
	
	import flash.desktop.DockIcon;



	public class main extends MovieClip {

		private var window:NativeWindow;

		private var mytxt:TextField;

		private var wWidth:Number = 0;

		private var wHeight:Number = 0;


		public function main() {
			startrun();
		}

		private function startrun():void {

			var stg:Stage = stage;

			stg.displayState = StageDisplayState.FULL_SCREEN;

			wWidth = stg.width;

			wHeight = stg.height;

			stg.align = StageAlign.TOP_LEFT;

			stg.scaleMode = StageScaleMode.NO_SCALE;

			window = stage.nativeWindow;

			window.title = "我自定义窗体";

			wWidth = window.width;

			wHeight = window.height;

			stg.displayState = StageDisplayState.NORMAL;

			close_btn.addEventListener(MouseEvent.CLICK,closethis);

			mainBg.addEventListener(MouseEvent.MOUSE_DOWN,drag);

			fullScreen.addEventListener(MouseEvent.CLICK,doubleClick);
			
			minBtn.addEventListener(MouseEvent.CLICK,clickWindowHandler);

		}

		private function doubleClick(event:MouseEvent):void {

			stage.stageWidth = wWidth;

			stage.stageHeight = wHeight;

			stage.displayState = StageDisplayState.FULL_SCREEN;
			window.x = 0;
			window.y = 0;

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
		/**关闭&最小化到托盘按钮点击事件处理*/
		public function clickWindowHandler(e:Event):void {
			trace("clickWindowHandler"+e.currentTarget);
			if (e.currentTarget == minBtn) {
				createIcon();
				stage.nativeWindow.visible = false;
			}
			if (e.currentTarget == close_btn) {
				NativeApplication.nativeApplication.exit();
			}
		}
		/**从后台再现窗体*/
		public function reappear(e:ScreenMouseEvent=null):void {
			stage.nativeWindow.visible = true;
			removeIcon();
		}
		/**创建托盘图标*/
		public function createIcon():void {
			NativeApplication.nativeApplication.autoExit = false;
			var icon:Loader = new Loader();
			var iconMenu:NativeMenu = new NativeMenu();
			var exitCommand:NativeMenuItem = iconMenu.addItem(new NativeMenuItem("退出"));
			exitCommand.addEventListener(Event.SELECT, exitIcon);
			if (NativeApplication.supportsSystemTrayIcon) {
				NativeApplication.nativeApplication.autoExit = false;
				icon.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadComplete);
				icon.load(new URLRequest("AppIconsForAIRPublish/AIRApp_16.png"));
				var systray:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				systray.tooltip = "饭否AIR客户端";
				systray.menu = iconMenu;
				systray.addEventListener(MouseEvent.CLICK,reappear);
			}
			if (NativeApplication.supportsDockIcon) {
				icon.contentLoaderInfo.addEventListener(Event.COMPLETE,iconLoadComplete);
				icon.load(new URLRequest("resource/icons/i128.png"));
				var dock:DockIcon = NativeApplication.nativeApplication.icon as DockIcon;
				dock.menu = iconMenu;
				dock.addEventListener(MouseEvent.CLICK,reappear);//这种情况我没法测试 也不知道会不会有问题,所以先Alpha一下 
			}
		}

		/** 托盘点击退出*/
		public function exitIcon(e:Event):void {
			NativeApplication.nativeApplication.icon.bitmaps = [];
			NativeApplication.nativeApplication.exit();

		}

		/**移除托盘图标*/
		public function removeIcon():void {
			NativeApplication.nativeApplication.icon.bitmaps = [];
		}
		private function iconLoadComplete(event:Event):void {
			NativeApplication.nativeApplication.icon.bitmaps = [event.target.content.bitmapData];
		}


	}

}