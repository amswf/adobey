package com.snsoft.map
{
	import fl.controls.Button;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class AreaAttribute extends MovieClip
	{
		private var _areaNameTextField:TextField = null;
		
		private var _areaNameXTextField:TextField = null;
		
		private var _areaNameYTextField:TextField = null;
		
		private var _btn:Button = null;
		
		public static const SUBMIT_EVENT:String = "SUBMIT_EVENT";
		
		public function AreaAttribute()
		{
			super();
			_areaNameTextField = this.getChildByName("areaNameTextField") as TextField;
			_areaNameXTextField = this.getChildByName("areaNameXTextField") as TextField;
			_areaNameYTextField = this.getChildByName("areaNameYTextField") as TextField;
			_btn = this.getChildByName("btn") as Button;
			
			this._btn.addEventListener(MouseEvent.CLICK,handlerMouseClick);
		}
		
		private function handlerMouseClick(e:Event):void{
			this.dispatchEvent(new Event(SUBMIT_EVENT));
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

		public function getBtn():Button
		{
			return _btn;
		}

	}
}