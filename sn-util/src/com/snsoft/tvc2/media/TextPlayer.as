package com.snsoft.tvc2.media{
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.util.FrameTimer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextPlayer extends Business{
		
		//声音列表 Sound 对象
		private var textField:TextField;
		
		//显示文字
		private var text:String;
		
		//文字格式
		private var textFormat:TextFormat;
		
		
		public function TextPlayer(text:String,textFormat:TextFormat,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this.text = text;
			this.textFormat = textFormat;
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			trace(timeLength,timeOut);
			
		}
		
		override protected function play():void{
			this.textField = new TextField();
			if(this.textFormat != null){
				this.textField.setTextFormat(this.textFormat);
			}
			this.textField.text = this.text;
			this.addChild(this.textField);
			
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function dispatchEventState():void{
			var sign:Boolean = false;
			if(this.isTimeLen){
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