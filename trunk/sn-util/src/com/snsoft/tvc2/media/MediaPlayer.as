package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.util.FrameTimer;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MediaPlayer extends Sprite{
		
		private var playingMedia:DisplayObject;
		
		//声音列表 Sound 对象
		private var _mediaList:Vector.<DisplayObject>;
		
		//当前播放序号
		private var playNum:int;
		
		//开始播放时间
		private var delayTime:Number;
		
		//最小播放时长
		private var timeLength:Number;
		
		//最大播放时长
		private var timeOut:Number;
		
		//是否全部播完
		private var isPlayCmp:Boolean;
		
		//是否播放了最小播放时间
		private var isTimeLen:Boolean;
		
		//是否超时
		private var isTimeOut:Boolean;
		
		//延时计时
		private var delayFrameTimer:FrameTimer;
		
		//最小播放计时
		private var timeLengthFrameTimer:FrameTimer;
		
		//超时计时
		private var timeOutFrameTimer:FrameTimer;
		
		public function MediaPlayer(mediaList:Vector.<DisplayObject>,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			this._mediaList = mediaList;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.playNum = 0;
			this.addEventListener(Event.ADDED_TO_STAGE,handlerAddedToStage);
			super();
		}
		
		/**
		 * 事件
		 * @param e
		 * 
		 */		
		private function handlerAddedToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,handlerAddedToStage);
			delayFrameTimer = new FrameTimer(this.stage.frameRate,this.delayTime,this);
			delayFrameTimer.timer();
			delayFrameTimer.addEventListener(Event.COMPLETE,handlerDelayFrameTimer);
		}
		
		private function handlerDelayFrameTimer(e:Event):void{
			delayFrameTimer.removeEventListener(Event.COMPLETE,handlerDelayFrameTimer);
			
			if(this.timeLength > 0){
				timeLengthFrameTimer = new FrameTimer(this.stage.frameRate,this.timeLength,this);
				timeLengthFrameTimer.timer();
				timeLengthFrameTimer.addEventListener(Event.COMPLETE,handlerTimeLength);
			}
			else{
				this.isTimeLen = true;
			}
			
			if(this.timeOut > 0){
				timeOutFrameTimer = new FrameTimer(this.stage.frameRate,this.timeOut,this);
				timeOutFrameTimer.timer();
				timeOutFrameTimer.addEventListener(Event.COMPLETE,handlerTimeOut);
			}
			this.play(this.playNum);
		}
		
		/**
		 * 播放
		 * @return 
		 * 
		 */
		private function play(playNum:int):void{
			
			if(this.mediaList != null ){
				if(playNum < this.mediaList.length){
					if(playingMedia != null){
						this.removeChild(playingMedia);
					}
					playingMedia = this.mediaList[playNum];
					this.addChild(playingMedia);
					if(playingMedia is MovieClip){
						var mc:MovieClip = playingMedia as MovieClip;
						mc.play();
						playingMedia.addEventListener(Event.EXIT_FRAME,handlerMovieClipPlayExitFrame);
					}
					else if(playingMedia is Bitmap){
						var ft:FrameTimer = new FrameTimer(this.stage.frameRate,1000,this);
						ft.timer();
						ft.addEventListener(Event.COMPLETE,handlerBitmapPlayComplete);
					}
				}
				else if(playNum >= this.mediaList.length){
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
			this.play(this.playNum);
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
				this.play(this.playNum);
			}
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerTimeLength(e:Event):void{
			timeLengthFrameTimer.removeEventListener(Event.COMPLETE,handlerTimeLength);
			this.isTimeLen = true;
			this.dispatchEventState();
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerTimeOut(e:Event):void{
			timeOutFrameTimer.removeEventListener(Event.COMPLETE,handlerTimeOut);
			this.isTimeOut = true;
			this.dispatchEventState();
		}
		
		/**
		 * 
		 * 
		 */		
		private function dispatchEventState():void{
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
				this.dispatchEvent(new Event(Event.COMPLETE));
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