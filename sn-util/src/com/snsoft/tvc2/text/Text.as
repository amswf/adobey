package com.snsoft.tvc2.text{
	import com.snsoft.font.EmbedFonts;
	import com.snsoft.util.TextFieldUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	public class Text{
		public function Text(){
		}
		
		public static function setTextField(tfd:TextField,text:String,textFormat:TextFormat,isEmbedFont:Boolean = false):void{
			tfd.text = text;
			if(isEmbedFont){
				var embedFontName:String = EmbedFonts.findFontByName(textFormat.font);
				if(embedFontName != null && embedFontName.length > 0){
					textFormat.font = embedFontName;
				}
				tfd.embedFonts = true;
			}
			tfd.selectable = false;
			tfd.setTextFormat(textFormat);
			TextFieldUtil.fitSize(tfd);
			tfd.addEventListener(Event.ADDED_TO_STAGE,handler);
			
			function handler(e:Event):void{
				var tfde:TextField = e.currentTarget as TextField;
				var tft:TextFormat = textFormat;
				tft.color = tft.color;
				tft.size = tft.size;
				tfde.setTextFormat(tft);
			}
		}
		
		public static function creatTextField(text:String,textFormat:TextFormat,isEmbedFont:Boolean = false):TextField{
			var tfd:TextField = new TextField();
			setTextField(tfd,text,textFormat,isEmbedFont);
			return tfd;
		}
		
	}
}