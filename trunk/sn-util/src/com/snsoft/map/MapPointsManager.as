package com.snsoft.map
{
	import com.snsoft.map.util.HashArray;
	import com.snsoft.map.util.HitTest;
	
	import flash.geom.Point;

	public class MapPointsManager
	{
		
		//当前画线的点数组
		private var currentPointAry:HashArray = new HashArray();
		
		//所有点的数组的数组
		private var pointAryAry:HashArray = new HashArray();
		
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
		
		/**
		 * 测试点得到碰撞状态和碰撞点 
		 * @param point
		 * 
		 */		
		public function hitTestPoint(point:Point):MapPointManagerState{
			
			//获得碰撞点
			var pht:Point = this.hitTest.findPoint(point,HIT_TEST_DVALUE_POINT);
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
				for(var i:int = 0;i<cpa.length;i++){ 
					var p:Point = cpa.findByIndex(i)as Point;
					if(hitTest.isHit2Point(point,p,HIT_TEST_DVALUE_POINT)){
						isInCpa = true;
						break;
					}
				}
			}
			
			//判断是否碰撞
			var isHit:Boolean = false;
			if (pht != null) {
				isHit = true;
			}
			
			var mpms:MapPointManagerState = new MapPointManagerState();
			if(isClose) {//如果闭合链了
				mpms.hitPoint = pht;
				mpms.pointState = IS_CLOSE;
			}
			else if(isInCpa){//如果在当前链上，且不闭合
				mpms.hitPoint = point;
				mpms.pointState = IS_IN_CPA;
			}
			else if (isHit) {//如果碰撞了，但不在当前链上
				mpms.hitPoint = point;
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
			var hp:Point = mpms.hitPoint;
			if(mpms.isState(IS_CLOSE)) {//如果闭合链了
				this.addPointToCpaAndHt(hp);
				this.addCpaToPpa();
				this.tracePointAryAry(this.pointAryAry);//////////////////////////////////////测试用，最后删除
			}
			else if(mpms.isState(IS_IN_CPA)){//如果在当前链上，且不闭合
				//什么都不做 
			}
			else if (mpms.isState(IS_HIT)) {//如果碰撞了，但不在当前链上
				//什么都不做 
			}
			else {//其它情况
				this.addPointToCpaAndHt(hp);
			} 
			return mpms;
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
			this.currentPointAry = new HashArray();
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
			for(var i:int =0;i<pointAryAry.length;i++){
				var ha:HashArray = pointAryAry[i] as HashArray;
				if(ha != null){
					trace(ha.getArray());
				}
			}
		}
	}
}