package com.snsoft.tsp3.plugin.player {
	import com.snsoft.tsp3.plugin.BPlugin;
	import com.snsoft.util.SkinsUtil;

	import fl.video.FLVPlayback;

	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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

		private var playerSize:Point = new Point(420, 320);

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

			var back:MovieClip = SkinsUtil.createSkinByName("Player_backSkin");
			backLayer.addChild(back);
			back.width = playerSize.x;
			back.height = playerSize.y;

			var btn1:MovieClip = this.getChildByName("btn1") as MovieClip;
			var btn2:MovieClip = this.getChildByName("btn2") as MovieClip;

			btn1.addEventListener(MouseEvent.CLICK, handler1);
			btn2.addEventListener(MouseEvent.CLICK, handler2);

			stage.addEventListener(Event.ENTER_FRAME, handler);
		}

		public function handler1(e:Event):void {
			playMp3("1.mp3");
		}

		public function handler2(e:Event):void {
			playVideo("1.flv");
		}

		public function playVideo(url:String):void {
			stopAll();
			video = new FLVPlayback();
			video.width = playerSize.x - boader - boader;
			video.height = playerSize.y - boader - boader;
			videoLayer.addChild(video);
			video.x = boader;
			video.y = boader;
			video.play(url);
		}

		public function playMp3(url:String):void {
			stopAll();
			var req:URLRequest = new URLRequest(url);
			sound = new Sound(req);
			sc = sound.play();

		}

		private function handler(e:Event):void {
			draw();
		}

		public function draw():void {

			const PLOT_HEIGHT:int = 400;
			const CHANNEL_LENGTH:int = 100;
			var bytes:ByteArray = new ByteArray();

			SoundMixer.computeSpectrum(bytes, false, 0);

			var g:Graphics = soundLayer.graphics;

			g.clear();

			g.lineStyle(0, 0x6600CC);
			g.beginFill(0x6600CC);
			g.moveTo(0, PLOT_HEIGHT);

			var n:Number = 0;

			// left channel
			for (var i:int = 0; i < CHANNEL_LENGTH; i++) {
				n = (bytes.readFloat() * PLOT_HEIGHT);
				g.lineTo(i * 2, PLOT_HEIGHT - n);
			}
			g.lineTo(CHANNEL_LENGTH * 2, PLOT_HEIGHT);
			g.endFill();

			// right channel
			g.lineStyle(0, 0xCC0066);
			g.beginFill(0xCC0066, 0.5);
			g.moveTo(CHANNEL_LENGTH * 2, PLOT_HEIGHT);

			for (i = CHANNEL_LENGTH; i > 0; i--) {
				n = (bytes.readFloat() * PLOT_HEIGHT);
				g.lineTo(i * 2, PLOT_HEIGHT - n);
			}
			g.lineTo(0, PLOT_HEIGHT);
			g.endFill();

		}

		public function stopAll():void {
			if (sc != null) {
				sc.stop();
			}
			if (sound != null) {
				try {
					sound.close();
				}
				catch (error:Error) {
				}
			}
			if (video != null) {
				video.visible = false;
				video.stop();
				videoLayer.removeChild(video);
				video = null;
			}
		}

	}
}
