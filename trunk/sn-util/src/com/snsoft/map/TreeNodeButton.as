package com.snsoft.map
{
	
	import com.snsoft.util.TextFieldUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	public class TreeNodeButton extends MovieClip
	{
		private var _lableText:String = "";
		
		private var _msk:MovieClip = null;
		
		private var _lableName:TextField = null;
		
		public function TreeNodeButton(lableText:String = "")
		{
			super();
			_lableName = this.getChildByName("lableName") as TextField;
			_lableName.autoSize = TextFieldAutoSize.LEFT;
			_msk = this.getChildByName("msk") as MovieClip;
			this.lableText = lableText;
		}
		
		public function get lableText():String
		{
			return _lableText;
		}
		
		public function set lableText(value:String):void
		{
			if(value == null){
				value = "";
			}
			this._lableName.text = value;
			var w:Number = TextFieldUtil.calculateTextFieldWidth(this._lableName);
			this._lableName.width = w;
			this._msk.width = w + this._lableName.x;
			_lableText = value;
		}
		
	}
}