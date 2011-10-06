package com.snsoft.tsp3.plugin.player {
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.util.SkinsUtil;

	import fl.video.FLVPlayback;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class Player extends BPlugin {

		private var video:FLVPlayback;

		private var sound:Sound;

		private var sc:SoundChannel;

		private var videoLayer:Sprite = new Sprite();

		private var backLayer:Sprite = new Sprite();

		private var btnLayer:Sprite = new Sprite();

		private var soundLayer:Sprite = new Sprite();

		private var boader:int = 10;

		private var btnw:int = 48;

		private var playerSize:Point = new Point(420, 320);

		private var vw:int;

		private var vh:int;

		private var sw:SoundWave;

		private var playBtn:MovieClip;

		private var pauseBtn:MovieClip;

		private var stopBtn:MovieClip;

		private var playType:int = 0;

		private var PLAY_TYPE_SOUND:int = 0;

		private var PLAY_TYPE_VIDEO:int = 0;

		private var status:int = -1;

		private static const STATUS_PLAY:int = 1;

		private static const STATUS_PAUSE:int = 2;

		private static const STATUS_STOP:int = 0;

		private static const STATUS_START:int = 3;

		private var url:String;

		private var playIndex:Number;

		public function Player() {
			super();
			this.playerSize = playerSize;
			this.addChild(backLayer);
			this.addChild(videoLayer);
			this.addChild(soundLayer);
			this.addChild(btnLayer);
			pluginCfg = new PlayerCfg;
		}

		override protected function init():void {
			var cfg:PlayerCfg = pluginCfg as PlayerCfg;
			playerSize.x = int(cfg.playerWidth);
			playerSize.y = int(cfg.playerHeight);

			vw = playerSize.x - boader - boader;
			vh = playerSize.y - boader - boader - btnw - boader;

			var back:MovieClip = SkinsUtil.createSkinByName("Player_backSkin");
			backLayer.addChild(back);
			back.width = playerSize.x;
			back.height = playerSize.y;

			var videoBack:MovieClip = SkinsUtil.createSkinByName("Player_videoBackSkin");
			backLayer.addChild(videoBack);
			videoBack.x = boader;
			videoBack.y = boader;
			videoBack.width = vw;
			videoBack.height = vh;

			var btn1:MovieClip = this.getChildByName("btn1") as MovieClip;
			var btn2:MovieClip = this.getChildByName("btn2") as MovieClip;

			btn1.addEventListener(MouseEvent.CLICK, handler1);
			btn2.addEventListener(MouseEvent.CLICK, handler2);

			sw = new SoundWave(vw, vh, 100);
			sw.x = boader;
			sw.y = boader;
			soundLayer.addChild(sw);
			sw.visible = false;

			btnLayer.y = playerSize.y - btnw - boader;

			playBtn = SkinsUtil.createSkinByName("Player_playBtnSkin");
			playBtn.x = boader;
			btnLayer.addChild(playBtn);
			playBtn.addEventListener(MouseEvent.CLICK, handlerPlayBtnClick);

			pauseBtn = SkinsUtil.createSkinByName("Player_pauseBtnSkin");
			pauseBtn.x = boader;
			pauseBtn.visible = false;
			btnLayer.addChild(pauseBtn);
			pauseBtn.addEventListener(MouseEvent.CLICK, handlerPauseBtnClick);

			stopBtn = SkinsUtil.createSkinByName("Player_stopBtnSkin");
			stopBtn.x = boader + btnw + boader;
			btnLayer.addChild(stopBtn);
			stopBtn.addEventListener(MouseEvent.CLICK, handlerStopBtnClick);

			var topScreenBtn:MovieClip = SkinsUtil.createSkinByName("Player_topScreenBtnSkin");
			topScreenBtn.x = playerSize.x - (boader + btnw);
			btnLayer.addChild(topScreenBtn);
			topScreenBtn.addEventListener(MouseEvent.CLICK, handlertopScreenBtnClick);

			var fullScreenBtn:MovieClip = SkinsUtil.createSkinByName("Player_fullScreenBtnSkin");
			fullScreenBtn.x = playerSize.x - 2 * (boader + btnw);
			btnLayer.addChild(fullScreenBtn);
			fullScreenBtn.addEventListener(MouseEvent.CLICK, handlerfullScreenBtnClick);

			var defScreenBtn:MovieClip = SkinsUtil.createSkinByName("Player_defScreenBtnSkin");
			defScreenBtn.x = playerSize.x - 3 * (boader + btnw);
			btnLayer.addChild(defScreenBtn);
			defScreenBtn.addEventListener(MouseEvent.CLICK, handlerdefScreenBtnClick);
		}

		private function handlerPlayBtnClick(e:Event):void {
			playMp3WithStatus(STATUS_PLAY);
		}

		private function handlerPauseBtnClick(e:Event):void {
			playMp3WithStatus(STATUS_PAUSE);
		}

		private function handlerStopBtnClick(e:Event):void {
			playMp3WithStatus(STATUS_STOP);
		}

		private function handlerdefScreenBtnClick(e:Event):void {

		}

		private function handlerfullScreenBtnClick(e:Event):void {

		}

		private function handlertopScreenBtnClick(e:Event):void {

		}

		private function playAndStopStatus():void {

		}

		public function handler1(e:Event):void {
			playMp3("1.mp3");
		}

		public function handler2(e:Event):void {
			playVideo("1.flv");
		}

		public function playVideo(url:String):void {
			playType = PLAY_TYPE_VIDEO;
			this.url = url;
			stopAll();
			video = new FLVPlayback();
			video.width = vw;
			video.height = vh;
			videoLayer.addChild(video);
			video.x = boader;
			video.y = boader;
			video.play(url);
		}

		private function playMp3WithStatus(status:int):void {
			var os:int = this.status;
			var sign:Boolean = true;
			var b:Boolean = true;
			if (status == STATUS_START) {
				stopAll();
				var req:URLRequest = new URLRequest(url);
				sound = new Sound(req);
				sound.addEventListener(ProgressEvent.PROGRESS, handlerSoundPlaying);
				sc = sound.play();
				sw.playWave();
				sw.visible = true;
			}
			else if ((os == STATUS_PAUSE || os == STATUS_STOP) && status == STATUS_PLAY) {
				sw.playWave();
				sw.visible = true;
				sc = sound.play(playIndex);
				b = true;
			}
			else if (os == STATUS_PLAY && status == STATUS_PAUSE) {
				sw.stopWave();
				sw.visible = true;
				playIndex = sc.position;
				sc.stop();
				b = false;
			}
			else if (status == STATUS_STOP) {
				sw.stopWave();
				sw.visible = false;
				playIndex = 0;
				sc.stop();
				b = false;
			}
			else {
				sign = false;
			}
			if (sign) {
				this.status = status;
				pauseBtn.visible = b;
				playBtn.visible = !b;
			}
		}

		private function handlerSoundPlaying(e:Event):void {
			trace("handlerSoundPlaying");
			sound.removeEventListener(ProgressEvent.PROGRESS, handlerSoundPlaying);
			this.status = STATUS_PLAY;
		}

		public function playMp3(url:String):void {
			playType = PLAY_TYPE_SOUND;
			this.url = url;
			playMp3WithStatus(STATUS_START);
		}

		public function stopAll():void {
			if (sc != null) {
				sc.stop();
				sc = null;
			}
			if (sound != null) {
				sound.removeEventListener(ProgressEvent.PROGRESS, handlerSoundPlaying);
				try {
					sound.close();
				}
				catch (error:Error) {
				}
				sound = null;
			}
			if (video != null) {
				video.visible = false;
				video.stop();
				videoLayer.removeChild(video);
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
