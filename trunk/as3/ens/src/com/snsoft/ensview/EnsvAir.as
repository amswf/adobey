package com.snsoft.ensview {
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.XMLFormat;
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSTextFile;
	import com.snsoft.util.xmldom.XMLFastConfig;

	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.system.Capabilities;

	public class EnsvAir extends Sprite {

		private var win:NativeWindow;

		private var startLayer:Sprite = new Sprite();

		private var ensLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var mainback:Sprite;

		private var winBoader:int = 10;

		private var mainSize:Point = new Point(550, 400);

		private var boothDownloadUrl:String;

		private var downloadRstf:RSTextFile;

		private var ensvStart:EnsvStart;

		public function EnsvAir() {
			super();

			initConfig();
		}

		private function initConfig():void {
			XMLFastConfig.instance("config.xml", handlerConfigLoadCmp);
		}

		private function handlerConfigLoadCmp(e:Event):void {
			init();
		}

		private function init():void {
			win = stage.nativeWindow;
			win.title = "ensv 1.0";
			win.x = (Capabilities.screenResolutionX - stage.stageWidth) / 2;
			win.y = (Capabilities.screenResolutionY - stage.stageHeight) / 2;
			var file:File = File.applicationStorageDirectory;
			trace(file.nativePath);

			this.addChild(backLayer);
			this.addChild(startLayer);
			this.addChild(ensLayer);

			stage.addEventListener(Event.FULLSCREEN, handlerFullScreen);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			initBack();
			initStart();
		}

		private function handlerFullScreen(e:Event):void {
			if (stage.displayState == StageDisplayState.FULL_SCREEN) {
				ensLayer.visible = true;
				mainback.visible = true;
				startLayer.visible = false;
				mainback.width = stage.stageWidth;
				mainback.height = stage.stageHeight;
				initEns();
			}
			else {
				mainback.visible = false;
				ensLayer.visible = false;
				startLayer.visible = true;
			}
		}

		private function initBack():void {
			mainback = new Sprite();
			mainback.visible = false;
			mainback.graphics.beginFill(0xffffff, 1);
			mainback.graphics.drawRect(0, 0, mainSize.x, mainSize.y);
			mainback.graphics.endFill();
			backLayer.addChild(mainback);
		}

		private function initStart():void {
			ensvStart = new EnsvStart();
			ensvStart.x = 10;
			ensvStart.y = 10;
			startLayer.addChild(ensvStart);
			ensvStart.addEventListener(EnsvStart.EVENT_DOWNLOAD, handlerDownload);
			ensvStart.addEventListener(EnsvStart.EVENT_START, handlerStart);
			ensvStart.addEventListener(EnsvStart.EVENT_CLOSE, handlerClose);
		}

		private function handlerDownload(e:Event):void {
			downloadFile();
		}

		private function downloadFile():void {
			var res:ResLoadManager = new ResLoadManager();
			boothDownloadUrl = XMLFastConfig.getConfig("downloadBoothMsgUrl");
			downloadRstf = new RSTextFile();
			downloadRstf.addResUrl(boothDownloadUrl);
			res.addResSet(downloadRstf);
			res.addEventListener(Event.COMPLETE, handlerResLoadCmp);
			res.addEventListener(ProgressEvent.PROGRESS, handlerResLoading);
			res.load();
			ensvStart.setMsg("准备下载数据...");
		}

		private function handlerResLoading(e:Event):void {
			var res:ResLoadManager = e.currentTarget as ResLoadManager;
			ensvStart.setMsg("正在下载：" + int(res.getProgressValue() * 100) + "%");
		}

		private function handlerResLoadCmp(e:Event):void {
			ensvStart.setMsg("");
			var appPath:String = File.applicationDirectory.nativePath + File.separator;

			var boothMsg:String = downloadRstf.getTextByUrl(boothDownloadUrl);

			var boothFilePath:String = appPath + "boothMsg.xml";
			var boothFile:File = new File(boothFilePath);
			if (boothFile.exists) {
				boothFile.deleteFile();
			}
			var fs:FileStream = new FileStream();
			fs.open(boothFile, FileMode.WRITE);
			fs.writeUTFBytes(boothMsg);
			fs.close();
		}

		private function handlerStart(e:Event):void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}

		private function handlerClose(e:Event):void {
			win.close();
		}

		private function initEns():void {
			SpriteUtil.deleteAllChild(ensLayer);
			var ensv:Ensv = new Ensv(stage.stageWidth, stage.stageHeight);
			ensLayer.addChild(ensv);
		}
	}
}
