package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.SystemConfig;
	import com.snsoft.tvc2.util.FrameTimer;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MediaPlayer extends Business{
		
		private var playingMedia:DisplayObject;
		
		//声音列表 Sound 对象
		private var _mediaList:Vector.<DisplayObject>;
		
		//当前播放序号
		private var playNum:int;
		
		
		
		public function MediaPlayer(mediaList:Vector.<DisplayObject>,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this._mediaList = mediaList;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.playNum = 0;
		}
		
		
		
		/**
		 * 播放
		 * @return 
		 * 
		 */
		override protected function play():void{
			
			if(this.mediaList != null ){
				if(this.playNum < this.mediaList.length){
					if(playingMedia != null){
						this.removeChild(playingMedia);
					}
					playingMedia = this.mediaList[this.playNum];
					this.addChild(playingMedia);
					if(playingMedia is MovieClip){
						var mc:MovieClip = playingMedia as MovieClip;
						mc.play();
						playingMedia.addEventListener(Event.EXIT_FRAME,handlerMovieClipPlayExitFrame);
					}
					else if(playingMedia is Bitmap){
						var ft:FrameTimer = new FrameTimer(SystemConfig.stageFrameRate,1000,this);
						ft.timer();
						ft.addEventListener(Event.COMPLETE,handlerBitmapPlayComplete);
					}
				}
				else if(this.playNum >= this.mediaList.length){
					this.isPlayCmp = true;
					this.dispatchEventState();
				}
			}
		}
		
		/**
		 * 事件 
		 * @param e
		 * 
		 */		
		private function handlerBitmapPlayComplete(e:Event):void{
			var ft:FrameTimer = e.currentTarget as FrameTimer;
			ft.removeEventListener(Event.COMPLETE,handlerBitmapPlayComplete);
			this.playNum ++;
			this.play();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerMovieClipPlayExitFrame(e:Event):void{
			var mc:MovieClip = playingMedia as MovieClip;
			if(mc.currentFrame >= mc.totalFrames){
				playingMedia.removeEventListener(Event.EXIT_FRAME,handlerMovieClipPlayExitFrame);
				this.playNum ++;
				this.play();
			}
		}
		
		
		
		/**
		 * 
		 * 
		 */		
		override protected function dispatchEventState():void{
			if(!isDispatchEvent){
				var sign:Boolean = false;
				if(this.isPlayCmp && this.isTimeLen){
					sign = true;
				}
				else if(this.isTimeOut){
					sign = true;
				}
				
				if(sign){
					if(playingMedia is MovieClip){
						var mc:MovieClip = playingMedia as MovieClip;
						mc.soundTransform.volume = 0;
						mc.stop();
					}
					isDispatchEvent = true;
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get mediaList():Vector.<DisplayObject>{
			return _mediaList;
		}
	}
}