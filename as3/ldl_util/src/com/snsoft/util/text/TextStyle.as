package com.snsoft.util.text{
	import flash.text.TextFormat;
	
	/**
	 * 文本样式 
	 * @author Administrator
	 * 
	 */	
	public class TextStyle{
		
		//文字格式
		private var _textFormat:TextFormat;
		
		//内阴影颜色
		private var _inSColor:uint;
		
		//外阴影颜色
		private var _outSColor:uint;
		
		//是否加载字体
		private var _isEmbedFont:Boolean;
		
		//坐标 x
		private var _x:Number = 0;
		
		//坐标 y
		private var _y:Number = 0;
		
		public function TextStyle(font:String,
								  size:uint,
								  color:uint,
								  inSColor:uint = 0xffffff,
								  outSColor:uint = 0x000000,
								  isEmbedFont:Boolean = false,
								  x:Number = 0,
								  y:Number = 0){
			
			this.textFormat = new TextFormat(font,size,color);
			this.inSColor = inSColor;
			this.outSColor = outSColor;
			this.isEmbedFont = isEmbedFont;
			this.x = x;
			this.y = y;
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
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		
		
		
	}
}