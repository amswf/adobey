package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.TextOutDO;
	import com.snsoft.tvc2.dataObject.TextOutsDO;
	
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
					var tft:TextFormat = new TextFormat();//需要实现此文本格式对象
					textPlayer = new TextPlayer(textOutDO.text,tft,textOutDO.timeOffset,textOutDO.timeLength,textOutDO.timeout);
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