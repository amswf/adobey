package com.snsoft.font{
	import com.snsoft.util.HashVector;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *  例子：
	 import com.snsoft.font.EmbedFonts;
	 import com.snsoft.font.EmbedFontsEvent;
	 
	 var ef:EmbedFonts = new EmbedFonts("SimHei","STXihei","YouYuan","MicrosoftYaHei"'"SimSung");
	 ef.loadFontSwf();
	 ef.addEventListener(Event.COMPLETE,handler);
	 ef.addEventListener(EmbedFontsEvent.IO_ERROR,handlerIOError);
	 
	 function handler(e:Event){
	 
	 var tf = new TextFormat(EmbedFonts.findFontByName("YouYuan"),40,0x000000);
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
		
		private static var SWF_EXT_NAME:String = ".swf";
		
		private static var SWF_FONT_ROOT_PATH:String = "font/";
		
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
		 * 字体文件 swf loader 
		 */		
		//private var loader:Loader = new Loader();
		
		
		private var currentLoadSwfName:String = "";
		
		private var bytesTotal:int = 0;
		
		private var bytesLoadedHV:HashVector = new HashVector();
		
		
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
					addFontName(name);
				}
			}
		}
		
		public function addFontName(fontName:String):void{
			if (fontName != null && fontName.length > 0) {
				this.fontNameAry.push(fontName);
			}
		}
		
		/**
		 * 加载字体 
		 * 
		 */
		public function loadFontSwf():void {
			var ary:Array = this.fontNameAry;
			if (ary != null) {
				for (var i:int =0; i<ary.length; i++) {
					var name:String = ary[i] as String;
					if (name != null && name.length > 0) {
						//字体对应swf文件路径
						var swfName:String = SWF_FONT_ROOT_PATH + name + SWF_EXT_NAME;
						var loader:FontLoader = new FontLoader();
						loader.addEventListener(FontLoaderEvent.IS_RECEIVE_BYTES_TOTAL,handlerIsReceiveBytes);
						var loderInfor:LoaderInfo = loader.contentLoaderInfo;
						loderInfor.addEventListener(Event.COMPLETE,handlerLoadFontSwfComplete);
						loderInfor.addEventListener(IOErrorEvent.IO_ERROR,handlerLoadFontSwfIoError);
						loderInfor.addEventListener(ProgressEvent.PROGRESS,handlerProgress);
						loader.load(new URLRequest(swfName));
						this.currentLoadSwfName = swfName;	
					}
				}
			}
		}
		
		/**
		 *  
		 * @param e
		 * 
		 */		
		private function handlerIsReceiveBytes(e:Event):void{
			var loader:FontLoader = e.currentTarget as FontLoader;
			var loderInfor:LoaderInfo = loader.contentLoaderInfo;
			this.bytesTotal += loderInfor.bytesTotal;
		}
		
		/**
		 * 
		 * @param e
		 * 
		 */		
		private function handlerProgress(e:Event):void{
			if(this.bytesTotal > 0){
				var loderInfor:LoaderInfo = e.currentTarget as LoaderInfo;
				var loader:FontLoader = loderInfor.loader as FontLoader;
				bytesLoadedHV.push(loderInfor.bytesLoaded,loader.fontUrlMd5);
				this.dispatchEvent(new Event(ProgressEvent.PROGRESS));
			}
		}
		
		
		/**
		 * 读取字体文件出错 
		 * @param e
		 * 
		 */		
		private function handlerLoadFontSwfIoError(e:Event):void{
			trace("找不到字体swf文件:" + currentLoadSwfName +" [EmbedFontsEvent.IO_ERROR]");
			this.dispatchEvent(new EmbedFontsEvent(EmbedFontsEvent.IO_ERROR));
			this.loadCmpFontNum ++;
		}
		
		
		/**
		 * 加载字体文件完成事件 
		 * @param event
		 * 
		 */		
		private function handlerLoadFontSwfComplete(event:Event):void {
			trace("成功加载字体swf:" + currentLoadSwfName);
			var info:LoaderInfo = event.currentTarget as LoaderInfo;
			var domain:ApplicationDomain = info.applicationDomain;
			this.domainAry.push(domain);
			this.loadCmpFontNum ++;
			checkLoading();
		}
		
		private function checkLoading():void{
			if(this.loadCmpFontNum == this.fontNameAry.length){
				this.registerFont();
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function getProgressValue():int{
			var bl:int = 0;
			for(var i:int = 0;i < bytesLoadedHV.length;i ++){
				bl += bytesLoadedHV.findByIndex(i) as int;	
			}
			return int(100 * bl / bytesTotal);
		}
		
		/**
		 * 通过字体类名得到字体的真实名称 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function findFontByName(name:String):String{
			return EmbedFonts.fontEnNameAry[name] as String;
		}
		
		/**
		 * 注册字体
		 * 
		 */		
		private function registerFont():void {
			var ary:Array = this.fontNameAry;
			if(ary != null){
				for (var i:int =0; i<ary.length; i++) {
					var name:String = ary[i] as String;
					if (name != null && name.length > 0) {
						try {
							var domain:ApplicationDomain = this.domainAry[i] as ApplicationDomain;
							var fontLibrary:Class = domain.getDefinition(name) as Class;
							Font.registerFont(fontLibrary);
						} catch (error:Error) {
							trace("找不到"+SWF_FONT_ROOT_PATH + name + SWF_EXT_NAME+"中的字体类:" + name);
						}
					}
				}	
			}
			
			//把字体类名称关联字体的真实名称
			var fary:Array = Font.enumerateFonts(false);
			for(var j:int = 0;j < fary.length;j ++){
				var f:Font = fary[j] as Font;
				var cname:String = getQualifiedClassName(f);
				var fname:String = f.fontName;
				trace(cname,":",fname);
				if(cname != null && fname != null){
					EmbedFonts.fontEnNameAry[cname] = fname;
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