package
{
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Loader;
	//import fl.controls.List;
	import flash.display.IBitmapDrawable;
	
	public class MoveLine
	{
		var i:Number = 0;
		var sign:Number = 0;
		var f_x:Number = 0;
		var f_y:Number = 0;
		var t_x:Number = 0;
		var t_y:Number = 0;
		var child:Shape = null;
		var borderColor:uint = 0x000000;
		var borderSize:Number = 1;
		var alpha:Number = 100;
		var c:Number = 0;
		var speed:Number = 1;
		//var list:List = new List();
		var array:Array = new Array();
		var listOfnextIndex:int = 0;
		/**
		 * 构造方法：
		 */
		public function MoveLine(borderSize:Number,borderColor:uint,alpha:Number){
			this.borderColor = borderColor;
			this.borderSize = borderSize;
			this.alpha = alpha;
		}
		
		
		/**
		 * 获得影片剪辑，目的是放到场景中去：
		 */
		public function getMovieClip():Shape {
			//创建一个图形：
			child = new Shape();
				
			//设置图形属性：
			child.graphics.lineStyle(this.borderSize,this.borderColor,this.alpha);
			
			//把图形添加到影片剪辑中：
			 
			return child;
		}
		
		/**
		 *设置起点：
		 */
		public function setMoveTo(f_x:Number,f_y:Number):void{
			this.t_x = f_x;
			this.t_y = f_y;
			child.graphics.moveTo(f_x,f_y);
		}
		
		/**
		 * 添加画线结点：
		 */
		public function  setPoint(coor:Coordinate):void{
			//list.addChild(coor);
			array.push(coor);
		}
		
		/**
		 *监听器：指定点序列后用这个监听器：
		 */
		public function linesEnterFrameHandler(event:Event):void {
			if(array.length >=2 ){
				var coor:Coordinate = new Coordinate(); 
				//coor = list.getItemAt(this.listOfnextIndex);
				coor = array[listOfnextIndex];
				var v_x:Number = 0;
				var v_y:Number = 0;
				v_x = calculate(t_x,f_x,this.i);
				v_y = calculate(t_y,f_y,this.i);
				this.child.graphics.lineTo(v_x,v_y);
				this.i += this.speed;
				if ( this.i > this.c) {
					this.listOfnextIndex ++;
					this.child.graphics.lineTo(this.t_x,this.t_y);
					this.setLineTo(coor.getX(),coor.getY());
					if(this.listOfnextIndex >= array.length){
						this.child.removeEventListener(Event.ENTER_FRAME, lineEnterFrameHandler);
					}
				}
			}
		}
		
		
		/**
		 *监听器：指定两个点后用这个监听器：
		 */
		public function lineEnterFrameHandler(event:Event):void {
			var v_x:Number = 0;
			var v_y:Number = 0;
			v_x = calculate(t_x,f_x,this.i);
			v_y = calculate(t_y,f_y,this.i);
			this.child.graphics.lineTo(v_x,v_y);
			this.i += this.speed;
			if ( this.i > this.c) {
				this.child.graphics.lineTo(this.t_x,this.t_y);
				this.child.removeEventListener(Event.ENTER_FRAME, lineEnterFrameHandler);
			}
		}
		
		/**
		 此方法实现画图的步进点的坐标
		 **/
		private function calculate(t:Number,f:Number,i:Number):Number {
			var tfsub:Number = t-f;
			return f + tfsub * i / speed;
		}
			 
		/**
		连续画线到指定位置:
		*/
		public function setLineTo(tx:Number,ty:Number) {
			this.f_x = this.t_x;
			this.f_y = this.t_y;
			this.t_x = tx;
			this.t_y = ty;
			this.i = 0;
			var x:Number =Math.abs( this.t_x - this.f_x);
			var y:Number =Math.abs( this.t_y - this.f_y);
			var c:Number =Math.sqrt(x*x+y*y);
			this.c = c;
		}
	}
}