package com.snsoft.map
{
	import com.snsoft.map.util.HashArray;
	import com.snsoft.map.util.HitTest;
	
	import flash.geom.Point;
	
	public class MapPointsManager
	{
		
		//当前画线的点数组
		private var _currentPointAry:HashArray = new HashArray();
		
		//所有点的数组的数组
		private var _pointAryAry:HashArray = new HashArray();
		
		//碰撞检测类对象
		private var hitTest:HitTest = null;
		
		//碰撞检测的坐标差值域
		private static const HIT_TEST_DVALUE_POINT:Point = new Point(5,5);
		
		//碰撞检测分块步进值
		private static const HIT_TEST_STEP_VALUE_POINT:Point = new Point(10,10);
		
		private static const IS_CLOSE:int = 3;
		
		private static const IS_IN_CPA:int = 2;
		
		private static const IS_HIT:int = 1;
		
		private static const IS_NORMAL:int = 0;
		
		public function MapPointsManager(workSizePoint:Point)
		{
			hitTest = new HitTest(workSizePoint,HIT_TEST_STEP_VALUE_POINT);
		}
		
		public function findLatestClosedPointArray():HashArray{
			var paa:HashArray = this.pointAryAry;
			
			if(paa.length > 0 ){
				var lasti:int = paa.length -1;
				var pa:HashArray = paa.findByIndex(lasti) as HashArray;
				return pa;
			}
			return null;
		}
		
		
		/**
		 * 测试点得到碰撞状态和碰撞点 
		 * @param point
		 * 
		 */		
		public function hitTestPoint(point:Point):MapPointManagerState{
			var paa:HashArray = this.pointAryAry;
			
			//获得碰撞点
			var htp:Point = this.hitTest.findPoint(point,HIT_TEST_DVALUE_POINT);
			var cpa:HashArray = this.currentPointAry;
			
			//判断闭合
			var cpap:Point = null;
			var isClose:Boolean = false;
			if(cpa.length >=3){
				var firstp:Point = cpa.findByIndex(0)as Point;
				if(hitTest.isHit2Point(point,firstp,HIT_TEST_DVALUE_POINT)){
					isClose = true;
					cpap = firstp;
				}
			}
			
			//判断点是否在当前链上，不包括开始点
			var isInCpa:Boolean = false;
			if(cpa.length >0){
				for(var i:int = 1;i<cpa.length;i++){ 
					var p:Point = cpa.findByIndex(i)as Point;
					if(hitTest.isHit2Point(point,p,HIT_TEST_DVALUE_POINT)){
						isInCpa = true;
						break;
					}
				}
			}
			
			//判断是否碰撞
			var isHit:Boolean = false;
			if (htp != null) {
				isHit = true;
			}
			
			
			var mpms:MapPointManagerState = new MapPointManagerState();
			mpms.fastPointArray = fastPointArray;
			
			//判断是否将要画的链是否已经存在，如果存在反回这个链
			var isFast:Boolean = false;
			var fastPointArray:HashArray = new HashArray();
			if(isHit && !isInCpa){
				var len:int = cpa.length;
				if(len >=2){
					var p1:Point = cpa.findByIndex(len -1) as Point;
					var p2:Point = cpa.findByIndex(len -2) as Point;
					for(var j:int = 0;j<paa.length;j++){
						var pa:HashArray = paa.findByIndex(j) as HashArray;
						if(pa != null){
							var n1:String = this.createPointHashName(p1);
							var n2:String = this.createPointHashName(p2);
							var np:String = this.createPointHashName(htp);
							var index1:int = pa.findIndex(n1);
							var index2:int = pa.findIndex(n2);
							var indexp:int = pa.findIndex(np);
							if(index1 >= 0 && index2 >= 0 && indexp >= 0 ){
								var palength:int = pa.length -1;
								if(index1 == palength){
									index1 = 0;
								}
								if(index2 == palength){
									index2 = 0;
								}
								var subIndex:int = index1 - index2;
								if(subIndex == palength -1 || subIndex == -1){
									subIndex = -1;
								}
								else if(subIndex == - (palength -1) || subIndex == 1){
									subIndex = 1;
								}
								if(Math.abs(subIndex) == 1){
									var startIndex:int = index1;
									while(true){
										startIndex += subIndex;
										if(startIndex >= palength){
											startIndex = palength - startIndex;
										}
										else if(startIndex < 0){
											startIndex = palength + startIndex;
										}
										var fp:Point = pa.findByIndex(startIndex) as Point;
										var fpname:String = this.createPointHashName(p1);
										fastPointArray.put(fpname,fp);
										if(startIndex == indexp) break;
									}
								}
								isFast = true;
								break;
							}
						}
					}
				}
				if(!isFast){
					//var htpn:String = this.createPointHashName(htp);
					//fastPointArray.put(htpn,htp);
				}
			}
			else{
				//var npn:String = this.createPointHashName(point);
				//fastPointArray.put(npn,point);
			}
			mpms.fastPointArray = fastPointArray;
			if(isClose) {//如果闭合链了
				mpms.hitPoint = cpap;
				mpms.pointState = IS_CLOSE;
			}
			else if(isInCpa){//如果在当前链上，且不闭合
				mpms.hitPoint = point;
				mpms.pointState = IS_IN_CPA;
			}
			else if (isHit) {//如果碰撞了，但不在当前链上
				mpms.hitPoint = htp;
				mpms.pointState = IS_HIT;
			}
			else {//其它情况
				mpms.hitPoint = point;
				mpms.pointState = IS_NORMAL;
			}
			return mpms;
		}
		
		/**
		 * 检测当前所画的点，满足条件的添加到当前链中，并注册碰撞 
		 * @param point
		 * @return 
		 * 
		 */		
		public function addPoint(point:Point):MapPointManagerState{
			var mpms:MapPointManagerState = this.hitTestPoint(point); 
			if(mpms.isState(IS_CLOSE)) {//如果闭合链了
				this.addPointsToCpaAndHt(mpms);
				this.addCpaToPpa();
				this.tracePointAryAry(this.pointAryAry);//////////////////////////////////////测试用，最后删除
			}
			else if(mpms.isState(IS_IN_CPA)){//如果在当前链上，且不闭合
				//什么都不做 
			}
			else if (mpms.isState(IS_HIT)) {//如果碰撞了，但不在当前链上
				this.addPointsToCpaAndHt(mpms);
			}
			else {//其它情况
				this.addPointsToCpaAndHt(mpms);
			} 
			return mpms;
		}
		
		/**
		 *  
		 * @param mpms
		 * @return 
		 * 
		 */		
		private function addPointsToCpaAndHt(mpms:MapPointManagerState):void{
			var fpha:HashArray = mpms.fastPointArray;
			if(fpha != null && fpha.length > 0){
				this.addFastPhaToCpaAndHt(mpms);
			}
			else{
				var hp:Point = mpms.hitPoint;
				this.addPointToCpaAndHt(hp);
			}
		}
		
		/**
		 *  
		 * @param point
		 * 
		 */		
		private function addFastPhaToCpaAndHt(mpms:MapPointManagerState):void{
			var point:Point = mpms.hitPoint;
			var mpms:MapPointManagerState = this.hitTestPoint(point);
			var hp:Point = mpms.hitPoint;
			var cpa:HashArray = this._currentPointAry;
			var flha:HashArray = mpms.fastPointArray;
			for(var i:int =0;i<flha.length;i++){
				var fp:Point = flha.findByIndex(i) as Point;
				this.addPointToCpaAndHt(fp);
			}
		}
		
		/**
		 * 把点添加到当前链中并且注册碰撞检测
		 * @param point
		 * 
		 */		
		private function addPointToCpaAndHt(point:Point):void{
			//添加到当前链中
			var name:String = this.createPointHashName(point);
			this.currentPointAry.put(name,point);
			//注册碰撞检测
			this.hitTest.addPoint(point);
		}
		
		/**
		 * 把当前点链放到链组里面去,并且清空当前点链
		 * 
		 */		
		private function addCpaToPpa():void{
			var cpa:HashArray = this.currentPointAry;
			var hn:String = this.creatHashArrayHashName(cpa);
			this.pointAryAry.put(hn,cpa);
			this._currentPointAry = new HashArray();
		}
		
		/**
		 * 链的哈希名字 key 
		 * @param ha 点链(数组)
		 * @return 哈希名字 key
		 * 
		 */		
		private function creatHashArrayHashName(ha:HashArray):String{
			var hn:String = null;
			var ary:Array = ha.getArray();
			if(ary != null){
				for(var i:int =0;i<ary.length;i++){
					var p:Point = ary[i] as Point;
					if(p != null){
						var pn:String = this.createPointHashName(p);
						if(hn == null){
							hn = pn;
						}
						else {
							hn += "-" +pn;
						}
					}
				}
			}
			return hn;
		}
		
		/**
		 * 获得一个点的哈希名字 key 
		 * @param point 点坐标
		 * @return 哈希名字 key
		 * 
		 */		
		private function createPointHashName(point:Point):String {
			var str:String = String(point.x) + "|" + String(point.y);
			return str;
		}
		
		/**
		 * 测试帮助 
		 * 
		 */		
		private function tracePointAryAry(pointAryAry:HashArray):void{
			var ppa:Array = pointAryAry.getArray();
			trace(ppa.length);
			for(var i:int =0;i<ppa.length;i++){
				var ha:HashArray = ppa[i] as HashArray;
				if(ha != null){
					trace(ha.getArray());
				}
			}
		}

		public function get currentPointAry():HashArray
		{
			return _currentPointAry;
		}

		public function get pointAryAry():HashArray
		{
			return _pointAryAry;
		}


	}
}