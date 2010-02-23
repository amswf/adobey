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
		
		private var _submitBtn:Button = null;
		
		private var _deleteBtn:Button = null;
		
		public static const SUBMIT_EVENT:String = "SUBMIT_EVENT";
		
		public static const DELETE_EVENT:String = "DELETE_EVENT";
		
		public function AreaAttribute()
		{
			super();
			_areaNameTextField = this.getChildByName("areaNameTextField") as TextField;
			_areaNameXTextField = this.getChildByName("areaNameXTextField") as TextField;
			_areaNameYTextField = this.getChildByName("areaNameYTextField") as TextField;
			_submitBtn = this.getChildByName("submitBtn") as Button;
			_deleteBtn = this.getChildByName("deleteBtn") as Button;
			
			this._submitBtn.addEventListener(MouseEvent.CLICK,handlerSubmitMouseClick);
			this._deleteBtn.addEventListener(MouseEvent.CLICK,handlerdeleteMouseClick);
		}
		
		private function handlerdeleteMouseClick(e:Event):void{
			this.dispatchEvent(new Event(DELETE_EVENT));
		}
		
		private function handlerSubmitMouseClick(e:Event):void{
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
	}
}