﻿package tvc 
{
	import flash.display.*;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.*;
	public class DrawPole {
		private var lineColor:int = 0x000000;
		private var bgColor:int = 0x00FF00;
		private var height:Number = 0;
		private var width:Number = 0;
		private var x:Number = 0;
		private var y:Number = 0;
		private var boder:Number = 1;
		private var fillColors:Array = [0xFFFFFF, 0x000000];
		private var fillColors2:Array = [0xFFFFFF, 0x000000];

		/**
		 * 
		 */
		public function DrawPole (boder:Number,lineColor:int,fillColors:Array,fillColors2:Array,height:Number,width:Number,x:Number,y:Number) {
			this.lineColor = lineColor;
			this.height = height;
			this.width = width;
			this.x = x;
			this.y = y;
			this.fillColors = fillColors;
			this.fillColors2 = fillColors2;
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
			var alphas:Array = [100,100, 100];
			var ratios:Array = [0x00,127, 0xFF];
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
			var alphas:Array = [100,100, 100];
			var ratios:Array = [0x00,127, 0xFF];
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
			var alphas:Array = [100,100, 100];
			var ratios:Array = [0x00,127, 0xFF];
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
			var colors:Array = this.fillColors2;
			var alphas:Array = [100,100,100];
			var ratios:Array = [0,127,0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox (this.width, this.width*0.5, Math.PI / 2,0,0);
			var spreadMethod:String = SpreadMethod.PAD;
			shape.graphics.beginGradientFill (fillType, colors, alphas, ratios, matr);
			//shape.graphics.beginFill (this.bgColor,1);
			shape.graphics.drawEllipse (0,0,this.width,this.width*0.5);
			shape.x = x;
			shape.y = y;
			shape.graphics.endFill ();
			return shape;
		}
	}
}