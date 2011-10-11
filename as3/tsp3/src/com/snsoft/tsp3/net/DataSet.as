package com.snsoft.tsp3.net {

	public class DataSet {

		private var _attr:DataSetAttr = new DataSetAttr();

		private var _dtoList:Vector.<DataDTO> = new Vector.<DataDTO>();

		public function DataSet() {

		}

		public function addDto(dto:DataDTO):void {
			dtoList.push(dto);
		}

		public function get dtoList():Vector.<DataDTO> {
			return _dtoList;
		}

		public function get attr():DataSetAttr {
			return _attr;
		}

		public function set attr(value:DataSetAttr):void {
			_attr = value;
		}

	}
}
