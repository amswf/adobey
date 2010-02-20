package com.snsoft.map
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class AreaAttribute extends MovieClip
	{
		private var _areaNameTextField:TextField = null;
		
		private var _areaNameXTextField:TextField = null;
		
		private var _areaNameYTextField:TextField = null;
		
		public function AreaAttribute()
		{
			super();
			
			_areaNameTextField = this.getChildByName("areaNameTextField") as TextField;
			_areaNameXTextField = this.getChildByName("areaNameXTextField") as TextField;
			_areaNameYTextField = this.getChildByName("areaNameYTextField") as TextField;
		}
		
		public function setareaName(name:String):void{
			this._areaNameTextField.text = name;
		}
		
		public function getareaName():String{
			return this._areaNameTextField.text;
		}
		
		public function setareaNameX(x:String):void{
			this._areaNameXTextField.text = x;
		}
		
		public function getareaNameX():String{
			return this._areaNameXTextField.text;
		}
		
		public function setareaNameY(y:String):void{
			this._areaNameYTextField.text = y;
		}
		
		public function getareaNameY():String{
			return this._areaNameYTextField.text;
		}
	}
}