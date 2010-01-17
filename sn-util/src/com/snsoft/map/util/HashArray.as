package com.snsoft.map.util
{
	public class HashArray
	{
		
		private static var HASH_DEFAULT_VALUE = "-1";
		private var listAry:Array = new Array();
		
		private var hashAry:Array = new Array();
		
		public function HashArray()
		{
		}
		
		/**
		 * 添加对象到hash 
		 * @param name
		 * @param value
		 * 
		 */		
		
		public function put(name:String,value:Object):void{
			if(name != null && name.length > 0){
				this.listAry.push(value);
				this.hashAry[name] = String(listAry.length -1);
			}
		}
		
		/**
		 * 此方法，暂时不用。 
		 * @param name
		 * 
		 */		
		private function remove(name:String):void{
			if(name != null && name.length > 0){
				var i:int = this.findIndex(name);
				if(i >=0 ){
					this.listAry[i] = null;
					this.hashAry[name] = HASH_DEFAULT_VALUE;
				}
			}
		}
		
		/**
		 * 从hash查找对象
		 * @param name
		 * @return 
		 * 
		 */		
		public function find(name:String):Object{
			if(name != null && name.length > 0){
				var i:int = this.findIndex(name);
				if(i >=0 ){
					return listAry[i];
				}
			}
			return null;
		}
		
		/**
		 * 查找下标 
		 * @param name
		 * @return 
		 * 
		 */		
		public function findIndex(name:String):int{
			if(name != null && name.length > 0){
				var istr:String = hashAry[name] as String;
				var i:int = this.getInt(istr);
				return i;
			}
			return -1;
		}
		
		/**
		 * 返回hash的Array 
		 * @return 
		 * 
		 */		
		public function getArray():Array{
			return this.listAry;
		}
		
		public function get length():int{
			return this.listAry.length;
		}
		
		
		/**
		 * 字符串转换成整数，获得下标 
		 * @param str
		 * 
		 */		
		public function getInt(str:String):int{
			try{
				var i:int = int(str);
				return i;
			}
			catch(e:Error){
				
			}
			return -1;
		}
	}
}