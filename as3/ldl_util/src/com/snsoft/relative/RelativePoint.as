package com.snsoft.relative{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * 在可变stage下保持MC相对位置及自动宽高
	 */
	public class RelativePoint {

		public static var TOP_LEFT:String = "TOP_LEFT";

		public static var BOTTOM_LEFT:String = "BOTTOM_LEFT";

		public static var TOP_RIGHT:String = "TOP_RIGHT";

		public static var BOTTOM_RIGHT:String = "BOTTOM_RIGHT";

		private var stageWidthHeightPoint:Point = new Point(0,0);

		private var mcPointArray:Array = new Array();
		
		private var mcWidthHeightArray:Array = new Array();
		
		private var mcAutoWidthArray:Array = new Array();
		
		private var mcAutoHeightArray:Array = new Array();
		
		private var mcArray:Array = new Array();
		
		private var functionArray:Array = new Array();
		
		private var relativeTypeArray:Array = new Array();
		
		private var stage:Stage = null;

		public function RelativePoint(stageWidth:Number,stageHeight:Number,stage:Stage) {
			
			stage.align = StageAlign.TOP_LEFT;

			stage.scaleMode = StageScaleMode.NO_SCALE;

			this.stageWidthHeightPoint.x = stageWidth;

			this.stageWidthHeightPoint.y = stageHeight;
			
			this.stage = stage;

		}

		public function addMc(mc:Sprite,relativeType:String,autoWidth:Boolean = false,autoHeight:Boolean = false,fun:Function = null):void {
			
			if(relativeType ==null || relativeType == ""){
				
				relativeType = TOP_LEFT;
				
			}
			
			if (mc != null) {
				
				this.mcArray.push(mc);

				var x:Number = mc.x;

				var y:Number = mc.y;

				var p:Point = new Point(x,y);

				this.mcPointArray.push(p);
				
				var w:Number = mc.width;

				var h:Number = mc.height;

				var pwh:Point = new Point(w,h);

				this.mcWidthHeightArray.push(pwh);
				
				this.mcAutoWidthArray.push(autoWidth);
				
				this.mcAutoHeightArray.push(autoHeight);
				
				this.relativeTypeArray.push(relativeType);
				
				if(fun != null){
					
					this.functionArray.push(fun);
					
				}

			}

		}

		public function addStageResizeEventListener():void {
			
			if(mcArray.length == 0){
			
				trace("RelativePoint.mcArray 长度为 0");
			
			}
			else if(this.stageWidthHeightPoint.x <=0 || this.stageWidthHeightPoint.y <=0){
				
				trace("RelativePoint.stageWidthHeightPoint 不能为 0,0 ");
				
			}
			else{
				
				stage.addEventListener(Event.RESIZE,handlerResizeWindow);
				
			}
			
		}

		private function handlerResizeWindow(e:Event):void{
			
			for(var i:int = 0;i<mcArray.length;i++){
				
				var mc:Sprite = this.mcArray[i] as Sprite;
				
				var relativeType:String = this.relativeTypeArray[i] as String;
				
				var mcp:Point = this.mcPointArray[i] as Point;
				
				var mcwh:Point = this.mcWidthHeightArray[i] as Point;
				
				var aw:Boolean = this.mcAutoWidthArray[i] as Boolean;
				
				var ah:Boolean = this.mcAutoHeightArray[i] as Boolean;
				
				this.setNewPoint(mc,relativeType,mcp,mcwh,aw,ah);
				
				var fun:Function = this.functionArray[i] as Function;
				
				if(fun != null){
					
					fun.call();
				
				}
				
			}
			
		}

		private function setNewPoint(mc:Sprite,relativeType:String,mcPoint:Point,mcwh:Point,autoWidth:Boolean,autoHeight:Boolean):void {
			
			var type:String = relativeType;
			
			if (type != null && type != "") {
				
				var stageBaseWidth:Number = this.stageWidthHeightPoint.x;
				
				var stageBaseHeight:Number = this.stageWidthHeightPoint.y;

				var mcx:Number = mcPoint.x + stage.stageWidth - stageBaseWidth;

				var mcy:Number = mcPoint.y + stage.stageHeight - stageBaseHeight;

				var mcw:Number = stage.stageWidth - (stageBaseWidth -(mcPoint.x + mcwh.x)) - mc.x;

				var mch:Number = stage.stageHeight - (stageBaseHeight -(mcPoint.y + mcwh.y)) - mc.y;

				if (mcw < 0) {

					mcw = 1;

				}
				if (mch < 0) {

					mch = 1;
				}

				if (type == TOP_LEFT) {

					//mc.x = mcx;

					//mc.y = mcy;

					if (autoWidth) {

						mc.width = mcw;

					}
					if (autoHeight) {

						mc.height = mch;

					}

				}
				else if (type == BOTTOM_LEFT) {

					//mc.x = mcx;

					mc.y = mcy;

					if (autoWidth) {

						mc.width = mcw;

					}

				}
				else if (type == TOP_RIGHT) {

					mc.x = mcx;

					//mc.y = mcy;

					if (autoHeight) {

						mc.height = mch;

					}

				}
				else if (type == BOTTOM_RIGHT) {

					mc.x = mcx;

					mc.y = mcy;

				}

			}

		}

	}
	
}