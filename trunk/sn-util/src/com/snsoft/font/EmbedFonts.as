package com.snsoft.font{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.Font;

	/**
	 *  例子：
	   	import com.snsoft.font.EmbedFonts;
		import com.snsoft.font.EmbedFontsEvent;
		
		var ef:EmbedFonts = new EmbedFonts("SimHei","STXihei","YouYuan","MicrosoftYaHei","asd");
		ef.loadFontSwf();
		ef.addEventListener(Event.COMPLETE,handler);
		ef.addEventListener(EmbedFontsEvent.IO_ERROR,handlerIOError);
		 
		function handler(e:Event){
			
			var tf = new TextFormat(EmbedFonts.findFontByName("MicrosoftYaHei"),40,0x000000);
			var tx:TextField=new TextField();
			tx.embedFonts = true;
			tx.antiAliasType = AntiAliasType.ADVANCED;
			tx.gridFitType = GridFitType.PIXEL;
			tx.text = "你好";
			tx.setTextFormat(tf);
			addChild(tx);
		}
		
		function handlerIOError(e:EmbedFontsEvent):void{
			trace("ioerror");
		}
	 */

	/**
	 * 嵌入字体
	 * 
	 * 
	 * 字体名称 同字体所在的swf文件，及swf文件里定义的字体的link是相同的。
	 * 
	 * @author Administrator
	 * 
	 */
	public class EmbedFonts extends EventDispatcher {

		private static var SWF_EXT_NAME = ".swf";

		private static var SWF_FONT_ROOT_PATH = "font/";
		
		/**
		 * 加载字体swf文件得到的结果信息列表 LoaderInfo 数组
		 */		
		private var domainAry:Array = new Array();

		/**
		 * 字体文件列表 
		 */
		private var _fontNameAry:Array = new Array();
		
		
		/**
		 * 字体文件中第一个字体标识名称
		 */		
		private static var fontEnNameAry:Array = new Array();

		/**
		 * 已经load完成的字体个数 
		 */
		private var loadCmpFontNum:int = 0;


		/**
		 * 构造方法 
		 * @param fontName 字体名称 名称同字体所在的swf文件，及swf文件里定义的字体的link
		 * 
		 */
		public function EmbedFonts(...fontName) {
			var ary:Array = fontName as Array;
			if (ary != null) {
				for (var i:int =0; i<ary.length; i++) {
					var name:String = ary[i] as String;
					if (name != null && name.length > 0) {
						this.fontNameAry.push(name);
					}
				}
			}
		}

		/**
		 * 加载字体 
		 * 
		 */
		public function loadFontSwf():void {
			
			var ary:Array = this.fontNameAry;
			if (ary != null) {
			 	var i:int = this.loadCmpFontNum;
				var name:String = ary[i] as String;
				if (name != null && name.length > 0) {
					//字体对应swf文件路径
					var swfName:String = SWF_FONT_ROOT_PATH + name + SWF_EXT_NAME;
					try {
						var loader:Loader = new Loader();
						var cli:LoaderInfo;
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handlerLoadFontSwfComplete);
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadFontSwfIoError);
						loader.load(new URLRequest(swfName));
					} catch (error:Error) {
						trace("找不到字体swf文件:" + swfName);
					}	
				}
			}
		}
		
		/**
		 * 读取字体文件出错 
		 * @param e
		 * 
		 */		
		function handlerLoadFontSwfIoError(e:Event):void{
			this.dispatchEvent(new EmbedFontsEvent(EmbedFontsEvent.IO_ERROR));
		}
		
		
		/**
		 * 加载字体文件完成事件 
		 * @param event
		 * 
		 */		
		function handlerLoadFontSwfComplete(event:Event):void {
			
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			var domain:ApplicationDomain = info.applicationDomain;
			this.domainAry.push(domain);
			this.loadCmpFontNum ++;
			if(this.loadCmpFontNum < this.fontNameAry.length){
				this.loadFontSwf();
			}
			else {
				this.registerFont();
			}
		}
		
		public static function findFontByName(name:String):String{
			return EmbedFonts.fontEnNameAry[name] as String;
		}
		
		/**
		 * 注册字体 
		 * 
		 */		
		private function registerFont():void {
			var ary:Array = this.fontNameAry;
			for (var i:int =0; i<ary.length; i++) {
				var name:String = ary[i] as String;
				if (name != null && name.length > 0) {
					try {
						var domain:ApplicationDomain = this.domainAry[i] as ApplicationDomain;
						var fontLibrary:Class = domain.getDefinition(name) as Class;
						Font.registerFont(fontLibrary);
						var embeddedFonts:Array = Font.enumerateFonts(false);
						var font:Font = embeddedFonts[embeddedFonts.length -1] as Font;
						EmbedFonts.fontEnNameAry[name] = font.fontName;
					} catch (error:Error) {
						trace("找不到"+SWF_FONT_ROOT_PATH + name + SWF_EXT_NAME+"中的字体类:" + name);
					}
				}
			}			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		

		/**
		 * get _fontNameAry
		 * @return 
		 * 
		 */
		public function get fontNameAry():Array {
			return _fontNameAry;
		}

		/**
		 * set _fontNameAry
		 * @param v
		 * 
		 */
		public function set fontNameAry(v:Array):void {
			_fontNameAry = v;
		}

	}
}