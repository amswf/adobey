package com.snsoft.tvc2.mediaEditer{
	import com.snsoft.font.EmbedFonts;
	import com.snsoft.font.EmbedFontsEvent;
	import com.snsoft.tvc2.Business;
	import com.snsoft.tvc2.SystemConfig;
	import com.snsoft.tvc2.text.EffectText;
	import com.snsoft.tvc2.text.TextStyle;
	import com.snsoft.tvc2.text.TextStyles;
	import com.snsoft.tvc2.util.PlaceType;
	import com.snsoft.tvc2.util.StringUtil;
	import com.snsoft.tvc2.xml.XMLParse;
	import com.snsoft.util.HashVector;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.fscommand;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Main extends MovieClip{
		
		private var styleXmlUrl:String = "tvc.text.style.xml";
		
		private var mediaAttributes:MediaAttributes;
		
		public function Main()
		{
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
		}
		
		private function handlerEnterFrame(e:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			loadStylesXML();
		}
		
		private function loadStylesXML():void{
			if(styleXmlUrl != null){				
				var req:URLRequest = new URLRequest(styleXmlUrl);
				var loader:URLLoader = new URLLoader();
				loader.load(req);
				loader.addEventListener(Event.COMPLETE,handlerLoadStyleCmp);
			}
		}
		
		private function handlerLoadStyleCmp(e:Event):void{
			var loader:URLLoader = e.currentTarget as URLLoader;
			var xml:XML = new XML(loader.data);
			var parse:XMLParse = new XMLParse();
			var hv:HashVector = parse.parseStyles(xml);
			var fontNameV:Vector.<String> = new Vector.<String>();
			var fontNameHv:HashVector = new HashVector();
			for(var i:int =0;i<hv.length;i++){
				var name:String = hv.findNameByIndex(i);
				var textStyle:TextStyle = hv.findByIndex(i) as TextStyle;
				TextStyles.pushTextStyle(name,textStyle);
				var textFormat:TextFormat = textStyle.textFormat;
				if(textFormat != null){
					var font:String = textFormat.font;
					if(StringUtil.isEffective(font)){
						fontNameHv.push(font,font);
					}
				}
			}
			for(var i2:int =0;i2<fontNameHv.length;i2++){
				fontNameV.push(fontNameHv.findByIndex(i2) as String);
			}
			loadEmbedFonts(fontNameV);
		}
		
		private function loadEmbedFonts(fontNameV:Vector.<String>):void{
			if(fontNameV != null && fontNameV.length > 0){
				var ef:EmbedFonts = new EmbedFonts();
				for(var i:int =0;i<fontNameV.length;i++){
					ef.addFontName(fontNameV[i]);
				}
				ef.loadFontSwf();
				ef.addEventListener(Event.COMPLETE,handlerEmbedFontsCmp);
				ef.addEventListener(EmbedFontsEvent.IO_ERROR,handlerIOError);
			}
		}
		
		private function handlerIOError(e:EmbedFontsEvent):void{
			trace("ioerror");
		}
		
		private function handlerEmbedFontsCmp(e:Event):void{
			mediaAttributes = new MediaAttributes();
			this.addChild(mediaAttributes);
			mediaAttributes.addEventListener(MediaAttributes.ATTRIBUTES_CHANGE_EVENT,handlerAttributeChange);
			
			this.addEffectText("哈哈哈",0,0,"mc","mainTitle");
			
			
			initComplete();
			
		}
		
		private function initComplete():void {
			try {
				trace("fscommand(\"initComplete\")");
				fscommand("initComplete");
			} catch (e:Error) {
				
			}
			try {
				ExternalInterface.addCallback("addEffectText",addEffectText);
			} catch (e:Error) {
				
			}
		}
		
		private function callBackMediaAttribute():void{
			var media:Media = mediaAttributes.media
			if(media != null){
				var style:String = "<style name=\""+media.style+"\" placeType=\""+media.placeType+"\" x=\""+media.x+"\" y=\""+media.y+"\" />";
				try {
					trace("fscommand(\"callBackMediaAttribute\")",style);
					fscommand("callBackMediaAttribute",style);
				} catch (e:Error) {
					
				}
			}
		}
		
		private function handlerAttributeChange(e:Event):void{
			var media:Media = mediaAttributes.media;
			media.style = mediaAttributes.style;
			media.placeType = mediaAttributes.placeType;			
			media.drawNow();
			
			media.x = mediaAttributes.place.x;
			media.y = mediaAttributes.place.y;
			
			var rect:Rectangle = media.tfd.getRect(media);
			PlaceType.setSpritePlaceByRect(media,rect,SystemConfig.stageSize,mediaAttributes.placeType);
			callBackMediaAttribute();
		}
		
		private function addEffectText(text:String,x:Number,y:Number,placeType:String,style:String):void {
			var tfd:TextField = EffectText.creatTextByStyleName(text,style);
			tfd.name = text;
			var media:Media = new Media(text,placeType,style);
			this.addChild(media);
			media.drawNow();
			
			media.x = x;
			media.y = y;
			PlaceType.setSpritePlaceByRect(media,media.getRect(this),SystemConfig.stageSize,placeType);
			media.mouseEnabled = true;
			media.buttonMode = true;
			media.mouseChildren = false;
			media.addChild(tfd);
			this.addChild(media);
			
			media.addEventListener(MouseEvent.MOUSE_DOWN,handlerMouseDown);
			media.addEventListener(MouseEvent.MOUSE_UP,handlerMouseUp);
			media.addEventListener(MouseEvent.CLICK,handlerClick);
		}
		
		private function handlerClick(e:Event):void {
			var media:Media = e.currentTarget as Media;
			var rect:Rectangle = media.getRect(this);
			var place:Point = new Point(media.x,media.y);
			place.x = rect.x - media.tfd.x;
			place.y = rect.y - media.tfd.y;
			this.mediaAttributes.setAttributes(media,place,media.placeType,media.style);
			
			callBackMediaAttribute();
		}
		
		private function handlerMouseDown(e:Event):void {
			var sprite:Media = e.currentTarget as Media;
			sprite.startDrag(false);
		}
		
		private function handlerMouseUp(e:Event):void {
			var sprite:Media = e.currentTarget as Media;
			sprite.stopDrag();
			var rect:Rectangle = sprite.getRect(this);
			sprite.x = rect.x - sprite.tfd.x;
			sprite.y = rect.y - sprite.tfd.y;
			
		}
	}
}