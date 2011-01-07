package com.snsoft.wayfinding{
	import com.snsoft.util.HashVector;
	
	import flash.geom.Point;
	
	public class WayFinding{
		
		private var ivv:Vector.<Vector.<Boolean>>;
		
		public function WayFinding(ivv:Vector.<Vector.<Boolean>>){
			this.ivv = ivv;
		}
		
		public function find(from:Point,to:Point):void{
			
			var printhv:HashVector = new HashVector();
			var waypv:HashVector = new HashVector();
			var findedvhv:Vector.<HashVector> = new Vector.<HashVector>();
			finding(from,to,waypv,printhv,findedvhv);
		}
		
		private function finding(from:Point,to:Point,waypv:HashVector,printhv:HashVector,findedvhv:Vector.<HashVector>):void{
			var poName:String = creatPointName(from);
			waypv.push(from,poName);
			var pv:Vector.<Point> = adjacency4Point(from);
			for(var i:int = 0;i<pv.length;i++){
				var nfrom:Point = pv[i];
				var prName:String = creatPringName(from,nfrom);
				var npoName:String = creatPointName(nfrom);
				
				if(nfrom.equals(to)){
					waypv.push(to);
					findedvhv.push(waypv);
					trace("找到一条路：" + waypv.length);
					trace(Vector.<Point>(waypv.toVector()));
					break;
				}
				else if( printhv.findByName(prName) == null && waypv.findByName(npoName) == null){
					printhv.push(nfrom, prName);
					var nwaypv:HashVector = waypv.copy(); 
					finding(nfrom,to,nwaypv,printhv,findedvhv);
				}
			}
		}
		
		
		private function mergePrintHv(p:Point,waypv:HashVector,findedvhv:Vector.<HashVector>):Boolean{
			var poName:String = creatPointName(p);
			var sign:Boolean = false;
			for(var i:int = 0;i<findedvhv.length;i++){
				var hv:HashVector = findedvhv[i];
				var findex:int = hv.findIndexByName(poName);
				if(findex >= 0){
					sign = true;
					var nwaypv:HashVector = waypv.copy(); 
					nwaypv.push(p,creatPointName(p));
					for(var j:int = findex + 1;j<hv.length;j++){
						var fpoName:String = hv.findNameByIndex(j);
						nwaypv.push(hv.findByIndex(j),fpoName);
					}
					findedvhv.push(nwaypv);
					trace("找到一条路：" + nwaypv.length);
					trace(Vector.<Point>(nwaypv.toVector()));
				}
			}
			return sign;
		}
		
		
		private function copyPointVector(pv:Vector.<Point>):Vector.<Point>{
			var cpv:Vector.<Point> = new Vector.<Point>();
			for(var i:int = 0;i<pv.length;i++){
				cpv.push(new Point(pv[i].x,pv[i].y));
			}
			return cpv;
		}
		
		private function creatPringName(p1:Point,p2:Point):String{
			return creatPointName(p1) +"-"+ creatPointName(p2);
		} 
		
		private function creatPointName(p:Point):String{
			return p.x + "_" + p.y;
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
				bp.y = p.x;
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