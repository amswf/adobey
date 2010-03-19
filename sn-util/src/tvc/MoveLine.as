package tvc
{
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Loader;
	//import fl.controls.List;
	import flash.display.IBitmapDrawable;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 
	 * 此类实现了动画画线，可以指定两个点进行画线，也可以指定一个点序列数组来画出整个图形；
	 * 
	 */

	 
	/**
	 * <指定点序列画线方法>
	 * 
	 * 把下面代码放到flash源文件的一个帧上就可以了。
	 * ____________________________________________________________________________________
	 * import MoveLine;
	 * import flash.display.MovieClip;
	 * import flash.display.Shape;
	 * var mc:MovieClip = new MovieClip();
	 * var ml:MoveLine = new MoveLine(2,0x00ff00,100,5);
	 * var shap:Shape = ml.getMovieClip();
	 * mc.addChild(shap);
	 * this.addChild(mc);
	 * ml.setPoint(50,50);
	 * ml.setPoint(100,50);
	 * ml.setPoint(100,100);
	 * ml.setPoint(150,100);
	 * ml.setPoint(150,150);
	 * ml.setPoint(200,150);
	 * shap.addEventListener(Event.ENTER_FRAME,ml.linesEnterFrameHandler);
	 * ____________________________________________________________________________________
	 */
	
	
	
	/**
	 * <第一帧上的as>
	 * <指定起点，指定下一点，进行画线>
	 * ____________________________________________________________________________________
	 * import MoveLine;
	 * import flash.display.MovieClip;
	 * import flash.display.Shape;
	 * var mc:MovieClip = new MovieClip();
	 * var ml:MoveLine = new MoveLine(2,0x00ff00,100,5);
	 * var shap:Shape = ml.getMovieClip();
	 * mc.addChild(shap);
	 * this.addChild(mc);
	 * ml.setMoveTo(50,50);
	 * ml.setLineTo(100,100);
	 * shap.addEventListener(Event.ENTER_FRAME,ml.lineEnterFrameHandler);
	 * ____________________________________________________________________________________
	 *
	 * 
	 * <第1帧之后的某一帧上的as（在这里随意指定就可以了，但间隔要适当）>
	 * <再指定下一个点，进行画线>
	 * ml.setLineTo(200,100);
 	 * shap.addEventListener(Event.ENTER_FRAME,ml.lineEnterFrameHandler);
	 * 
	 * 
	 * */
	
	public class MoveLine
	{
		var i:Number = 0;
		var sign:Number = 0;
		var f_x:Number = 0;
		var f_y:Number = 0;
		var t_x:Number = 0;
		var t_y:Number = 0;
		var line:Shape = null;
		var point:Shape = null;
		var movie:MovieClip = new MovieClip();
		var borderColor:int = 0x000000;
		var borderSize:Number = 1;
		var alpha:Number = 100;
		var c:Number = 0;
		var speed:Number = 1;
		//var list:List = new List();
		var array:Array = new Array();//结点数组(坐标值)
		var valuePointArray = new Array();//结点数组(原始值)
		var valuePoint_Y:Number = 0;
		var listOfnextIndex:int = 0;
		var points:MovieClip = new MovieClip();
		var pointWidth:Number = 0;//画结点长方形时,长方形的宽度
		var pointHeight:Number = 0;//画结点长方形时,长方形的高度
		
		
		/**
		 * 构造方法：
		 */
		public function MoveLine(	borderSize:Number,
									borderColor:int,
									alpha:Number,
									speed:int,
									pointWidth:Number,
									pointHeight:Number,
									valuePoint_Y:Number
									)
		{
			this.borderColor = borderColor;
			this.borderSize = borderSize;
			this.alpha = alpha;
			this.speed = speed;
			this.pointWidth = pointWidth;
			this.pointHeight = pointHeight;
			this.valuePoint_Y = valuePoint_Y;
			
		}
		
		
		/**
		 * 
		 * 
		 */
		public function setSpeed(speed:int):void
		{
			this.speed = speed;
		}
		
		
		/**
		 * 添加画线结点：
		 */
		public function  setPoint(x:int,y:int):void
		{
			//list.addChild(coor);
			var coor:PointCoordinate = new PointCoordinate(x,y);
			array.push(coor);
		}
		
		
		/**
		 * 添加画线结点序列：
		 */
		public function setPointAry(pa:Array,va:Array):void
		{
			this.array = pa;
			this.valuePointArray = va;
		}
		
		/**
		 * 获得线段，目的是放到场景中去：
		 */
		public function getLine():Shape 
		{
			 
			
			//创建一个图形：
			line = new Shape();
				
			//设置图形属性：
			line.graphics.lineStyle(this.borderSize,this.borderColor,this.alpha);
			
			 
			 
			return line;
		}
		
		/**
		 * 
		 */
		public function getPoints():MovieClip{
			return this.points;
		}
		
		/**
		 *设置起点：
		 */
		public function setMoveTo(f_x:Number,f_y:Number):void
		{
			this.t_x = f_x;
			this.t_y = f_y;
			line.graphics.moveTo(f_x,f_y);
			//画起点的点长方形
			var point:Shape = this.drawPoint(this.t_x,this.t_y,this.pointWidth,this.pointHeight,this.borderColor,this.borderColor);
			//var value:TextField = this.drawValue(this.
			this.points.addChild(point);
		}
		
		
		/**
		 *监听器：指定点序列后用这个监听器：
		 */
		public function linesEnterFrameHandler(event:Event):void 
		{
			if(array.length >=2 )
			{
				var coor:PointCoordinate = new PointCoordinate(0,0);
				var valueCoor:PointCoordinate = new PointCoordinate(0,0); 
				//coor = list.getItemAt(this.listOfnextIndex);
				if(listOfnextIndex == 0)
				{
					coor = array[0];
					valueCoor = valuePointArray[0];
					this.setMoveTo(coor.getX(),coor.getY());
					//画结点的实际值,表现到坐标系上
					var valuePoint:String = "" +valueCoor.getY();
					this.points.addChild(this.drawValue(coor.getX(),valuePoint_Y,this.borderColor,valuePoint.substring(0,4)));
					coor = array[1];
					valueCoor = valuePointArray[1];
					this.setLineTo(coor.getX(),coor.getY());
					//画结点的实际值,表现到坐标系上
					valuePoint = "" + valueCoor.getY();
					this.points.addChild(this.drawValue(coor.getX(),valuePoint_Y,this.borderColor,valuePoint.substring(0,4)));
					
					listOfnextIndex = 1;
				}
				var v_x:Number = 0;
				var v_y:Number = 0;
				v_x = calculate(t_x,f_x,this.i);
				v_y = calculate(t_y,f_y,this.i);
				this.line.graphics.lineTo(v_x,v_y);
				this.i += this.speed;
				if ( this.i > this.c) 
				{
					
					this.line.graphics.lineTo(this.t_x,this.t_y);
					this.line.removeEventListener(Event.ENTER_FRAME, linesEnterFrameHandler);
					//画点,长方形
					var point:Shape = this.drawPoint(this.t_x,this.t_y,this.pointWidth,this.pointHeight,this.borderColor,this.borderColor);
					this.points.addChild(point);
					this.listOfnextIndex ++;
					if(this.listOfnextIndex < array.length)
					{
						
						coor = array[listOfnextIndex];
						//画结点的实际值,表现到坐标系上
						valueCoor = valuePointArray[listOfnextIndex];
						var valuePointTo:String = "" + valueCoor.getY();
						this.points.addChild(this.drawValue(coor.getX(),valuePoint_Y,this.borderColor,valuePointTo.substring(0,4)));
						this.setLineTo(coor.getX(),coor.getY());
						this.line.addEventListener(Event.ENTER_FRAME,linesEnterFrameHandler);
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
			this.line.graphics.lineTo(v_x,v_y);
			this.i += this.speed;
			if ( this.i > this.c) 
			{
				this.line.graphics.lineTo(this.t_x,this.t_y);
				this.line.removeEventListener(Event.ENTER_FRAME, lineEnterFrameHandler);
			}
		}
		
		
		/**
		 此方法实现画图的步进点的坐标
		 **/
		private function calculate(t:Number,f:Number,i:Number):Number 
		{
			var tfsub:Number = t-f;
			return f + tfsub * i / c;
		}
			
			 
		/**
		连续画线到指定位置:
		*/
		public function setLineTo(tx:Number,ty:Number) 
		{
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
		
		/**
		 * 
		 */
		public function drawPoint(px:Number,py:Number,pw:Number,ph:Number,lineColor:int,areaColor:int):Shape{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle (2,lineColor,1);
			shape.graphics.beginFill (areaColor,1);
			shape.graphics.drawRect(px-pw/2,py-ph/2,pw,ph);
			shape.graphics.endFill();
			return shape;
		}
		/**
		 * 
		 * 
		 */
		public function drawValue(px:Number,py:Number,color:int,text:String):TextField{
			var format:TextFormat = new TextFormat();
			format.size = 18;
			//format.font = "黑体";
			format.color = color;
			var text_x:TextField = new TextField();
			text_x.selectable = false;
			text_x.text= text.substring(0,4);
			text_x.setTextFormat(format);
			AlterableCoordinates.setAntiAliasType(text_x,"黑体");
			text_x.x = px;
			text_x.y = py;
			return text_x;
		}

		/**
		 * 
		 */
		public function main():void{
			this.setPoint(50,50);
		}
	}
}