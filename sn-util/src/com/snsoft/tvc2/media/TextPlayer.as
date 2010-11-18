package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.dataObject.TextOutDO;
	import com.snsoft.util.text.EffectText;
	import com.snsoft.tvc2.util.FrameTimer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 文本播放 
	 * @author Administrator
	 * 
	 */	
	public class TextPlayer extends Business{
		
		//声音列表 Sound 对象
		private var textField:TextField;
		
		//显示文字
		private var text:String;
		

		private var textOutDO:TextOutDO;
		
		
		public function TextPlayer(textOutDO:TextOutDO){
			super();
			this.text = text;
			this.textOutDO = textOutDO;
			 
			if(textOutDO != null){
				this.delayTime = textOutDO.timeOffset;
				this.timeLength = textOutDO.timeLength;
				this.timeOut = textOutDO.timeout;
			}
		}
		
		override protected function play():void{
			this.textField = EffectText.creatTextByStyleName(textOutDO.text,textOutDO.style);
			this.addChild(this.textField);
			this.dispatchEvent(new Event(EVENT_PLAYED));
			this.isPlayCmp = true;
			this.dispatchEventState();
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
					isDispatchEvent = true;
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
		}
		
	}
}