package com.snsoft.util{
	/**
	 * 读取XML文件时解析出的一个记录,XML文件当做数据库中的某个表,
	 * 而XML文件第一层结点集中的某个结点就是这样的一个记录.
	 * 
	 */
	public class Record {
		//字段名称
		private var filedName:Array = new Array();

		//字段值
		private var filedValue:Array = new Array();

		public function Record() {

		}
		public function setValue(name:String,value:String) {
			if (name != null && value != null) {
				this.filedName.push(name.toLocaleUpperCase());
				this.filedValue.push(value);
			}
		}
		public function getValue(name:String):String {
			for (var i:int = 0; i<filedName.length; i++) {
				if (filedName[i] == name.toLocaleUpperCase()) {
					return filedValue[i];
					break;
				}
			}
			return null;
		}
	}
}