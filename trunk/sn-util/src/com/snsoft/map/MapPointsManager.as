package com.snsoft.map
{
	import com.adobe.crypto.MD5;
	import com.snsoft.map.util.HitTest;
	import com.snsoft.util.HashVector;
	
	import flash.geom.Point;
	
	public class MapPointsManager
	{
		
		//当前画线的点数组
		private var _currentPointAry:HashVector = new HashVector();
		
		//地图块数据对象数组
		private var _mapAreaDOAry:HashVector = new HashVector(); 
		
		//碰撞检测类对象
		private var hitTest:HitTest = null;
		
		//碰撞检测两点碰撞的阈值
		private var _hitTestDvaluePoint:Point = new Point(0,0);
		
		//碰撞检测分块步进值
		private static const HIT_TEST_STEP_VALUE_POINT:Point = new Point(10,10);
		
		private static const IS_CLOSE:int = 3;
		
		private static const IS_IN_CPA:int = 2;
		
		private static const IS_HIT:int = 1;
		
		private static const IS_NORMAL:int = 0;
		
		public function MapPointsManager(workSizePoint:Point,hitTestDvaluePoint:Point)
		{
			hitTest = new HitTest(workSizePoint,HIT_TEST_STEP_VALUE_POINT);
			this.hitTestDvaluePoint = hitTestDvaluePoint;
		}
		
		public function findLatestMapAreaDO():MapAreaDO{
			var doa:HashVector = this.mapAreaDOAry;
			
			if(doa.length > 0 ){
				var lasti:int = doa.length -1;
				var mado:MapAreaDO = doa.findByIndex(lasti) as MapAreaDO;
				return mado;
			}
			return null;
		}
		
		
		/**
		 * 测试点得到碰撞状态和碰撞点 
		 * @param point
		 * 
		 */		
		public function hitTestPoint(point:Point):MapPointManagerState{
			var doa:HashVector = this.mapAreaDOAry;
			
			//获得碰撞点
			var htp:Point = this.hitTest.findPoint(point,hitTestDvaluePoint);
			var cpa:HashVector = this.currentPointAry;
			
			//判断闭合
			var cpap:Point = null;
			var isClose:Boolean = false;
			if(cpa.length >=3){
				var firstp:Point = cpa.findByIndex(0)as Point;
				if(hitTest.isHit2Point(point,firstp,hitTestDvaluePoint)){
					isClose = true;
					cpap = firstp;
				}
			}
			
			//判断点是否在当前链上，不包括开始点
			var isInCpa:Boolean = false;
			if(cpa.length >0){
				for(var i:int = 1;i<cpa.length;i++){ 
					var p:Point = cpa.findByIndex(i)as Point;
					if(hitTest.isHit2Point(point,p,hitTestDvaluePoint)){
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
			var fastPointArray:HashVector = new HashVector();
			if(isHit && !isInCpa){
				var len:int = cpa.length;
				if(len >=2){
					var p1:Point = cpa.findByIndex(len -1) as Point;
					var p2:Point = cpa.findByIndex(len -2) as Point;
					for(var j:int = 0;j<doa.length;j++){
						var mado:MapAreaDO = doa.findByIndex(j) as MapAreaDO;
						var pa:HashVector = mado.pointArray;
						if(pa != null){
							var n1:String = MapPointsManager.createPointHashName(p1);
							var n2:String = MapPointsManager.createPointHashName(p2);
							var np:String = MapPointsManager.createPointHashName(htp);
							var paLen:int = pa.length - 1;
							var index1:int = pa.findIndexByName(n1);
							if(index1 >= 0){
								var index2:int = pa.findIndexByName(n2);
								if(index2 >= 0 ){
									var indexp:int = pa.findIndexByName(np);
									if(indexp >= 0 ){
										var subIndex:int = index1 - index2;
										if(subIndex == paLen || subIndex == -1){
											subIndex = -1;
										}
										else if(subIndex == - (paLen) || subIndex == 1){
											subIndex = 1;
										}
										if(Math.abs(subIndex) == 1){
											var startIndex:int = index1;
											while(true){
												startIndex += subIndex;
												if(startIndex > paLen){
													startIndex = 0;
												}
												else if(startIndex < 0){
													startIndex = paLen;
												}
												var fp:Point = pa.findByIndex(startIndex) as Point;
												var fpname:String = MapPointsManager.createPointHashName(fp);
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
		 * 
		 */		
		public function deletePointAryAndDeleteHitTestPoint(mapAreaDO:MapAreaDO):void{
			var hpa:HashVector = mapAreaDO.pointArray;
			var hn:String = MapPointsManager.creatHashArrayHashName(hpa);
			this.mapAreaDOAry.removeByName(hn);
			var pa:Array = hpa.toArray();
			for(var i:int = 0;i<pa.length;i++){
				var point:Point = pa[i] as Point;
				this.hitTest.deletePoint(point);
			}
		}
		
		/**
		 * 添加点到当前链，并且注册碰撞检测 
		 * @param mpms
		 * @return 
		 * 
		 */		
		private function addPointsToCpaAndHt(mpms:MapPointManagerState):void{
			var fpha:HashVector = mpms.fastPointArray;
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
			var cpa:HashVector = this._currentPointAry;
			var flha:HashVector = mpms.fastPointArray;
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
			var name:String = MapPointsManager.createPointHashName(point);
			this.currentPointAry.put(name,point);
			//注册碰撞检测
			this.hitTest.addPoint(point);
		}
		
		/**
		 * 把当前点链放到链组里面去,并且清空当前点链
		 * 
		 */		
		private function addCpaToPpa():void{
			var cpa:HashVector = this.currentPointAry;
			var doa:MapAreaDO = new MapAreaDO();
			doa.pointArray = cpa;
			var hn:String = MapPointsManager.creatHashArrayHashName(cpa);
			this.mapAreaDOAry.put(hn,doa);
			this._currentPointAry = new HashVector();
		}
		
		/**
		 * 链的哈希名字 key 
		 * @param ha 点链(数组)
		 * @return 哈希名字 key
		 * 
		 */		
		public static function creatHashArrayHashName(ha:HashVector):String{
			var hn:String = null;
			var ary:Array = ha.toArray();
			if(ary != null){
				for(var i:int =0;i<ary.length;i++){
					var p:Point = ary[i] as Point;
					if(p != null){
						var pn:String = MapPointsManager.createPointHashName(p);
						if(hn == null){
							hn = pn;
						}
						else {
							hn += "-" +pn;
						}
					}
				}
				hn = MD5.hash(hn);
			}
			return hn;
		}
		
		/**
		 * 获得一个点的哈希名字 key 
		 * @param point 点坐标
		 * @return 哈希名字 key
		 * 
		 */		
		public static function createPointHashName(point:Point):String {
			var str:String = String(point.x) + "|" + String(point.y);
			str = MD5.hash(str);
			return str;
		}
		
		public function get currentPointAry():HashVector
		{
			return _currentPointAry;
		}

		public function get mapAreaDOAry():HashVector
		{
			return _mapAreaDOAry;
		}

		public function get hitTestDvaluePoint():Point
		{
			return _hitTestDvaluePoint;
		}

		public function set hitTestDvaluePoint(value:Point):void
		{
			_hitTestDvaluePoint = value;
		}


	}
}