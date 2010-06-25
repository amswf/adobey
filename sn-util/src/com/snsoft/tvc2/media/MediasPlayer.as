package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.MediaDO;
	import com.snsoft.tvc2.dataObject.MediasDO;
	
	import flash.events.Event;
	
	public class MediasPlayer extends Business{
		
		private var mediasDO:MediasDO;
		
		//当前播放序号
		private var playNum:int;
		
		private var mediaPlayer:MediaPlayer;
		
		public function MediasPlayer(mediasDO:MediasDO){
			super();
			this.mediasDO = mediasDO;
		}
		
		/**
		 * 播放
		 * @return 
		 * 
		 */
		override protected function play():void{
			var mediaDOHv:Vector.<MediaDO> = mediasDO.mediaDOHv;
			playNum = 0;
			playNextMedias();
		}
		
		private function playNextMedias():void{
			if(mediasDO != null && mediasDO.mediaDOHv != null){
				if(playNum < mediasDO.mediaDOHv.length){
					if(mediaPlayer != null){
						this.removeChild(mediaPlayer);
					}
					var mediaDO:MediaDO = mediasDO.mediaDOHv[playNum];
					mediaPlayer = new MediaPlayer(mediaDO.mediaList,mediaDO.timeOffset,mediaDO.timeLength,mediaDO.timeout);
					mediaPlayer.addEventListener(Event.COMPLETE,handlerMp3PlayerCMP);
					this.addChild(mediaPlayer);
				}
				else{
					this.isPlayCmp = true;
					this.dispatchEventState();
				}
			}
		}
		
		private function handlerMp3PlayerCMP(e:Event):void{
			playNum ++;
			playNextMedias();
		}
		
		override protected function dispatchEventState():void{
			var sign:Boolean = false;
			if(this.isPlayCmp && this.isTimeLen){
				sign = true;
			}
			else if(this.isTimeOut){
				sign = true;
			}
			
			if(sign){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}