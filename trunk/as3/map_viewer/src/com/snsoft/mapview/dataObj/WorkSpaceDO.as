package com.snsoft.mapview.dataObj{
	import com.snsoft.util.HashVector;
	
	public class WorkSpaceDO{
		
		//工作区名称
		private var _wsName:String = null;
		
		//工作区背景图片		
		private var _image:String = null;
		
		//地图块数据对象列表
		private var _mapAreaDOHashArray:HashVector = null;
		
		
		public function WorkSpaceDO(){
		}

		public function get image():String
		{
			return _image;
		}

		public function set image(value:String):void
		{
			_image = value;
		}

		public function get mapAreaDOHashArray():HashVector
		{
			return _mapAreaDOHashArray;
		}

		public function set mapAreaDOHashArray(value:HashVector):void
		{
			_mapAreaDOHashArray = value;
		}

		public function get wsName():String
		{
			return _wsName;
		}

		public function set wsName(value:String):void
		{
			_wsName = value;
		}


	}
}