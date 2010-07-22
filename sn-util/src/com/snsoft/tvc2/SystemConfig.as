package com.snsoft.tvc2{
	import flash.geom.Point;
	/**
	 * 系统常用静态参数 
	 * @author Administrator
	 * 
	 */
	public class SystemConfig{
		
		/**
		 * 小数计算比较时，小于这个数视为相等
		 */		
		public static const NUMBER_CORRECT:Number = 0.001;
		
		/**
		 * 场景宽高
		 */		
		public static const stageSize:Point = new Point(720,576);
		
		/**
		 * 场景帧率
		 */		
		public static const stageFrameRate:int = 24;
		
		public function SystemConfig(){
		}
	}
}