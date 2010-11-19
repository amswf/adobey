package test{	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	public class StarGame extends Sprite{
		
		private var mouseStar:MovieClip
		
		public function StarGame()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			mouseStar = createSkinByName("MouseStar_skin");
			mouseStar.y = 200;
			mouseStar.startDrag(true,new Rectangle(0,200,stage.stageWidth,0));
			
			this.addChild(mouseStar);
			
			var timer:Timer = new Timer(500,0);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,handlerTimer);
		}
		
		
		private function handlerTimer(e:Event):void{
			var star:MovieClip = creatStar();
			star.y = stage.stageHeight - star.height;
			star.x = Math.random() * stage.stageWidth;
			this.addChild(star);
			star.addEventListener(Event.ENTER_FRAME,handlerStarEnterFrame);
		}
		
		private function handlerStarEnterFrame(e:Event):void{
			
			var star:MovieClip = e.currentTarget as MovieClip;
			star.y -= 1;
			 
			if(star.hitTestObject(mouseStar) || star.y < - star.height){
				star.removeEventListener(Event.ENTER_FRAME,handlerStarEnterFrame);
				this.removeChild(star);
			}
		}
		
		private function creatStar():MovieClip{
			var i:int = int(Math.random() * 3);
			var star:MovieClip = null;
			if(i == 0){
				star = createSkinByName("YelloStar_skin");
			}
			else if(i == 1){
				star = createSkinByName("BlackStar_skin");
			}
			else if(i == 2){
				star = createSkinByName("BlueStar_skin");
			}
			return star;
		}
		
		
		/**
		 * 加载皮肤 
		 * @param skinName
		 * @return 
		 * 
		 */		
		private function createSkinByName(skinName:String):MovieClip {
			var main:MovieClip = new MovieClip();
			var mc:MovieClip;
			try {
				var MClass:Class = getDefinitionByName(skinName) as Class;
				mc = new MClass() as MovieClip;
			} catch (e:Error) {
				trace(" error SkinsUtil.createSkinByName() 动态加载找不到类：" +skinName);
			}
			return mc;
		}
	}
}