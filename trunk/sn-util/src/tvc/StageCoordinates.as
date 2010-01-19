package tvc
{
	
	/**
	 * class:StageCoordinates
	 * 
	 * examples:
	 * ___________________________________________________________________________________
	 * var sc:StageCoordinates = new StageCoordinates(0,stage.stageHeight);
 	 * var px:int = sc.getPoint_X(50);
 	 * var py:int = sc.getPoint_Y(100);
 	 * ___________________________________________________________________________________
	 */
	public class StageCoordinates
	{
		
		//private var stageWidth:int = 0;
		//private var stageHeight:int = 0;
		private var pointO_X:int = 0;
		private var pointO_Y:int = 0;
		
		/**
		 *构造方法：初始化参数是坐标系原点在场景中的位置
		 */
		public function StageCoordinates(pointO_X:int, pointO_Y:int):void{
			this.pointO_X = pointO_X;
			this.pointO_Y = pointO_Y;		
		}
		
		
		/**
		 * 把坐标系中的 x 坐标值转换成场景x坐标值
		 */
		public function getPoint_X(x:int):int{
			return pointO_X + x; 
		}
		
		
		/**
		 * 把坐标系中的 y 坐标值转换成场景y坐标值
		 */
		public function getPoint_Y(y:int):int{
			return this.pointO_Y - y;
		}
	}
}