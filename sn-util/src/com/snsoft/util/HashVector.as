package com.snsoft.util{
	
	/**
	 * 自定义的哈稀列表
	 * 
	 * 查找的速度最优处理，添加，删除时稍慢，保持效率。 
	 * @author Administrator
	 * 
	 */	
	public class HashVector{
		
		//数据
		private var valueVec:Vector.<Object> = new Vector.<Object>();
		
		//名称
		private var nameVec:Vector.<String> = new Vector.<String>();
		
		//下标 ，例如：array[name] = index
		private var idAry:Array = new Array();
		
		public function HashVector(){
			
		}
		
		/**
		 * 添加
		 * @param name
		 * @param value
		 * 
		 */		
		public function push(value:Object,name:String = null):void{
			if(name == null){
				name = String(this.length + 1);
			}
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
		public function removeByIndex(index:int):void{
			if(indexIsCorrect(index)){
				var name:String = this.findNameByIndex(index);
				this.nameVec.splice(index,1);
				this.valueVec.splice(index,1);
				idAry[name] = -1;
				for(var i:int = index;i<this.nameVec.length;i++){
					var rname:String = this.nameVec[i];
					if(idAry[rname] != null){
						var rIndex:int = idAry[rname] as int;
						if(rIndex >= 0){
							idAry[rname] = i;
						}
					}
				}
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