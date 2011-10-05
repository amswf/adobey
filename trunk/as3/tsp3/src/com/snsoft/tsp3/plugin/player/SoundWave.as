package com.snsoft.tsp3.plugin.player {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Timer;

	public class SoundWave extends Sprite {

		private static var CHANNEL_LENGTH:int = 256;

		private var msk:Sprite = new Sprite();

		private var wave:Sprite = new Sprite();

		private var timer:Timer;

		private var wWidth:int;

		private var wHeight:int;

		private var power:Number;

		public function SoundWave(width:int, height:int, delay:int = 1000, power:Number = 1.0) {
			this.wWidth = width;
			this.wHeight = height;
			this.power = power;

			var gri:Graphics = this.graphics;
			gri.beginFill(0xffffff, 0);
			gri.drawRect(0, 0, width, height);
			gri.endFill();

			this.addChild(wave);
			this.addChild(msk);

			var wg:Graphics = msk.graphics;
			wg.beginFill(0xffffff, 1);
			wg.drawRect(0, 0, width, height);
			wg.endFill();

			wave.mask = msk;

			timer = new Timer(delay, 0);
			timer.addEventListener(TimerEvent.TIMER, handlerTimer);
		}

		public function playWave():void {
			timer.start();
		}

		public function stopWave():void {
			timer.stop();
		}

		public function closeWave():void {
			timer.removeEventListener(TimerEvent.TIMER, handlerTimer);
		}

		private function handlerTimer(e:Event):void {
			var swing:Number = wHeight / 2;

			var bytes:ByteArray = new ByteArray();

			SoundMixer.computeSpectrum(bytes, false, 0);

			var g:Graphics = wave.graphics;

			g.clear();

			var rate:Number = wWidth / CHANNEL_LENGTH;

			// left channel
			g.lineStyle(0, 0xCC0066);
			for (var li:int = 0; li < CHANNEL_LENGTH; li++) {
				var lx:Number = li * rate;
				var ly:Number = (1 - power * bytes.readFloat()) * swing;
				if (li != 0) {
					g.lineTo(lx, ly);
				}
				else {
					g.moveTo(lx, ly);
				}
			}

			// right channel
			g.lineStyle(0, 0x6600CC);
			for (var ri:int = 0; ri < CHANNEL_LENGTH; ri++) {
				var rx:Number = ri * rate;
				var ry:Number = (1 + power * bytes.readFloat()) * swing;
				if (ri != 0) {
					g.lineTo(rx, ry);
				}
				else {
					g.moveTo(rx, ry);
				}
			}
		}
	}
}
