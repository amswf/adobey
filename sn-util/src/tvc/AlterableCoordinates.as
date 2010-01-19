package tvc{
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import com.snsoft.font.EmbedFonts;

	public class AlterableCoordinates {

		private static var isInFont:Boolean = true;

		//x轴长度
		private var X_CoordinateAxisLength:Number = 0;

		//y轴长度
		private var Y_CoordinateAxisLength:Number = 0;

		//x轴刻度个数
		private var X_GraduationNum:Number = 0;

		//y轴刻度个数
		private var Y_GraduationNum:Number = 0;

		//原点的x坐标
		private var PointO_X:Number = 0;

		//原点的y坐标
		private var PointO_Y:Number = 0;

		//x最小值
		private var min_x:Number = 1000000;

		//x最大值
		private var max_x:Number = 0;

		//y最小值
		private var min_y:Number = 1000000;

		//y最大值
		private var max_y:Number = 0;

		//红点序列
		private var redPointArray:Array = new Array();

		//蓝点序列
		private var bluePointArray:Array = new Array();

		//红点序列实际坐标
		private var trueValueredPointAry:Array = new Array();

		//蓝点序列实际坐标
		private var trueValuebluePointAry:Array = new Array();

		//线色
		private var color:uint = 0x000000;

		private var lineOrPole:String = "LINE";

		private static var fontArray:Array = new Array();//"SimHei","STXihei","YouYuan","MicrosoftYaHei");

		/**
		 * 构造方法：
		 */
		public function AlterableCoordinates(
		 xcal:Number, ycal:Number, 
		 xgn:Number, ygn:Number, 
		 po_x:Number, po_y:Number, 
		 redPointArray:Array,
		 bluePointArray:Array,
		 lp:String
		 ):void {

			fontArray["黑体"] = "MicrosoftYaHei";
			fontArray["华文细黑"] = "MicrosoftYaHei";
			fontArray["幼圆"] = "MicrosoftYaHei";
			fontArray["微软雅黑"] = "MicrosoftYaHei";

			this.X_CoordinateAxisLength = xcal;
			this.Y_CoordinateAxisLength = ycal;
			this.X_GraduationNum = xgn;
			this.Y_GraduationNum = ygn;
			this.PointO_X = po_x;
			this.PointO_Y = po_y;
			this.redPointArray = redPointArray;
			this.bluePointArray = bluePointArray;
			this.lineOrPole = lp;
			//找到坐标中 x y 的最大值和最小值
			if (redPointArray != null && bluePointArray != null) {
				for (var i:int = 0; i < redPointArray.length; i ++) {
					var point:PointCoordinate = redPointArray[i];
					if (point.getX() > this.max_x) {
						this.max_x = point.getX();
					}
					if (point.getX() < this.min_x) {
						this.min_x = point.getX();
					}
					if (point.getY() > this.max_y) {
						this.max_y = point.getY();
					}
					if (point.getY() < this.min_y) {
						this.min_y = point.getY();
					}
				}
				for (i = 0; i < bluePointArray.length; i ++) {
					point = bluePointArray[i];
					if (point.getX() > this.max_x) {
						this.max_x = point.getX();
					}
					if (point.getX() < this.min_x) {
						this.min_x = point.getX();
					}
					if (point.getY() > this.max_y) {
						this.max_y = point.getY();
					}
					if (point.getY() < this.min_y) {
						this.min_y = point.getY();
					}
				}

				if (this.lineOrPole == "LINE") {
					this.min_y = getBaseValue(this.min_y);
				}
				else if (this.lineOrPole == "POLE") {
					this.min_y = 0;
				}
				this.max_y = getNewMaxY(this.min_y,this.max_y,this.Y_GraduationNum)
				;

			}
		}

		/**
		 * 返回Y轴分段值,这个值有一位有效数字且为 1 2 5 中的一个.
		 */
		public function getNewMaxY(min:Number,max:Number,ygn:Number):Number {
			var graduationY = (this.max_y - this.min_y)/ygn;
			var power:Number = 1;
			while ( graduationY < 1) {
				graduationY *= 10;
				power*=10;
			}
			while ( graduationY > 10) {
				graduationY/=10;
				power/=10;
			}
			if (graduationY<1) {
				graduationY=1.00;
			}
			else if ( graduationY < 2 ) {
				graduationY=2.00;
			}
			else if ( graduationY < 5 ) {
				graduationY=5.00;
			}
			else {
				graduationY=10;
			}
			return (graduationY * ygn / power + min);
		}

		/**
		 * 获得一个值,如果这个值大于1,取这个数的整数,如果这个值小于1则取一位有效数字.
		 */
		public function getBaseValue(num:Number):Number {
			var power:int=1;
			while (num < 1) {
				num*=10;
				power*=10;
			}
			if ((num * 10) % 10 == 0) {
				num*=10;
				num-=5;
				power*=10;
			}
			var inum:int=int(num);
			num=Number(inum)/power*1.001;
			return num;
		}
		/**
		 * 
		 */
		public function getShapedefault():Shape {
			return this.getShape(0x000000,1,100);
		}
		/**
		 * 置线的颜色、线宽、透明度：
		 */
		public function getShape(borderColor:uint, borderSize:int, alpha:Number ):Shape {
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(borderSize, borderColor, alpha);
			this.color=borderColor;
			return shape;
		}
		public function line(fx:Number,fy:Number,tx:Number,ty:Number,shape:Shape):void {
			var sc:StageCoordinates=new StageCoordinates(this.PointO_X,this.PointO_Y);
			shape.graphics.moveTo(sc.getPoint_X(fx),sc.getPoint_Y(fy));
			shape.graphics.lineTo(sc.getPoint_X(tx),sc.getPoint_Y(ty));
		}
		public function texts(size:int,font:String,bold:Boolean,color:uint,text:String,x:Number,y:Number,moviec:MovieClip):void {
			var sc:StageCoordinates=new StageCoordinates(this.PointO_X,this.PointO_Y);
			var format:TextFormat = new TextFormat();
			format.size=size;
			//format.font=font;
			format.color=color;
			format.bold=bold;
			var text_x:TextField = new TextField();
			text_x.selectable=false;
			text_x.text=text.substring(0,4);
			text_x.setTextFormat(format);
			text_x.x=sc.getPoint_X(x);
			text_x.y=sc.getPoint_Y(y);

			AlterableCoordinates.setAntiAliasType(text_x,font);

			moviec.addChild(text_x);
		}
		/**
		 * 
		 */
		public function outputText(align:String,width:Number,height:Number,size:int,font:String,bold:Boolean,color:uint,text:String,x:Number,y:Number,moviec:MovieClip):void {
			var sc:StageCoordinates=new StageCoordinates(this.PointO_X,this.PointO_Y);
			var format:TextFormat = new TextFormat();
			format.size=size;
			//format.font=font;
			format.color=color;
			format.bold=bold;
			format.align=align;
			var text_x:TextField = new TextField();
			text_x.selectable=false;
			text_x.text=text;
			text_x.width=width;
			text_x.height=height;
			text_x.setTextFormat(format);
			text_x.x=sc.getPoint_X(x);
			text_x.y=sc.getPoint_Y(y);

			AlterableCoordinates.setAntiAliasType(text_x,font);

			moviec.addChild(text_x);
		}

		/**
		 * 
		 */
		public static function setAntiAliasType(tfd:TextField,fontName:String):void {
			//trace("setAntiAliasType");
			var t:TextField=tfd;
			var tft:TextFormat=t.getTextFormat();
			//trace(tft.font);
			var fontEnName:String=fontName;
			//trace(fontEnName);
			if (AlterableCoordinates.isInFont) {
				if (fontEnName!=null) {
					fontEnName=fontArray[fontEnName];
					if (fontEnName!=null) {
						fontEnName=EmbedFonts.findFontByName(fontEnName);
						if (fontEnName!=null) {
							//trace(fontEnName);
							tft.font=fontEnName;
							t.setTextFormat(tft);
							t.antiAliasType=AntiAliasType.ADVANCED;
							t.gridFitType=GridFitType.PIXEL;
							t.embedFonts=true;
						}
					}
				}
			}
			else {
				tft.font=fontName;
				t.setTextFormat(tft);
			}
		}


		/**
		 * 
		 */
		public function drawRectAndFill(px:Number,py:Number,pw:Number,ph:Number,lineColor:uint,areaColor:uint,moviec:MovieClip):void {
			var sc:StageCoordinates=new StageCoordinates(this.PointO_X,this.PointO_Y);
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(2,lineColor,1);
			shape.graphics.beginFill(areaColor,1);
			shape.graphics.drawRect(sc.getPoint_X(px),sc.getPoint_Y(py),pw,ph);
			shape.graphics.endFill();
			moviec.addChild(shape);
		}
		/**
		 * 画图,画坐标轴:
		 */
		public function dodraw(shape:Shape,moviec:MovieClip):void {
			var grid_x:Number=this.X_CoordinateAxisLength/this.X_GraduationNum;
			var grid_y:Number=this.Y_CoordinateAxisLength/this.Y_GraduationNum;
			line(0,-5,0,this.Y_CoordinateAxisLength+20,shape);
			line(-5,0,this.X_CoordinateAxisLength+grid_x,0,shape);

			var ride_x:Number=this.min_x;
			var gridValue_x = (this.max_x - this.min_x)/this.X_GraduationNum;
			var maxi:int=this.redPointArray.length-2;//去掉"本周",和"下周"的数据,余下的为"前X天"
			var textX:String="";

			var textXArray:Array = new Array();
			var weekN:int=maxi;//第X周,X的最大值
			for (var i:int = 0; i < maxi; i ++) {
				textX="前"+weekN+"周";
				textXArray.push(textX);
				weekN--;
			}
			textXArray.push("本周");
			textXArray.push("下周");

			for (i= 0; i <= this.X_GraduationNum; i ++) {
				line(i*grid_x,0,i*grid_x,5,shape);
				//this.texts(18,"华文细黑",false,this.color,textXArray[i],i*grid_x-5,-10  ,moviec);
				this.outputText("left",200,100,18,"华文细黑",true,0x000000,textXArray[i],i*grid_x-5,-10,moviec);
				//this.texts(18,"黑体",false,this.color,""+ride_x,i*grid_x-5,-10  ,moviec);
				ride_x+=gridValue_x;
			}
			var ride_y:Number=this.min_y;
			var gridValue_y = (this.max_y - this.min_y)/this.Y_GraduationNum;
			for (i = 0; i <= this.Y_GraduationNum; i ++) {
				line(0,i*grid_y,5,i*grid_y,shape);
				this.texts(18,"黑体",false,this.color,""+ride_y,-50,i*grid_y+10,moviec);
				ride_y+=gridValue_y;
			}
		}
		/**
		 * 画线图X轴坐标值
		 */
		public function drawXGradTextOfLine(movie:MovieClip):void {
			var maxi:int=this.redPointArray.length-3;//去掉"本周",和"下周"的数据,余下的为"前X天"
			var textX:String="";
			var textXArray:Array = new Array();
			var weekN:int=maxi+1;//第X周,X的最大值
			for (var i:int = 0; i < maxi; i ++) {
				textX="前"+weekN+"周";
				textXArray.push(textX);
				weekN--;
			}
			textXArray.push("本周");
			textXArray.push("下周");
			//得到的结果为:前N周...前2周,前1周,本周,下周.
			for (var j:int = 0; j < textXArray.length; j ++) {
				var pc:PointCoordinate=new PointCoordinate(0,0);
				var reda=this.gettrueValueRedPointAry();
				pc=reda[j];
				outputText("left",200,100,18,"华文细黑",true,0x000000,textXArray[j],pc.getX(),-10,movie);
			}
		}
		/**
		 * 转换红点序列坐标：
		 */
		public function gettrueValueRedPointAry():Array {
			var trueAry:Array = new Array();
			if (this.redPointArray!=null) {
				for (var i:int = 0; i < redPointArray.length; i ++) {
					var point:PointCoordinate=redPointArray[i];
					var sc:StageCoordinates=new StageCoordinates(this.PointO_X,this.PointO_Y);
					var truePoint:PointCoordinate=new PointCoordinate(0,0);
					var grid_x:Number = (this.max_x-this.min_x)/this.X_GraduationNum;
					var grid_y:Number = (this.max_y-this.min_y)/this.Y_GraduationNum;
					truePoint.setX(sc.getPoint_X((point.getX()-this.min_x)*this.X_CoordinateAxisLength/(this.max_x-this.min_x)));
					truePoint.setY(sc.getPoint_Y((point.getY()-this.min_y)*this.Y_CoordinateAxisLength/(this.max_y-this.min_y)));
					trueAry.push(truePoint);

				}
			}
			return trueAry;
		}
		/**
		 * 转换蓝点序列坐标：
		 */
		public function gettrueValueBluePointAry():Array {
			var trueAry:Array = new Array();
			if (this.bluePointArray!=null) {
				for (var i:int = 0; i < bluePointArray.length; i ++) {
					var point:PointCoordinate=bluePointArray[i];
					var sc:StageCoordinates=new StageCoordinates(this.PointO_X,this.PointO_Y);
					var truePoint:PointCoordinate=new PointCoordinate(0,0);
					var grid_x:Number = (this.max_x-this.min_x)/this.X_GraduationNum;
					var grid_y:Number = (this.max_y-this.min_y)/this.Y_GraduationNum;
					truePoint.setX(sc.getPoint_X((point.getX()-this.min_x)*this.X_CoordinateAxisLength/(this.max_x-this.min_x)));
					truePoint.setY(sc.getPoint_Y((point.getY()-this.min_y)*this.Y_CoordinateAxisLength/(this.max_y-this.min_y)));
					trueAry.push(truePoint);
				}
			}
			return trueAry;
		}
		/**
		 * 
		 */
		public function getPointO_X():Number {
			return this.PointO_X;
		}
		/**
		 * 
		 */
		public function getPointO_Y():Number {
			return this.PointO_Y;
		}
		/**
		 * 
		 */
		public function getX_GraduationNum():Number {
			return this.X_GraduationNum;
		}
		/**
		 * 
		 */
		public function getY_GraduationNum():Number {
			return this.Y_GraduationNum;
		}
	}
}