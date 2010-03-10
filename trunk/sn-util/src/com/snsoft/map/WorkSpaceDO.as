package com.snsoft.map{
	import com.snsoft.map.util.HashArray;
	
	public class WorkSpaceDO{
		
		//工作区背景图片		
		private var _image:String = null;
		
		//地图块数据对象列表
		private var _mapAreaDOHashArray:HashArray = null;
		
		
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

		public function get mapAreaDOHashArray():HashArray
		{
			return _mapAreaDOHashArray;
		}

		public function set mapAreaDOHashArray(value:HashArray):void
		{
			_mapAreaDOHashArray = value;
		}


	}
}