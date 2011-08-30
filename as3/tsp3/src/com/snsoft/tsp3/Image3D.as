package com.snsoft.tsp3 {
	import com.snsoft.util.rlm.ResLoadManager;
	import com.snsoft.util.rlm.rs.RSImages;

	import fl.transitions.Tween;
	import fl.transitions.easing.Regular;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Vector3D;

	public class Image3D extends MovieClip {

		var rsi:RSImages = new RSImages();

		public function Image3D() {
			init();
		}

		private function init():void {

			rsi.addResUrl("a.jpg");

			var rlm:ResLoadManager = new ResLoadManager();
			rlm.addEventListener(Event.COMPLETE, handlerRLMCmp);
			rlm.addResSet(rsi);
			rlm.load();
		}

		private function handlerRLMCmp(e:Event) {

			var mc:MovieClip = new MovieClip();
			mc.x = 100;
			mc.y = 0;
			this.addChild(mc);

			var bmd:BitmapData = rsi.getImageByUrl("a.jpg");
			var bm:Bitmap = new Bitmap(bmd, "auto", true);
			mc.addChild(bm);
			bm.z = 0;
			bm.transform.matrix3D.position = new Vector3D(0, 0, 0, 0);
			
			
			var tween:Tween = new Tween(bm,"rotationY",Regular.easeInOut,90,0,1,true);
			tween.start();
			var tween2:Tween = new Tween(bm,"x",Regular.easeInOut,600,0,1,true);
			tween2.start();
			var tween3:Tween = new Tween(bm,"z",Regular.easeInOut,300,0,1,true);
			tween3.start();
			
//			var tween:Tween = new Tween(bm,"rotationY",Regular.easeInOut,0,90,1,true);
//			tween.start();
//			var tween2:Tween = new Tween(bm,"x",Regular.easeInOut,0,600,1,true);
//			tween2.start();
//			var tween3:Tween = new Tween(bm,"z",Regular.easeInOut,0,300,1,true);
//			tween3.start();
			//bm.transform.matrix3D.prependRotation(45, new Vector3D(0, 1, 0, 0), new Vector3D(bmd.width / 2, bmd.height / 2, 0, 0));
		}
	}
}
