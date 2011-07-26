package com.snsoft.util {
	import com.adobe.crypto.MD5;

	/**
	 * 自定义的哈稀列表
	 *
	 * 查找的速度最优处理，添加，删除时稍慢，保持效率。
	 *
	 * isSafe： name 值是否是安全的，是安全的，则多长的都能放到哈希表中，内建了hash 名称，但是损失了效率。
	 *
	 * @author Administrator
	 *
	 */
	public class HashVector {

		//数据
		private var valueVec:Vector.<Object> = new Vector.<Object>();

		//名称
		private var nameVec:Vector.<String> = new Vector.<String>();

		//下标 ，例如：array[name] = index
		private var idAry:Array = new Array();

		private var isSafe:Boolean;

		/**
		 *
		 * @param isSafe key 值是否需要保证是安全的，需要的则多长的都能放到哈希表中，内建了hash 名称，但是损失了效率。
		 *
		 */
		public function HashVector(isSafe:Boolean = false) {
			this.isSafe = isSafe;
		}

		/**
		 * 添加
		 * @param name 名字为空时，自动生成一个名字，但名字不对外使用
		 * @param value 值
		 *
		 */
		public function push(value:Object, name:String = null):void {
			if (name == null) {
				name = String(new Date().getTime()) + "_" + String(this.length + 1);
			}

			var nameMd5:String = null;
			if (isSafe) {
				nameMd5 = MD5.hash(name);
			}
			else {
				nameMd5 = name;
			}
			var i:int = this.findIndexByName(name);
			if (i >= 0) {
				valueVec[i] = value;
				idAry[nameMd5] = i;
			}
			else {
				nameVec.push(name);
				valueVec.push(value);
				idAry[nameMd5] = this.valueVec.length - 1;
			}
		}

		/**
		 * 通过下标删除
		 * @param i
		 *
		 */
		public function removeByIndex(index:int):void {
			if (indexIsCorrect(index)) {
				var name:String = this.findNameByIndex(index);
				var nameMd5:String = null;
				if (isSafe) {
					nameMd5 = MD5.hash(name);
				}
				else {
					nameMd5 = name;
				}
				this.nameVec.splice(index, 1);
				this.valueVec.splice(index, 1);
				idAry[nameMd5] = -1;
				for (var i:int = index; i < this.nameVec.length; i++) {
					var rname:String = this.nameVec[i];
					var rnameMd5:String = null;
					if (isSafe) {
						rnameMd5 = MD5.hash(rname);
					}
					else {
						rnameMd5 = rname;
					}
					if (idAry[rnameMd5] != null) {
						var rIndex:int = idAry[rnameMd5] as int;
						if (rIndex >= 0) {
							idAry[rnameMd5] = i;
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
		public function removeByName(name:String):void {
			var i:int = this.findIndexByName(name);
			this.removeByIndex(i);
		}

		/**
		 * 转换成向量
		 * @return
		 *
		 */
		public function toVector():Vector.<Object> {
			var v:Vector.<Object> = new Vector.<Object>();
			for (var i:int = 0; i < this.valueVec.length; i++) {
				v.push(this.valueVec[i]);
			}
			return v;
		}

		/**
		 * 转换成数组
		 * @return
		 *
		 */
		public function toArray():Array {
			var ary:Array = new Array();
			for (var i:int = 0; i < this.valueVec.length; i++) {
				ary.push(this.valueVec[i]);
			}
			return ary;
		}

		/**
		 * 获得hash向量长度
		 * @return
		 *
		 */
		public function get length():int {
			return this.valueVec.length;
		}

		/**
		 * 通过下标查找值
		 * @param i
		 * @return
		 *
		 */
		public function findByIndex(i:int):Object {
			if (indexIsCorrect(i)) {
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
		public function findByName(name:String):Object {
			var i:int = this.findIndexByName(name);
			if (i >= 0) {
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
		public function findNameByIndex(i:int):String {
			if (indexIsCorrect(i)) {
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
		public function findIndexByName(name:String):int {
			var i:int = -1;
			var nameMd5:String = null;
			if (isSafe) {
				nameMd5 = MD5.hash(name);
			}
			else {
				nameMd5 = name;
			}
			if (idAry[nameMd5] != null) {
				i = idAry[nameMd5] as int;
			}
			return i;
		}

		public function copy():HashVector {
			var hv:HashVector = new HashVector();
			for (var i:int = 0; i < this.length; i++) {
				var name:String = this.findNameByIndex(i);
				var value:Object = this.findByIndex(i);
				hv.push(value, name);
			}
			return hv;
		}

		/**
		 * 验证键名是否正确
		 * @param name
		 * @return
		 *
		 */
		private function nameIsCorrect(name:String):Boolean {
			if (name != null && name.length > 0) {
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
		private function indexIsCorrect(i:int):Boolean {
			if (i >= 0 && i < this.valueVec.length) {
				return true;
			}
			return false;
		}
	}
}
