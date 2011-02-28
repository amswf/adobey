package com.snsoft.util.rlm.res{
	import com.snsoft.util.AbstractBase;

	public class ResBase extends AbstractBase{
		
		private var _urlList:Vector.<String> = new Vector.<String>();
		
		private var _urlMd5List:Vector.<String> = new Vector.<String>();
		
		private var _resDataList:Vector.<Object>;
		
		public function ResBase(){
			createAbstractClass(ResBase);
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

		public function get urlMd5List():Vector.<String>
		{
			return _urlMd5List;
		}
		
		public function set resDataList(resDataList:Vector.<Object>):void{
			this._resDataList = resDataList;
		}

	}
}