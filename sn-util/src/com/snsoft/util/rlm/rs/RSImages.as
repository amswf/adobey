package com.snsoft.util.rlm.rs{
	import com.snsoft.util.HashVector;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;

	/**
	 * 图片资源集 
	 * @author Administrator
	 * 
	 */	
	public class RSImages extends ResSet{
		
		private var imageBmdList:HashVector = new HashVector();
		
		public function RSImages(){
			
		}
		
		/**
		 * 取出图片 
		 * @param url
		 * @return 
		 * 
		 */		
		public function getImageByUrl(url:String):BitmapData{
			return this.imageBmdList.findByName(url) as BitmapData;
		}
		
		override public function callBack():void{
			for(var i:int = 0;i < resDataList.length;i ++){
				var info:LoaderInfo = resDataList[i] as LoaderInfo;
				var bm:Bitmap = info.content as Bitmap;
				var bmd:BitmapData = bm.bitmapData;
				this.imageBmdList.push(bmd,urlList[i]);
			}
		} 
	}
}