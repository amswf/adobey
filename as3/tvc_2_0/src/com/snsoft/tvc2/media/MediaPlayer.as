package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.SystemConfig;
	import com.snsoft.tvc2.util.FrameTimer;
	import com.snsoft.util.SpriteUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.SoundTransform;
	
	/**
	 * 多媒体（图片、动画）播放 
	 * @author Administrator
	 * 
	 */	
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
		
		override protected function play():void{
			this.addEventListener(Event.REMOVED_FROM_STAGE,handlerRemove);
			playNext();
		}
		
		private function handlerRemove(e:Event):void{
			isRemoved = true;
			stopTimer();
			SpriteUtil.deleteAllChild(this);
		}
		
		/**
		 * 播放
		 * @return 
		 * 
		 */
		private function playNext():void{
			
			if(this.mediaList != null && !isRemoved){
				if(this.playNum < this.mediaList.length){
					if(playingMedia != null){
						this.removeChild(playingMedia);
					}
					playingMedia = this.mediaList[this.playNum];
					this.addChild(playingMedia);
					this.dispatchEvent(new Event(EVENT_PLAYED));
					if(playingMedia is MovieClip){
						var mc:MovieClip = playingMedia as MovieClip;
						mc.addEventListener(Event.REMOVED_FROM_STAGE,handlerSwfRemove);
						mc.gotoAndStop(1);
						mc.play();
						mc.addEventListener(Event.EXIT_FRAME,handlerMovieClipPlayExitFrame);
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
		
		private function handlerSwfRemove(e:Event):void{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.stop();
			var stf:SoundTransform = mc.soundTransform;
			stf.volume = 0;
			mc.soundTransform = stf;
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
			this.playNext();
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
				this.playNext();
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