package tvc 
{
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.geom.*;
	import flash.display.*;
	public class DrawPole {
		private var lineColor:uint = 0x000000;
		private var bgColor:uint = 0x00FF00;
		private var height:Number = 0;
		private var width:Number = 0;
		private var x = 0;
		private var y = 0;
		private var boder:Number = 1;
		private var fillColors:Array = [0xFFFFFF, 0x000000];

		/**
		 * 
		 */
		public function DrawPole (boder:Number,lineColor:uint,fillColors:Array,height:Number,width:Number,x:Number,y:Number) {
			this.lineColor = lineColor;
			this.height = height;
			this.width = width;
			this.x = x;
			this.y = y;
			this.fillColors = fillColors;
			this.boder = boder;
		}
		/**
		 * 
		 */
		public function getPole ():MovieClip {
			var moviec:MovieClip = new MovieClip();
			var shape:Shape = this.drawEllipse(this.x,this.y-this.width/4);
			var shape2:Shape = this.drawRect(this.x,this.y-this.height);
			var shape3:Shape = this.drawEllipse2(this.x,this.y-this.height-this.width/4);
			var shape4:Shape = this.drawLine();
			moviec.addChild (shape);
			moviec.addChild (shape2);
			moviec.addChild (shape3);
			moviec.addChild (shape4);
			return moviec;
		}
		public function drawLine ():Shape {
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(this.boder,0xffffff,1);
			var fillType:String = GradientType.LINEAR;
			var colors:Array = this.fillColors;
			var alphas:Array = [100, 100];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox (this.width+1, this.height, 0,x-1,this.y);
			var spreadMethod:String = SpreadMethod.PAD;
			shape.graphics.lineGradientStyle (fillType,colors,alphas,ratios,matr,spreadMethod);
			shape.graphics.moveTo (this.x,this.y );
			shape.graphics.lineTo (this.x+this.width,this.y );
			return shape;
		}
		public function drawRect (x:Number,y:Number):Shape {
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(this.boder,this.lineColor,1);
			var fillType:String = GradientType.LINEAR;
			var colors:Array = this.fillColors;
			var alphas:Array = [100, 100];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox (this.width+1, this.height, 0,x-1,this.y);
			var spreadMethod:String = SpreadMethod.PAD;
			shape.graphics.beginGradientFill (fillType, colors, alphas, ratios, matr, spreadMethod);
			//shape.graphics.beginFill (this.bgColor,1);
			shape.graphics.drawRect (x-1,y,this.width+1,this.height);
			//shape.graphics.endFill ();
			shape.graphics.endFill ();
			return shape;
		}
		public function drawEllipse (x:Number,y:Number):Shape {
			var shape:Shape = new Shape();
			shape.graphics.lineStyle (this.boder,this.lineColor,1);
			var fillType:String = GradientType.LINEAR;
			var colors:Array = this.fillColors;
			var alphas:Array = [100, 100];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox (this.width, this.height, 0,x,this.y);
			var spreadMethod:String = SpreadMethod.PAD;
			shape.graphics.beginGradientFill (fillType, colors, alphas, ratios, matr, spreadMethod);
			//shape.graphics.beginFill (this.bgColor,1);
			shape.graphics.drawEllipse (x,y,this.width,this.width*0.5);
			shape.graphics.endFill ();
			return shape;
		}
		public function drawEllipse2 (x:Number,y:Number):Shape {
			var shape:Shape = new Shape();
			shape.graphics.lineStyle (this.boder,this.lineColor,1);
			var fillType:String = GradientType.LINEAR;
			var colors:Array = [this.fillColors[1],this.fillColors[0]];
			var alphas:Array = [100, 100];
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox (this.width, this.height, 0,x,this.y);
			var spreadMethod:String = SpreadMethod.PAD;
			shape.graphics.beginGradientFill (fillType, colors, alphas, ratios, matr, spreadMethod);
			//shape.graphics.beginFill (this.bgColor,1);
			shape.graphics.drawEllipse (x,y,this.width,this.width*0.5);
			shape.graphics.endFill ();
			return shape;
		}
	}
}