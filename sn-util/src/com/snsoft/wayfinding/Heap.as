package com.snsoft.wayfinding{
	import com.snsoft.util.HashVector;
	
	import flash.geom.Point;

	
	/**
	 * 堆排序 
	 * @author Administrator
	 * 
	 */	
	public class Heap{
		
		private var hv:HashVector = new HashVector();
		
		public function Heap(){
		
		}
		
		public function push(parent:Point,current:Point):void{
			
			var pname:String = creatPointName(parent);
			var cname:String = creatPointName(current);
			
			var pv:Vector.<Point> = hv.findByName(pname) as Vector.<Point>;
			
			var npv:Vector.<Point> = null;
			if(pv != null){
				npv = copyPointVector(pv);
			}
			else {
				npv = new Vector.<Point>();
			}
			npv.push(current);
			hv.push(npv,cname);
		}
		
		public function remove(p:Point):void{
			var name:String = creatPointName(p);
			hv.removeByName(name);
		}
		
		private function copyPointVector(pv:Vector.<Point>):Vector.<Point>{
			var cpv:Vector.<Point> = new Vector.<Point>();
			for(var i:int = 0;i<pv.length;i++){
				cpv.push(new Point(pv[i].x,pv[i].y));
			}
			return cpv;
		}
		
		public function getSort(p:Point):Vector.<Point>{
			var name:String = creatPointName(p);
			return hv.findByName(name) as Vector.<Point>;
		}
		
		private function creatPointName(p:Point):String{
			return p.x + "_" + p.y;
		}
	}
}