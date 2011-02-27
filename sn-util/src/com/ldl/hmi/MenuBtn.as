package com.ldl.hmi{
	import com.snsoft.font.EmbedFonts;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public class MenuBtn extends MovieClip{
		
		public function MenuBtn(){
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		/**
		 * 事件	播放帧事件
		 * @param e
		 * 
		 */		
		private function handlerEnterFrame(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			
			setTextColor(0x000000,10,false);
			this.addEventListener(MouseEvent.MOUSE_OVER,handlerMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,handlerMouseOut);
		}
		
		public function setText(cText:String, eText:String):void{
			ctfd.text = cText;
			etfd.text = eText;
		}
		
		private function handlerMouseOver(e:Event):void{
			mmmdmc.alpha = 1;
			var tft:TextFormat = ctfd.getTextFormat();
			setTextColor(0xffffff,11,true);
		}
		
		
		private function handlerMouseOut(e:Event):void{
			mmmdmc.alpha = 0;
			setTextColor(0x000000,10,false);
		}
		
		private function setTextColor(color:uint,size:int,isDsf:Boolean):void{
			var filters:Array = new Array();
			if(isDsf){
				var dsf:DropShadowFilter = new DropShadowFilter(2,45,0x000000,1,3,3,1,3);
				filters.push(dsf);
			}
			setTextField(ctfd,size,color,isDsf);
			setTextField(etfd,size-1,color,isDsf);
		}
		
		private function setTextField(textField:TextField, size:int, color:uint, isDsf:Boolean):void{
			var filters:Array = new Array();
			if(isDsf){
				var dsf:DropShadowFilter = new DropShadowFilter(2,45,0x000000,1,3,3,1,3);
				filters.push(dsf);
			}
			
			var ctft:TextFormat = ctfd.getTextFormat();
			ctft.font = EmbedFonts.findFontByName("FZHeiB01S");
			ctft.color = color;
			ctft.size = size;
			textField.embedFonts = true;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.gridFitType = GridFitType.PIXEL;
			textField.setTextFormat(ctft);
			textField.filters = filters;
		}
		
		private function get ctfd():TextField{
			return this.getChildByName("cText") as TextField;
		}
		
		private function get etfd():TextField{
			return this.getChildByName("eText") as TextField;
		}
		
		private function get mmmdmc():MovieClip{
			return this.getChildByName("mmmd") as MovieClip;
		}
	}
}