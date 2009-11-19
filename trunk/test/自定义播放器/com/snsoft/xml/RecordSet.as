package com.snsoft.xml
{
	public class RecordSet
	{
 		private var rs:Array = new Array();
		
		public function push(rd:Record):void{
			rs.push(rd);
		}
		
		public function getBy(id:int):Record{
			if(id >= 0 && id<rs.length){
				return rs[id] as Record;
			}
			return null;
		}
		
		public function size():int{
			return rs.length;
		}
	}
}