package com.snsoft.map.tree
{
	
	import com.snsoft.util.TextFieldUtil;
	
	import fl.controls.Button;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	public class TreeNodeButton extends MovieClip
	{
		private var _lableText:String = "";
		
		private var _msk:MovieClip = null;
		
		private var _lableName:TextField = null;
		
		private var _imageBtn:Sprite = null;
		
		public static const TREE_CLICK:String = "TREE_CLICK";
		
		public static const SUB_TREE_VIEW:String = "SUB_TREE_VIEW";
		
		public function TreeNodeButton(lableText:String = "")
		{
			super();
			_lableName = this.getChildByName("lableName") as TextField;
			_lableName.autoSize = TextFieldAutoSize.LEFT;
			_msk = this.getChildByName("msk") as MovieClip;
			this.lableText = lableText;
			this._msk.addEventListener(MouseEvent.CLICK,handlerMskMouseClick); 
			this._msk.addEventListener(MouseEvent.MOUSE_OVER,handlerMskMouseOver); 
			this._msk.addEventListener(MouseEvent.MOUSE_OUT,handlerMskMouseOut); 
			this._msk.buttonMode = true;
			this._msk.mouseChildren = false;
			this._msk.mouseEnabled = true;
		}
		
		private function handlerMskMouseOver(e:Event):void{
			this._msk.alpha = 1;
		}
		
		private function handlerMskMouseOut(e:Event):void{
			this._msk.alpha = 0;
		}
		
		private function handlerMskMouseClick(e:Event):void{
			this.dispatchEvent(new Event(TREE_CLICK));
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
			this._msk.width = w ;
			_lableText = value;
		}
		
	}
}