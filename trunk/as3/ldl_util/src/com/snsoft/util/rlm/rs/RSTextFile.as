package com.snsoft.util.rlm.rs{
	import com.snsoft.util.HashVector;
	
	import flash.net.URLLoader;

	public class RSTextFile extends ResSet{
		
		private var textList:HashVector = new HashVector();
		
		public function RSTextFile(){
			
		}
		
		public function getTextByUrl(url:String):String{
			return this.textList.findByName(url) as String;
		}
		
		override protected function callBack():void{
			for(var i:int = 0;i < resDataList.length;i ++){
				var text:String = String(resDataList[i]);
				this.textList.push(text,urlList[i]);
			}
		} 
	}
}