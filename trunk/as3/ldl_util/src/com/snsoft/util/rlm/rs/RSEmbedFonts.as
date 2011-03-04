package com.snsoft.util.rlm.rs{
	import com.snsoft.util.HashVector;
	
	import flash.display.LoaderInfo;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 嵌入字体资源集
	 * 
	 * 
	 * 字体名称 同字体所在的swf文件，及swf文件里定义的字体的link是相同的。
	 * 
	 * @author Administrator
	 * 
	 */
	public class RSEmbedFonts extends ResSet {
		
		private static var SWF_EXT_NAME:String = ".swf";
		
		private static var SWF_FONT_ROOT_PATH:String = "font/";
		
		/**
		 * 字体文件列表 
		 */
		private var fontNameList:Vector.<String> = new Vector.<String>();
		
		/**
		 * 字体文件中第一个字体标识名称
		 */		
		private static var fontEnNameList:Array= new Array();
		
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
		
		private var _resNameList:Vector.<String>;
		
		
		/**
		 * 构造方法 
		 * @param fontName 字体名称 名称同字体所在的swf文件，及swf文件里定义的字体的link
		 * 
		 */
		public function RSEmbedFonts(...fontName) {
			var ary:Array = fontName as Array;
			if (ary != null) {
				for (var i:int =0; i<ary.length; i++) {
					var name:String = ary[i] as String;
					addFontName(name);
				}
			}
		}
		
		override public function callBack():void{
			registerFont();
		} 
		
		public function addFontName(fontName:String):void{
			if (fontName != null && fontName.length > 0) {
				this.fontNameList.push(fontName);
				var url:String = SWF_FONT_ROOT_PATH + fontName + SWF_EXT_NAME;
				this.addResUrl(url);
			}
		}
		
		/**
		 * 通过字体类名得到字体的真实名称 
		 * @param name
		 * @return 
		 * 
		 */		
		public static function findFontByName(name:String):String{
			return RSEmbedFonts.fontEnNameList[name] as String;
		}
		
		/**
		 * 注册字体
		 * 
		 */		
		private function registerFont():void {
			var list:Vector.<String> = this.fontNameList;
			if(list != null){
				for (var i:int =0; i<list.length; i++) {
					var name:String = list[i];
					if (name != null && name.length > 0) {
						try {
							var li:LoaderInfo = this.resDataList[i] as LoaderInfo;
							if(li != null){
								var domain:ApplicationDomain = li.applicationDomain;
								var fontLibrary:Class = domain.getDefinition(name) as Class;
								Font.registerFont(fontLibrary);
							}
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
					RSEmbedFonts.fontEnNameList[cname] = fname;
				}
			}
		}
		
	}
}