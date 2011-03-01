package com.snsoft.util.rlm.res{
	import com.snsoft.util.AbstractBase;

	public class ResBase extends AbstractBase{
		
		private var _urlList:Vector.<String> = new Vector.<String>();
		
		private var _resDataList:Vector.<Object> = new Vector.<Object>();
		
		public function ResBase(){
			createAbstractClass(ResBase);
		}
		
		public function addUrl(url:String):void{
			this.urlList.push(url);
		}
		
		/**
		 * 需要重写此方法,完成对象的其它操作 
		 * 
		 */		
		public function callBack():void{
			createAbstractMethod("ResBase.callBack");
		}
		
		public function get urlList():Vector.<String>
		{
			return _urlList;
		}
		
		public function set resDataList(resDataList:Vector.<Object>):void{
			this._resDataList = resDataList;
		}
		
		public function get resDataList():Vector.<Object>{
			return this._resDataList;
		}

	}
}