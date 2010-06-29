package com.snsoft.tvc2.text{
	import flash.text.TextFormat;
	
	public class TextStyle{
		
		//文字格式
		private var _textFormat:TextFormat;
			
		//内阴影颜色
		private var _inSColor:uint;
		
		//外阴影颜色
		private var _outSColor:uint;
		
		//是否加载字体
		private var _isEmbedFont:Boolean;
		
		public function TextStyle(font:String,size:uint,color:uint,inSColor:uint = 0xffffff,outSColor:uint = 0x000000,isEmbedFont:Boolean = false){
			this.textFormat = new TextFormat(font,size,color);
			this.inSColor = inSColor;
			this.outSColor = outSColor;
			this.isEmbedFont = isEmbedFont;
		}

		public function get inSColor():uint
		{
			return _inSColor;
		}

		public function set inSColor(value:uint):void
		{
			_inSColor = value;
		}

		public function get outSColor():uint
		{
			return _outSColor;
		}

		public function set outSColor(value:uint):void
		{
			_outSColor = value;
		}

		public function get isEmbedFont():Boolean
		{
			return _isEmbedFont;
		}

		public function set isEmbedFont(value:Boolean):void
		{
			_isEmbedFont = value;
		}

		public function get textFormat():TextFormat
		{
			return _textFormat;
		}

		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
		}

		 


	}
}