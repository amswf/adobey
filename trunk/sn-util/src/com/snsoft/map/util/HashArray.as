package com.snsoft.map.util
{
	

	public class HashArray
	{
		
		private static var HASH_DEFAULT_VALUE:String = "-1";
		
		private var listAry:Array = new Array();
		
		private var hashAry:Array = new Array();
		
		private var nameAry:Array = new Array();
		
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
				this.nameAry.push(name);
				this.hashAry[name] = String(listAry.length -1);
			}
		}
		
		/**
		 * 通过键值删除项。 
		 * @param name
		 * 
		 */		
		public function remove(name:String):void{
			if(name != null && name.length > 0){
				var i:int = this.findIndex(name);
				this.removeByIndex(i);
			}
		}
		
		/**
		 * 通过下标删除项 
		 * @param i
		 * 
		 */		
		public function removeByIndex(i:int):void{
			if(i >=0 && i<this.listAry.length ){
				var name:String = this.findName(i);
				this.listAry.splice(i,1);
				this.hashAry[name] = HASH_DEFAULT_VALUE;
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
		 * 通过下标查找对象 
		 * @param id
		 * @return 
		 * 
		 */		
		public function findByIndex(i:int):Object{
			if(i>=0 && i<listAry.length){
				return listAry[i];
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
		 * 查找键值 
		 * @param i
		 * @return 
		 * 
		 */		
		public function findName(i:int):String{
			var name:String = null;
			if(i>=0 && i<listAry.length){
				name = this.nameAry[i];
			}
			return name;
		}
		
		/**
		 * 获得最后一个点 
		 * @return 
		 * 
		 */		
		public function findLast():Object{
			return this.findByIndex(this.listAry.length -1);
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
				if( str != null){
					var i:int = int(str);
					return i;
				}
			}
			catch(e:Error){
				
			}
			return -1;
		}
	}
}