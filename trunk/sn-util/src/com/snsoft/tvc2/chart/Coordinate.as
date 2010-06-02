package com.snsoft.tvc2.chart{
	
	/**
	 * 坐标系
	 * @author Administrator
	 * 
	 */	
	public class Coordinate{
		public function Coordinate(){
		}
		
		/**
		 * 计算坐标轴刻度值列表
		 * @return 
		 * 
		 */		
		public function calculateCalibration(vct:Vector.<Number>,isDynamic:Boolean = false):Vector.<Number>{
			var caliList:Vector.<Number> = null;
			if(vct != null && vct.length > 0){
				var cali:Number = 1;
				var minNum:Number = NaN;
				var maxNum:Number = NaN;
				caliList = new Vector.<Number>();
				for(var i:int = 0;i<vct.length;i++){
					var num:Number = vct[i];
					
					//找最小值
					if(!isNaN(minNum)){
						if(num < minNum){
							minNum = num;
						}
					}
					else {
						minNum = num;
					}
					
					//找最大值
					if(!isNaN(maxNum)){
						if(num > maxNum){
							maxNum = num;
						}
					}
					else {
						maxNum = num;
					}
				}
				
				if(!isDynamic){
					minNum = 0;
				}
				
				//计算出  值 为(1 或 2 或 5 ) * 10^N 的刻度，用这个值做刻度比较通用好看
				var maxPoor:Number = maxNum - minNum;
				var caliTemp:Number = Math.abs(maxPoor)/5;
				var power:Number = 1;
				while ( caliTemp < 1) {
					caliTemp *= 10;
					power*=10;
				}
				while ( caliTemp > 10) {
					caliTemp/=10;
					power/=10;
				}
				if (caliTemp<1) {
					caliTemp=1.00;
				}
				else if ( caliTemp < 2 ) {
					caliTemp=2.00;
				}
				else if ( caliTemp < 5 ) {
					caliTemp=5.00;
				}
				else {
					caliTemp=10;
				}
				cali = (caliTemp / power);
				//trace(cali,minNum,maxNum);
				
				//坐标值列表计算
				//caliList
				var minIndex:int = int(minNum / cali);
				var minMod:int = minNum >= 0 ? 0 : 1;
				//trace("minNum,minMod:",minNum,minMod);
				minIndex -= minMod;
				
				
				//当 mod 值不为0时  modNum = 1 当mod 值为0时 modNum = 0
				
				var maxIndex:int = int(maxNum / cali);
				var maxMode:int = maxNum % cali == 0 ? 0 : 1;
				maxMode = maxNum <= 0 ? 0 : maxMode;
				maxIndex += maxMode;
				
				for (var j:int = minIndex;j <= maxIndex;j ++){
					var icali:Number = cali * j;
					caliList.push(icali);
					//trace("caliList:",icali);
				}
				
			}
			return caliList;
		}
		
	}
}