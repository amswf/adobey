package com.snsoft.tvc2.mediaEditer{
	import com.snsoft.util.text.TextStyle;
	import com.snsoft.util.text.TextStyles;
	import com.snsoft.util.HashVector;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MediaAttributes extends MovieClip{
		
		public static const ATTRIBUTES_CHANGE_EVENT:String = "ATTRIBUTES_CHANGE_EVENT";
		
		private var placeXTfd:TextField;
		
		private var placeYTfd:TextField;
		
		private var styleCBX:ComboBox;
		
		private var placeTypeXCBX:ComboBox;
		
		private var placeTypeYCBX:ComboBox;
		
		private var subBtn:Button;
		
		private var bakMC:MovieClip;
		
		private var _placeType:String;
		
		private var _place:Point;
		
		private var _style:String;
		
		private var _media:Media;
		
		public function MediaAttributes()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
		}
		
		private function handlerEnterFrame(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
			this.placeXTfd = this.getChildByName("placeX") as TextField;
			this.placeYTfd = this.getChildByName("placeY") as TextField;
			this.placeTypeXCBX = this.getChildByName("placeTypeX") as ComboBox;
			this.placeTypeYCBX = this.getChildByName("placeTypeY") as ComboBox;
			this.styleCBX = this.getChildByName("stl") as ComboBox;
			this.subBtn = this.getChildByName("sub") as Button;
			this.bakMC = this.getChildByName("bak") as MovieClip;
			
			this.subBtn.addEventListener(MouseEvent.CLICK,handlerClick);
			
			this.bakMC.addEventListener(MouseEvent.MOUSE_DOWN,handlerMouseDown);
			this.bakMC.addEventListener(MouseEvent.MOUSE_UP,handlerMouseUp);
			
			var textStyleHv:HashVector = TextStyles.getStyles();
			for(var i:int =0;i<textStyleHv.length;i++){
				var fontName:String = textStyleHv.findNameByIndex(i);
				styleCBX.addItem(creatComboBoxIterm(fontName,fontName));
			}
		}
		
		private function creatComboBoxIterm(name:String,value:String):Object {
			
			var obj:Object = new Object();
			
			obj.label = name;
			
			obj.data = value;
			
			return obj;
			
		}
		
		private function setComboBoxSelectedItemByData(cbx:ComboBox,data:String):void{
			for(var i:int =0;i<cbx.length;i++){
				var obj:Object = cbx.getItemAt(i) as Object;
				if(obj.data == data){
					cbx.selectedIndex = i;
					break;
				}
			}
		}
		
		
		public function setAttributes(media:Media,place:Point,placeType:String,style:String):void{
			this.media = media;
			this.place = place;
			this.placeType = placeType;
			this.style = style;
			
			this.placeXTfd.text = String(place.x);
			this.placeYTfd.text = String(place.y);
			
			
			setComboBoxSelectedItemByData(styleCBX,style);
			
			if(placeType != null){
				var valign:String = null;
				if(placeType.indexOf("t") >= 0){
					valign = "t";
				}
				else if(placeType.indexOf("m") >= 0){
					valign = "m";
				}
				else if(placeType.indexOf("b") >= 0){
					valign = "b";
				}
				
				if(valign != null){
					setComboBoxSelectedItemByData(placeTypeYCBX,valign);
				}
				
				var align:String = null;
				if(placeType.indexOf("l") >= 0){
					align = "l"; 
				}
				else if(placeType.indexOf("c") >= 0){
					align = "c";
				}
				else if(placeType.indexOf("r") >= 0){
					align = "r";
				}
				
				if(align != null){
					setComboBoxSelectedItemByData(placeTypeXCBX,align);
				}
				
			}
			
		}
		
		private function handlerMouseDown(e:Event):void {
			this.startDrag(false);
		}
		
		private function handlerMouseUp(e:Event):void {
			this.stopDrag();
		}
		
		private function handlerClick(e:Event):void{
			var tx:String = "";
			var ty:String = "";
			
			if(placeTypeXCBX.text != null){
				tx = placeTypeXCBX.value;
			}
			
			if(placeTypeYCBX.text != null){
				ty = placeTypeYCBX.value;
			}
			
			placeType = tx + ty;
			
			
			var px:Number = Number(placeXTfd.text);
			if(isNaN(px)){
				placeXTfd.text = "请正确输入数字";
			}
			else{
				place.x = px;
			}
			
			var py:Number = Number(placeYTfd.text);
			if(isNaN(py)){
				placeYTfd.text = "请正确输入数字";
			}
			else{
				place.y = py;
			}
			
			var ts:String = "";
			if(styleCBX.text != null){
				ts = styleCBX.text;
			}
			this.style = ts;
			
			this.dispatchEvent(new Event(ATTRIBUTES_CHANGE_EVENT));
		}

		public function get placeType():String
		{
			return _placeType;
		}

		public function set placeType(value:String):void
		{
			_placeType = value;
		}

		public function get place():Point
		{
			return _place;
		}

		public function set place(value:Point):void
		{
			_place = value;
		}

		public function get style():String
		{
			return _style;
		}

		public function set style(value:String):void
		{
			_style = value;
		}

		public function get media():Media
		{
			return _media;
		}

		public function set media(value:Media):void
		{
			_media = value;
		}


	}
}