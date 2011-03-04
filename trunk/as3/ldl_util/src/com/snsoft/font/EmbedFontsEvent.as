package com.snsoft.font
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	public class EmbedFontsEvent extends Event {
		
		/**
		 * 加载字体文件出错 
		 */
		public static var IO_ERROR:String = IOErrorEvent.IO_ERROR;
		
		/**
		 * 加载字体文件中的字体出错 
		 */		
		public static var EMBED_FONTS_ERROR:String = "EmbedFontsError";
		
		public function EmbedFontsEvent(message:*="", id:*=0){
			super(message, id);
		}
		
	}
}