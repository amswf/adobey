package com.snsoft.util.rlm.rs{
	import com.snsoft.util.AbstractBase;

	/**
	 * 资源集
	 * 
	 * 本类需要继承，重写callBack方法，用来让 ResLoadManager 通知 ResLoadManager已经完成处理。
	 * 
	 * 是相同类型的需要加载的资源列表处理对象，如：字体集、图片集、swf集、xml文件集等。
	 * 
	 * 同时，扩展此资源集的类又具备集中处理这些相同类型资源功能。 
	 * @author Administrator
	 * 
	 */	
	public class ResSet extends AbstractBase{
		
		private var _urlList:Vector.<String> = new Vector.<String>();
		
		private var _resDataList:Vector.<Object> = new Vector.<Object>();
		
		public function ResSet(){
			createAbstractClass(ResSet);
		}
		
		public function addResUrl(url:String):void{
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