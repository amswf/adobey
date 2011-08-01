package com.snsoft.map {
	import com.snsoft.util.HashVector;

	public class WorkSpaceDO {

		//工作区名称
		private var _wsName:String = null;

		//工作区背景图片		
		private var _image:String = null;

		//地图块数据对象列表
		private var _mapAreaDOs:Vector.<MapAreaDO> = null;

		private var _sections:Vector.<MapPathSection>;

		public function WorkSpaceDO() {
		}

		public function get image():String {
			return _image;
		}

		public function set image(value:String):void {
			_image = value;
		}

		public function get wsName():String {
			return _wsName;
		}

		public function set wsName(value:String):void {
			_wsName = value;
		}

		public function get mapAreaDOs():Vector.<MapAreaDO>
		{
			return _mapAreaDOs;
		}

		public function set mapAreaDOs(value:Vector.<MapAreaDO>):void
		{
			_mapAreaDOs = value;
		}

		public function get sections():Vector.<MapPathSection>
		{
			return _sections;
		}

		public function set sections(value:Vector.<MapPathSection>):void
		{
			_sections = value;
		}


	}
}
