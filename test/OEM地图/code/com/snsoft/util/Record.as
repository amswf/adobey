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
		
		//设置值
		public function setValue(name:String,value:String):void {
			if ( name != null &&name != "undefined" && name != "" && value != null && value != "undefined" ) {
				name = name.toLocaleUpperCase();
				this.filedName.push(name);
				this.filedValue[name] = value;
			}
		}
		
		//获得值
		public function getValue(name:String):String {
			if( name != null && name != "undefined" && name != "" ){
				name = name.toLocaleUpperCase();
				var value:String = filedValue[name];
				if(value != null && value != "undefined" ){
					return value;
				}
			}
			return null;
		}
		
		public function getNameById(i:int):String{
			if( i >= 0 && i<filedName.length){
				var name:String = String(filedName[i]);
				if(name != null){
					return name;
				}
			}
			return null;
		}
		
		public function getValueById(i:int):String{
			if( i >= 0 && i<filedName.length){
				var name:String = String(filedName[i]);
				if(name != null){
					var value:String = filedValue[name];
					return value;
				}
			}
			return null;
		}
		
		public function size():int{
			return filedName.length;
		}
	}
}