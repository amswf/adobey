package com.snsoft.tsp3.plugin.player {
	import com.snsoft.tsp3.Common;
	import com.snsoft.tsp3.IPlayer;
	import com.snsoft.tsp3.ViewUtil;
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.util.SkinsUtil;
	import com.snsoft.util.SpriteUtil;

	import fl.video.FLVPlayback;
	import fl.video.VideoEvent;
	import fl.video.VideoState;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Player extends BPlugin implements IPlayer {

		private var video:FLVPlayback;

		private var sound:Sound;

		private var sc:SoundChannel;

		private var videoLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var dragLayer:Sprite = new Sprite();

		private var topBtnLayer:Sprite = new Sprite();

		private var bottomBtnLayer:Sprite = new Sprite();

		private var rightBtnLayer:Sprite = new Sprite();

		private var titleLayer:Sprite = new Sprite();

		private var msgLayer:Sprite = new Sprite();

		private var soundLayer:Sprite = new Sprite();

		private var msgTfd:TextField;

		private var titleTfd:TextField;

		private var tft:TextFormat = new TextFormat(null, 13, 0xffffff);

		private var boader:int = 10;

		private var btnw:int = 48;

		private var playerSize:Point = new Point(420, 320);

		private var titleh:int = 48;

		private var vw:int;

		private var vh:int;

		private var sw:SoundWave;

		private var playBtn:MovieClip;

		private var pauseBtn:MovieClip;

		private var stopBtn:MovieClip;

		private var playType:int = 0;

		private var PLAY_TYPE_SOUND:int = 1;

		private var PLAY_TYPE_VIDEO:int = 2;

		private var status:int = -1;

		private static const STATUS_PLAY:int = 1;

		private static const STATUS_PAUSE:int = 2;

		private static const STATUS_STOP:int = 0;

		private static const STATUS_START:int = 3;

		private var url:String;

		private var playIndex:Number;

		private var videoBack:MovieClip;

		private var closeBtn:MovieClip;

		private var back:MovieClip;

		private var dragSpr:Sprite;

		private var screenType:int = 0;

		private static var SCREEN_TYPE_DEF:int = 0;

		private static var SCREEN_TYPE_FULL:int = 1;

		private static var SCREEN_TYPE_TOP:int = 2;

		private var defCoord:Point = new Point();

		private var dragSign:Boolean = false;

		private var topScreenBtn:MovieClip

		public function Player() {
			super();
			this.playerSize = playerSize;
			this.addChild(backLayer);
			this.addChild(titleLayer);
			this.addChild(dragLayer);
			this.addChild(topBtnLayer);
			this.addChild(videoLayer);
			this.addChild(soundLayer);
			this.addChild(bottomBtnLayer);
			this.addChild(msgLayer);

			bottomBtnLayer.addChild(rightBtnLayer);

			pluginCfg = new PlayerCfg;
		}

		override protected function init():void {

			var cfg:PlayerCfg = pluginCfg as PlayerCfg;
			playerSize.x = int(cfg.playerWidth);
			playerSize.y = int(cfg.playerHeight);

			defCoord.x = (stage.stageWidth - playerSize.x) / 2;
			defCoord.y = (stage.stageHeight - playerSize.y) / 2;

			vw = playerSize.x - boader - boader;
			vh = playerSize.y - titleh - boader - boader - boader - btnw - boader;

			back = SkinsUtil.createSkinByName("Player_backSkin");
			backLayer.addChild(back);

			dragSpr = ViewUtil.creatRect(100, 100);
			dragSpr.addEventListener(MouseEvent.MOUSE_DOWN, handlerBackMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handlerBackMouseUp);
			dragLayer.addChild(dragSpr);

			titleTfd = new TextField();
			titleTfd.defaultTextFormat = tft;
			titleTfd.height = 20;
			titleTfd.x = boader;
			titleTfd.y = boader;
			titleTfd.mouseEnabled = false;
			titleLayer.addChild(titleTfd);

			videoBack = SkinsUtil.createSkinByName("Player_videoBackSkin");
			backLayer.addChild(videoBack);
			videoBack.x = boader;
			videoBack.y = boader + titleh + boader;

			msgTfd = new TextField();
			msgTfd.defaultTextFormat = tft;
			msgTfd.width = vw;
			msgTfd.height = 20;
			msgTfd.autoSize = TextFieldAutoSize.CENTER;
			msgTfd.mouseEnabled = false;
			msgLayer.addChild(msgTfd);

			var btn1:MovieClip = this.getChildByName("btn1") as MovieClip;
			var btn2:MovieClip = this.getChildByName("btn2") as MovieClip;

			sw = new SoundWave(vw, vh, 10);
			sw.x = (vw - sw.width) / 2 + boader;
			sw.y = (vh - sw.height) / 2 + titleh + boader + boader;
			soundLayer.addChild(sw);
			sw.visible = false;

			playBtn = SkinsUtil.createSkinByName("Player_playBtnSkin");
			playBtn.buttonMode = true;
			playBtn.x = boader;
			bottomBtnLayer.addChild(playBtn);
			playBtn.addEventListener(MouseEvent.CLICK, handlerPlayBtnClick);

			pauseBtn = SkinsUtil.createSkinByName("Player_pauseBtnSkin");
			pauseBtn.buttonMode = true;
			pauseBtn.x = boader;
			pauseBtn.visible = false;
			bottomBtnLayer.addChild(pauseBtn);
			pauseBtn.addEventListener(MouseEvent.CLICK, handlerPauseBtnClick);

			stopBtn = SkinsUtil.createSkinByName("Player_stopBtnSkin");
			stopBtn.buttonMode = true;
			stopBtn.x = boader + btnw + boader;
			bottomBtnLayer.addChild(stopBtn);
			stopBtn.addEventListener(MouseEvent.CLICK, handlerStopBtnClick);

			var defScreenBtn:MovieClip = SkinsUtil.createSkinByName("Player_defScreenBtnSkin");
			defScreenBtn.buttonMode = true;
			rightBtnLayer.addChild(defScreenBtn);
			defScreenBtn.addEventListener(MouseEvent.CLICK, handlerdefScreenBtnClick);

			var fullScreenBtn:MovieClip = SkinsUtil.createSkinByName("Player_fullScreenBtnSkin");
			fullScreenBtn.buttonMode = true;
			fullScreenBtn.x = defScreenBtn.x + defScreenBtn.width + boader;
			rightBtnLayer.addChild(fullScreenBtn);
			fullScreenBtn.addEventListener(MouseEvent.CLICK, handlerfullScreenBtnClick);

			topScreenBtn = SkinsUtil.createSkinByName("Player_topScreenBtnSkin");
			topScreenBtn.buttonMode = true;
			topScreenBtn.visible = false;
			topScreenBtn.x = fullScreenBtn.x + fullScreenBtn.width + boader;
			rightBtnLayer.addChild(topScreenBtn);
			topScreenBtn.addEventListener(MouseEvent.CLICK, handlertopScreenBtnClick);

			closeBtn = SkinsUtil.createSkinByName("Player_closeBtnSkin");
			closeBtn.buttonMode = true;
			closeBtn.y = boader;
			topBtnLayer.addChild(closeBtn);
			closeBtn.addEventListener(MouseEvent.CLICK, handlerCloseBtnClick);

			//btn1.addEventListener(MouseEvent.CLICK, handler1);
			//btn2.addEventListener(MouseEvent.CLICK, handler2);

			setSize();
			Common.instance().initPlayer(this);
		}

		private function setSize():void {
			var p:Point = null;

			var pz:Point = new Point();
			if (screenType == SCREEN_TYPE_FULL) {
				p = new Point(stage.stageWidth, stage.stageHeight);
				pz.x = 0;
				pz.y = 0;
			}
			else {
				p = playerSize;
				pz.x = defCoord.x;
				pz.y = defCoord.y;
			}

			this.x = pz.x;
			this.y = pz.y;

			vw = p.x - boader - boader;
			vh = p.y - titleh - boader - boader - boader - btnw - boader;

			back.width = p.x;
			back.height = p.y;

			dragSpr.width = p.x;
			dragSpr.height = p.y;

			titleTfd.width = vw;

			videoBack.width = vw;
			videoBack.height = vh;

			msgTfd.x = (p.x - msgTfd.width) / 2;
			msgTfd.y = boader + titleh + boader + (vh - msgTfd.height) / 2;

			sw.width = vw;
			sw.height = vh;

			if (video != null && screenType != SCREEN_TYPE_TOP) {
				video.width = vw;
				video.height = vh;
			}

			bottomBtnLayer.y = p.y - btnw - boader;
			rightBtnLayer.x = p.x - boader - rightBtnLayer.width;
			closeBtn.x = p.x - (boader + btnw);
		}

		//********************************************
//		public function handler1(e:Event):void {
//			playMp3("1.mp3", "1.mp3");
//		}
//
//		public function handler2(e:Event):void {
//			playVideo("1.flv", "1.flv");
//		}

		//********************************************

		private function handlerBackMouseUp(e:Event):void {
			this.stopDrag();
			if (dragSign) {
				dragSign = false;
				defCoord.x = this.x;
				defCoord.y = this.y;
			}
		}

		private function handlerBackMouseDown(e:Event):void {
			if (screenType == SCREEN_TYPE_DEF || screenType == SCREEN_TYPE_TOP) {
				dragSign = true;
				var w:int = stage.stageWidth - playerSize.x;
				var h:int = stage.stageHeight - playerSize.y;
				var rect:Rectangle = new Rectangle(0, 0, w, h);
				this.startDrag(false, rect);
			}
		}

		private function handlerPlayBtnClick(e:Event):void {
			playWithStatus(STATUS_PLAY);
		}

		private function handlerPauseBtnClick(e:Event):void {
			playWithStatus(STATUS_PAUSE);
		}

		private function handlerStopBtnClick(e:Event):void {
			playWithStatus(STATUS_STOP);
		}

		private function handlerCloseBtnClick(e:Event):void {
			if (screenType != SCREEN_TYPE_TOP) {
				playWithStatus(STATUS_STOP);
			}
			this.minimizePlugin();
		}

		private function handlerdefScreenBtnClick(e:Event):void {
			var ost:int = screenType;
			screenType = SCREEN_TYPE_DEF;
			setSize();
			if (ost == SCREEN_TYPE_TOP) {
				playWithStatus(STATUS_START);
			}
		}

		private function handlerfullScreenBtnClick(e:Event):void {
			var ost:int = screenType;
			screenType = SCREEN_TYPE_FULL;
			setSize();
			if (ost == SCREEN_TYPE_TOP) {
				playWithStatus(STATUS_START);
			}
		}

		private function handlertopScreenBtnClick(e:Event):void {
			if (playType == PLAY_TYPE_VIDEO) {
				screenType = SCREEN_TYPE_TOP;
				setSize();
				playWithStatus(STATUS_START);
			}
		}

		private function playWithStatus(status:int):void {
			hiddenMsg();
			var os:int = this.status;
			var sign:Boolean = true;
			if (playType == PLAY_TYPE_SOUND) {
				topScreenBtn.visible = false;
				if (status == STATUS_START) {
					setMsg("正在加载文件...");
					sign = false;
					stopAll();
					var req:URLRequest = new URLRequest(url);
					sound = new Sound(req);
					sound.addEventListener(Event.COMPLETE, handlerSoundLoadCmp);
					sound.addEventListener(IOErrorEvent.IO_ERROR, handlerSoundIOError);
					sc = sound.play();
					sc.addEventListener(Event.SOUND_COMPLETE, handlerSoundCmp);
				}
				else if ((os == STATUS_PAUSE || os == STATUS_STOP) && status == STATUS_PLAY) {
					sw.playWave();
					sw.visible = true;
					sc = sound.play(playIndex);
					sc.addEventListener(Event.SOUND_COMPLETE, handlerSoundCmp);
				}
				else if (os == STATUS_PLAY && status == STATUS_PAUSE) {
					sw.visible = true;
					playIndex = sc.position;
					sc.stop();
				}
				else if (status == STATUS_STOP) {
					sw.stopWave();
					sw.visible = false;
					playIndex = 0;
					sc.stop();
				}
				else {
					sign = false;
				}
				if (sign) {
					this.status = status;
					setBtnPlaying();
				}
			}
			else if (playType == PLAY_TYPE_VIDEO) {
				if (status == STATUS_START || (os == STATUS_STOP && status == STATUS_PLAY)) {
					if (Common.instance().hasTopStage()) {
						topScreenBtn.visible = true;
					}
					setMsg("正在加载文件...");
					sign = false;
					stopAll();
					video = new FLVPlayback();
					video.addEventListener(VideoEvent.STATE_CHANGE, handlerVideoStatusChange);
					video.addEventListener(VideoEvent.COMPLETE, handlerVideoStatusCmp);
					video.width = vw;
					video.height = vh;
					//trace("top");
					if (screenType == SCREEN_TYPE_TOP) {
						Common.instance().topScreenPlayVideo(video);
					}
					else {
						videoLayer.addChild(video);
						video.x = boader;
						video.y = boader + titleh + boader;
					}

					video.play(url);

				}
				else if (os == STATUS_PAUSE && status == STATUS_PLAY) {
					video.play();
				}
				else if (os == STATUS_PLAY && status == STATUS_PAUSE) {
					video.pause();
				}
				else if (status == STATUS_STOP) {
					stopAll();
				}
				else {
					sign = false;
				}
				if (sign) {
					this.status = status;
				}
			}
		}

		private function setBtnPlaying():void {
			var b:Boolean = (status == STATUS_PLAY);
			pauseBtn.visible = b;
			playBtn.visible = !b;
		}

		private function handlerVideoStatusCmp(e:VideoEvent):void {
			//trace("handlerVideoStatusCmp");
			if (screenType == SCREEN_TYPE_TOP) {
				playWithStatus(STATUS_PLAY);
			}
			else {
				playWithStatus(STATUS_STOP);
			}
		}

		private function handlerVideoStatusChange(e:VideoEvent):void {
			if (e.state == VideoState.PLAYING) {
				hiddenMsg();
				if (screenType == SCREEN_TYPE_TOP) {
					setMsg("正在上屏播放...");
				}
				this.status = STATUS_PLAY;
			}
			else if (e.state == VideoState.PAUSED) {
				this.status = STATUS_PAUSE;
			}
			else if (e.state == VideoState.STOPPED) {
				this.status = STATUS_STOP;
			}
			else if (e.state == VideoState.CONNECTION_ERROR) {
				setMsg("播放文件地址错误！");
			}
			setBtnPlaying();
		}

		private function handlerSoundCmp(e:Event):void {
			playWithStatus(STATUS_STOP);
		}

		private function handlerSoundIOError(e:Event):void {
			var sound:Sound = e.currentTarget as Sound;
			sound.removeEventListener(IOErrorEvent.IO_ERROR, handlerSoundIOError);
			setMsg("播放文件地址错误！");
		}

		private function handlerSoundLoadCmp(e:Event):void {
			hiddenMsg();
			sound.removeEventListener(ProgressEvent.PROGRESS, handlerSoundLoadCmp);
			this.status = STATUS_PLAY;
			sw.playWave();
			sw.visible = true;
			setBtnPlaying();
		}

		public function playMp3(url:String, title:String = ""):void {
			setTitleText(title);
			this.url = url;
			this.playType = PLAY_TYPE_SOUND;
			playWithStatus(STATUS_START);
		}

		public function playVideo(url:String, title:String = ""):void {
			setTitleText(title);
			this.url = url;
			this.playType = PLAY_TYPE_VIDEO;
			playWithStatus(STATUS_START);
		}

		public function setVisible(visible:Boolean):void {
			this.visible = visible;
		}

		private function setTitleText(text:String):void {
			this.titleTfd.text = text;
		}

		private function setMsg(text:String):void {
			this.msgTfd.text = text;
			msgLayer.visible = true;
		}

		private function hiddenMsg():void {
			msgLayer.visible = false;
		}

		public function stopAll():void {
			if (sc != null) {
				sc.stop();
				sc.removeEventListener(Event.SOUND_COMPLETE, handlerSoundCmp);
				sc = null;
			}
			if (sound != null) {
				sound.removeEventListener(ProgressEvent.PROGRESS, handlerSoundLoadCmp);
				try {
					sound.close();
				}
				catch (e:Error) {
				}
				sound = null;
			}
			if (video != null) {
				video.visible = false;
				video.removeEventListener(VideoEvent.COMPLETE, handlerVideoStatusCmp);
				try {
					video.stop();
				}
				catch (e:Error) {
				}

				try {
					videoLayer.removeChild(video);
				}
				catch (error:Error) {
				}

				try {
					Common.instance().removeVideo();
				}
				catch (error:Error) {
				}
				video = null;
			}
			if (sw != null) {
				sw.stopWave();
				sw.visible = false;
			}
			status = STATUS_STOP;
		}

	}
}
