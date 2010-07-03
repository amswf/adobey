package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.SystemConfig;
	import com.snsoft.tvc2.dataObject.TextOutDO;
	import com.snsoft.tvc2.dataObject.TextOutsDO;
	import com.snsoft.tvc2.util.PlaceType;
	import com.snsoft.tvc2.util.StringUtil;
	
	import flash.events.Event;
	import flash.text.TextFormat;
	
	public class TextsPlayer extends Business{
		
		private var textOutsDO:TextOutsDO;
		
		//当前播放序号
		private var playNum:int;
		
		private var textPlayer:TextPlayer;
		
		public function TextsPlayer(textOutsDO:TextOutsDO){
			super();
			this.textOutsDO = textOutsDO;
		}
		
		/**
		 * 播放
		 * @return 
		 * 
		 */
		override protected function play():void{
			playNum = 0;
			playNextMp3s();
		}
		
		private function playNextMp3s():void{
			
			if(textOutsDO != null && textOutsDO.textOutDOHv != null){
				if(playNum < textOutsDO.textOutDOHv.length){
					if(textPlayer != null){
						this.removeChild(textPlayer);
					}
					var textOutDO:TextOutDO = textOutsDO.textOutDOHv[playNum];
					textPlayer = new TextPlayer(textOutDO);
					var placeType:String = textOutDO.placeType;
					if(StringUtil.isEffective(placeType)){
						PlaceType.setSpritePlace(textPlayer,SystemConfig.stageSize,placeType);
					}
					textPlayer.x = textOutDO.place.x;
					textPlayer.y = textOutDO.place.y;
					textPlayer.addEventListener(Event.COMPLETE,handlerTextsPlayerCMP);
					this.addChild(textPlayer);
				}
				else{
					this.isPlayCmp = true;
					this.dispatchEventState();
				}
			}
		}
		
		private function handlerTextsPlayerCMP(e:Event):void{
			playNum ++;
			playNextMp3s();
		}
		
		override protected function dispatchEventState():void{ 
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}