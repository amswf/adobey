package com.snsoft.tvc2.text{
	import com.snsoft.font.EmbedFonts;
	import com.snsoft.util.TextFieldUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	/**
	 * 文本
	 * 创建带样式文本 
	 * @author Administrator
	 * 
	 */	
	public class Text{
		public function Text(){
		}
		
		/**
		 * 设置格式文本 
		 * @param tfd 文本对象
		 * @param text 文本文字
		 * @param textFormat 格式对象
		 * @param isEmbedFont 是否使用嵌入字体
		 * 
		 */		
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
		
		/**
		 * 创建格式文本 
		 * @param text 文本文字
		 * @param textFormat 格式对象
		 * @param isEmbedFont 是否使用嵌入字体
		 * @return 
		 * 
		 */		
		public static function creatTextField(text:String,textFormat:TextFormat,isEmbedFont:Boolean = false):TextField{
			var tfd:TextField = new TextField();
			setTextField(tfd,text,textFormat,isEmbedFont);
			return tfd;
		}
		
	}
}