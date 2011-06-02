package com.snsoft.tvc2.chart {
	import com.snsoft.tvc2.SystemConfig;

	/**
	 * 坐标系
	 * @author Administrator
	 *
	 */
	public class Coordinate {

		//数据列表
		private var _dataVct:Vector.<Number>;

		//刻度列表
		private var _calibrationVct:Vector.<Number>;

		//坐标系原点是否动态
		private var isDynamic:Boolean;

		//刻度值
		private var _gradValue:Number;

		//刻度基值
		private var _gradeBaseValue:Number;

		//最大刻度最小刻度差值
		private var _differenceValue:Number;

		private var _gradeNum:Number;

		public function Coordinate(vct:Vector.<Number>, isDynamic:Boolean = false) {

			this._dataVct = vct;
			this.isDynamic = isDynamic;

			this.calculateCalibration(this.dataVct, this.isDynamic);
		}

		/**
		 * 计算坐标轴刻度值列表
		 * @return
		 *
		 */
		private function calculateCalibration(vct:Vector.<Number>, isDynamic:Boolean = false):void {
			var caliList:Vector.<Number> = null;
			if (vct != null && vct.length > 0) {

				var minNum:Number = NaN;
				var maxNum:Number = NaN;
				caliList = new Vector.<Number>();
				for (var i:int = 0; i < vct.length; i++) {
					var num:Number = vct[i];

					//找最小值
					if (!isNaN(minNum)) {
						if (num < minNum) {
							minNum = num;
						}
					}
					else {
						minNum = num;
					}

					//找最大值
					if (!isNaN(maxNum)) {
						if (num > maxNum) {
							maxNum = num;
						}
					}
					else {
						maxNum = num;
					}
				}

				if (!isDynamic && minNum > 0) {
					minNum = 0;
				}

				if (!isDynamic && maxNum < 0) {
					maxNum = 0;
				}

				var maxPoor:Number = maxNum - minNum;

				var caliTemp:Number = Math.abs(maxPoor) / 5;

				//最大值
				var maxTemp:Number = maxNum;
				//最大值的单位值
				var mpower:Number = 1;
				//计算最大值的单位值，比如3.5 最大单位值为1，0.7最大单位置为0.1
				while (maxTemp < 1) {
					maxTemp *= 10;
					mpower *= 10;
				}
				while (maxTemp > 10) {
					maxTemp /= 10;
					mpower /= 10;
				}
				//刻度单位值
				var cali:Number = 1;
				
				//计算出  值 为(1 或 2 或 5 ) * 10^N 的刻度，用这个值做刻度比较通用好看
				if (mpower > caliTemp * 10) {
					cali = mpower * 0.1;
				}
				else {
					var power:Number = 1;
					while (caliTemp < 1) {
						caliTemp *= 10;
						power *= 10;
					}
					while (caliTemp > 10) {
						caliTemp /= 10;
						power /= 10;
					}
					if (caliTemp < 1) {
						caliTemp = 1.00;
					}
					else if (caliTemp < 2) {
						caliTemp = 2.00;
					}
					else if (caliTemp < 5) {
						caliTemp = 5.00;
					}
					else {
						caliTemp = 10;
					}
					cali = (caliTemp / power);
				}
				//trace(cali,minNum,maxNum);
				if (cali < SystemConfig.PRICE_VALID_MIN_VALUE) {
					cali = SystemConfig.PRICE_VALID_MIN_VALUE;
				}
				//坐标值列表计算
				//caliList
				var minIndex:int = int(minNum / cali);
				var minMod:int = minNum >= 0 ? 0 : 1;
				//trace("minNum,minMod:",minNum,minMod);
				minIndex -= minMod;

				//当最小值和基值相同时，刻度要减一，防止某些数据在0上。
				if (Math.abs(minNum - cali * minIndex) <= SystemConfig.NUMBER_CORRECT) {
					minIndex -= 1;
				}

				//当 mod 值不为0时  modNum = 1 当mod 值为0时 modNum = 0

				var maxIndex:int = int(maxNum / cali);
				var maxMode:int = maxNum % cali == 0 ? 0 : 1;
				maxMode = maxNum <= 0 ? 0 : maxMode;
				maxIndex += maxMode;

				for (var j:int = minIndex; j <= maxIndex; j++) {
					var icali:Number = cali * j;
					caliList.push(icali);
						//trace("caliList:",icali);
				}
				this._gradValue = cali;
				this._gradeBaseValue = cali * minIndex;
				//trace("max - min: ",maxIndex,minIndex);
				this._differenceValue = cali * (maxIndex - minIndex);
				this._gradeNum = maxIndex - minIndex + 1;
				this._calibrationVct = caliList;
			}

		}

		public function get dataVct():Vector.<Number> {
			return _dataVct;
		}

		public function get calibrationVct():Vector.<Number> {
			return _calibrationVct;
		}

		public function get gradValue():Number {
			return _gradValue;
		}

		public function get gradeBaseValue():Number {
			return _gradeBaseValue;
		}

		public function get differenceValue():Number {
			return _differenceValue;
		}

		public function get gradeNum():Number {
			return _gradeNum;
		}

	}
}
