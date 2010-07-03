package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.SystemConfig;
	import com.snsoft.tvc2.dataObject.MediaDO;
	import com.snsoft.tvc2.dataObject.MediasDO;
	import com.snsoft.tvc2.util.PlaceType;
	import com.snsoft.tvc2.util.StringUtil;
	
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
					mediaPlayer.addEventListener(Event.COMPLETE,handlerMediaPlayerCMP);
					
					mediaPlayer.x = mediaDO.place.x;
					mediaPlayer.y = mediaDO.place.y;
					
					var placeType:String = mediaDO.placeType;
					if(StringUtil.isEffective(placeType)){
						PlaceType.setSpritePlace(mediaPlayer,SystemConfig.stageSize,placeType);
					}
					this.addChild(mediaPlayer);
					this.dispatchEvent(new Event(EVENT_PLAYED));
				}
				else{
					this.isPlayCmp = true;
					this.dispatchEventState();
				}
			}
		}
		
		private function handlerMediaPlayerCMP(e:Event):void{
			playNum ++;
			playNextMedias();
		}
		
		override protected function dispatchEventState():void{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}