package com.snsoft.wayfinding{
	import com.snsoft.util.HashVector;
	
	import flash.geom.Point;
	
	/**
	 * 矩阵寻路 
	 * @author Administrator
	 * 
	 */	
	public class WayFinding{
		
		/**
		 * 寻路矩阵 
		 */		
		private var ivv:Vector.<Vector.<Boolean>>;
		
		/**
		 * 找到的路径 
		 */		
		private var pv:Vector.<Point>;
		
		public function WayFinding(ivv:Vector.<Vector.<Boolean>>){
			this.ivv = ivv;
		}
		
		/**
		 * 找路径 
		 * @param from
		 * @param to
		 * @return 
		 * 
		 */		
		public function find(from:Point,to:Point):Vector.<Point>{
			
			var ivv:Vector.<Vector.<Boolean>> = copyPointVector(this.ivv);
			var frompv:Vector.<Point> = new Vector.<Point>();
			frompv.push(from);
			var heap:Way = new Way(this.ivv);
			heap.push(from);
			var n1:Number = new Date().getTime();
			finding(frompv,to,ivv,heap);
			var n2:Number = new Date().getTime();
			return pv;
		}
		
		/**
		 * 找路径叠代主方法
		 * @param frompv
		 * @param to
		 * @param ivv
		 * @param heap
		 * 
		 */		
		private function finding(frompv:Vector.<Point>,to:Point,ivv:Vector.<Vector.<Boolean>>,heap:Way):void{
			var nfromv:Vector.<Point> = new Vector.<Point>();
			for(var i:int = 0;i<frompv.length;i++){
				var from:Point = frompv[i];
				if(ivv[from.y][from.x]){
					ivv[from.y][from.x] = false;
					var npv:Vector.<Point> = adjacency4Point(from);
					for(var j:int = 0;j<npv.length;j++){
						var np:Point = npv[j];
						if(ivv[np.y][np.x]){
							heap.push(np,from);
							if(np.equals(to)){
								pv = heap.getSort(np);
								return;
							}
							else {
								nfromv.push(np);
							}
						}
					}
				}
			}
			if(nfromv.length > 0){
				finding(nfromv,to,ivv,heap);
			}
		}
		
		/**
		 *  克隆  Vector.<Vector.<Boolean>> 
		 * @param ivv
		 * @return 
		 * 
		 */		
		private function copyPointVector(ivv:Vector.<Vector.<Boolean>>):Vector.<Vector.<Boolean>>{
			var civv:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>();
			for(var i:int = 0;i<ivv.length;i++){
				var iv:Vector.<Boolean> = ivv[i];
				var civ:Vector.<Boolean> = copyVector(iv);
				civv.push(civ);
			}
			return civv;
		}
		
		/**
		 * 克隆  Vector.<Boolean>
		 * @param pv
		 * @return 
		 * 
		 */		
		private function copyVector(pv:Vector.<Boolean>):Vector.<Boolean>{
			var cpv:Vector.<Boolean> = new Vector.<Boolean>();
			for(var i:int = 0;i<pv.length;i++){
				cpv.push(pv[i]);
			}
			return cpv;
		}
		
		/**
		 * 相邻四点 
		 * @param p
		 * @return 
		 * 
		 */		
		private function adjacency4Point(p:Point):Vector.<Point>{
			var vp:Vector.<Point> = new Vector.<Point>();
			
			if (p.y > 0) {
				//trace("上面");
				var tp:Point = new Point();
				tp.x = p.x;
				tp.y = p.y - 1;
				vp.push(tp);
			}
			//下面
			if (p.y < ivv.length - 1) {
				//trace("下面");
				var bp:Point = new Point();
				bp.x = p.x;
				bp.y = p.y + 1;
				vp.push(bp);
			}
			//左面
			if (p.x > 0) {
				//trace("左面");
				var lp:Point = new Point();
				lp.x = p.x - 1;
				lp.y = p.y;
				vp.push(lp);
			}
			//右面
			if (p.x < ivv[p.y].length - 1) {
				//trace("右面");
				var rp:Point = new Point();
				rp.x = p.x + 1;
				rp.y = p.y;
				vp.push(rp);
			}
			
			return vp;
		}
	}
}