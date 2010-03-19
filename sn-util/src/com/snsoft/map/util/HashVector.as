package com.snsoft.map.util{
	public class HashVector{
		
		//数据
		private var valueVec:Vector.<Object> = new Vector.<Object>();
		
		//名称
		private var nameVec:Vector.<String> = new Vector.<String>();
		
		private var idAry:Array = new Array();
		
		public function HashVector(){
			
		}
		
		/**
		 * 添加
		 * @param name
		 * @param value
		 * 
		 */		
		public function put(name:String,value:Object):void{
			var i:int = this.findIndexByName(name);
			if(i>=0){
				valueVec[i] = value;
				idAry[name] = i;
			}
			else {
				nameVec.push(name);
				valueVec.push(value);
				idAry[name] = this.valueVec.length -1;
			}
		}
		
		/**
		 * 通过下标删除
		 * @param i
		 * 
		 */		
		public function removeByIndex(i:int):void{
			if(indexIsCorrect(i)){
				var name:String = this.findNameByIndex(i);
				idAry[name] = -1;
				this.nameVec.splice(i,1);
				this.valueVec.splice(i,1);
			}
		}
		
		/**
		 * 通过名称删除 
		 * @param name
		 * 
		 */		
		public function removeByName(name:String):void{
			var i:int = this.findIndexByName(name);
			this.removeByIndex(i);
		}
		
		/**
		 * 转换成向量 
		 * @return 
		 * 
		 */		
		public function toVector():Vector.<Object>{
			var v:Vector.<Object> = new Vector.<Object>();
			v.concat(this.valueVec);
			return v;
		}
		
		/**
		 * 转换成数组 
		 * @return 
		 * 
		 */		
		public function toArray():Array{
			var ary:Array = new Array();
			for(var i:int =0;i<this.valueVec.length;i++){
				ary.push(this.valueVec[i]);
			}
			return ary;
		}
		
		/**
		 * 获得hash向量长度 
		 * @return 
		 * 
		 */		
		public function get length():int{
			return this.valueVec.length;
		}
		
		
		
		/**
		 * 通过下标查找值 
		 * @param i
		 * @return 
		 * 
		 */		
		public function findByIndex(i:int):Object{
			if(indexIsCorrect(i)){
				return valueVec[i] as Object;
			}
			return null;
		}
		
		/**
		 * 通过键名查找值 
		 * @param name
		 * @return 
		 * 
		 */		
		public function findByName(name:String):Object{
			var i:int = this.findIndexByName(name);
			if(i >= 0){
				return findByIndex(i);
			}
			return null;
		}
		
		/**
		 * 查找下标 对应的 键名
		 * @param i
		 * @return 
		 * 
		 */		
		public function findNameByIndex(i:int):String{
			if(indexIsCorrect(i)){
				return nameVec[i];
			}
			return null;
		}
		
		/**
		 * 查找键名对应的下标 
		 * @param name
		 * @return 
		 * 
		 */		
		public function findIndexByName(name:String):int{
			var i:int = -1;
			if(idAry[name] != null){
				i = idAry[name] as int;
			}
			return i;
		}
		
		/**
		 * 验证键名是否正确 
		 * @param name
		 * @return 
		 * 
		 */		
		private function nameIsCorrect(name:String):Boolean{
			if(name != null && name.length > 0){
				return true;
			}
			return false;
		}
		
		/**
		 * 验证下标是否正确 
		 * @param i
		 * @return 
		 * 
		 */		
		private function indexIsCorrect(i:int):Boolean{
			if(i>=0 && i<this.valueVec.length){
				return true;
			}
			return false;
		}
	}
}