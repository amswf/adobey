package com.snsoft.util{
	import com.adobe.crypto.MD5;

	public class FileUtil{
		public function FileUtil()
		{
		}
		
		public static function creatSoleMD5FileName(fileNameWithExtension:String,withExtension:Boolean = true):String{
			var md5n:String = null;
			if(fileNameWithExtension != null && fileNameWithExtension.length > 0){
				var name:String = FileUtil.getFileName(fileNameWithExtension);
				var ext:String = FileUtil.getExtension(fileNameWithExtension);
				var time:uint = new Date().getTime();
				var md5name:String = MD5.hash(name + "_" + time);
				if(withExtension){
					md5n = md5name + "." + ext;
				}
				else {
					md5n = md5name;
				}
			}
			return md5n;
		}
		
		/**
		 * 获得文件扩展名 
		 * @param fileNameAndExtension
		 * @return 
		 * 
		 */		
		public static function getExtension(fileNameAndExtension:String):String{
			var i:int = fileNameAndExtension.lastIndexOf(".");
			var extension:String = null;
			if(i > 0 && (i + 1) < fileNameAndExtension.length){
				extension = fileNameAndExtension.substring((i + 1),fileNameAndExtension.length); 
			}
			return extension;
		}
		
		/**
		 * 获得文件名称不包括扩展名  
		 * @param fileNameAndExtension
		 * @return 
		 * 
		 */		
		public static function getFileName(fileNameAndExtension:String):String{
			var i:int = fileNameAndExtension.lastIndexOf(".");
			var extension:String = null;
			if(i > 0){
				extension = fileNameAndExtension.substring(0,i); 
			}
			return extension;
		}
	}
}