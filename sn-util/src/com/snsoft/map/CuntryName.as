package com.snsoft.map
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	 
	
	public class CuntryName extends MovieClip
	{
		private var _lableText:String = "";
		
		private var _msk:MovieClip = null;
		
		private var _lableName:TextField = null;
		
		public function CuntryName(lableText:String = "")
		{
			super();
			_lableName = this.getChildByName("lableName") as TextField;
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
			_lableText = value;
		}

	}
}