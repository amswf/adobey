package com.snsoft.tvc2.chart{
	import com.snsoft.util.SpriteUtil;
	import com.snsoft.util.TextFieldUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.messaging.channels.StreamingAMFChannel;
	
	
	[Style(name="coorAxesX_default_skin", type="Class")]
	
	[Style(name="coorAxesY_default_skin", type="Class")]
	
	[Style(name="graduationLineX_default_skin", type="Class")]
	
	[Style(name="graduationLineY_default_skin", type="Class")]
	
	[Style(name="graduationX_default_skin", type="Class")]
	
	[Style(name="graduationY_default_skin", type="Class")]
	
	[Style(name="myTextFormat", type="Class")]
	
	
	public class UICoor extends UIComponent{
		
		private var coorSprite:Sprite;
		
		private var _xGradNum:int = 5;
		
		private var _yGradNum:int = 5;
		
		private var _xGradVector:Vector.<String>;
		
		private var _yGradVector:Vector.<String>;
		
		private var xGradType:String = GRAD_TYPE_POINT;
		
		private var yGradType:String = GRAD_TYPE_POINT;
		
		public static const GRAD_TYPE_POINT:String = "POINT";
		
		public static const GRAD_TYPE_AREA:String = "AREA";
		
		/**
		 * 
		 * @param xGradNum x 轴刻度个数
		 * @param yGradNum y 轴刻度个数
		 * @param xGradValue x 轴单位刻度代表的坐标值
		 * @param yGradValue y 轴单位刻度代表的坐标值
		 * 
		 */		
		public function UICoor(xGradVector:Vector.<String> = null,yGradVector:Vector.<String> = null,xGradType:String = "POINT" ,yGradType:String = "POINT"){
			super();
			if(xGradVector != null && yGradVector != null){
				this.xGradVector = xGradVector;
				this.yGradVector = yGradVector;
			}
			
			this.xGradType = xGradType;
			this.yGradType = yGradType;
			
		}
		
		public static const COOR_AXES_X_DEFAULT_SKIN:String = "coorAxesX_default_skin";
		
		public static const COOR_AXES_Y_DEFAULT_SKIN:String = "coorAxesY_default_skin";
		
		public static const GRADUATION_LINE_X_DEFAULT_SKIN:String = "graduationLineX_default_skin";
		
		public static const GRADUATION_LINE_Y_DEFAULT_SKIN:String = "graduationLineY_default_skin";
		
		public static const GRADUATION_X_DEFAULT_SKIN:String = "graduationX_default_skin";
		
		public static const GRADUATION_Y_DEFAULT_SKIN:String = "graduationY_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			coorAxesX_default_skin:"CoorAxesX_default_skin",
			coorAxesY_default_skin:"CoorAxesY_default_skin",
			graduationLineX_default_skin:"GraduationLineX_default_skin",
			graduationLineY_default_skin:"GraduationLineY_default_skin",
			graduationX_default_skin:"GraduationX_default_skin",
			graduationY_default_skin:"GraduationY_default_skin",
			myTextFormat:new TextFormat("宋体",13,0x000000)
		};
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public static function getStyleDefinition():Object { 
			return UIComponent.mergeStyles(UIComponent.getStyleDefinition(), defaultStyles);
		}
		
		/**
		 * 
		 * 
		 */				
		override protected function configUI():void{			
			this.invalidate(InvalidationType.ALL,true);
			this.invalidate(InvalidationType.SIZE,true);
			this.width = 400;
			this.height = 300;
			super.configUI();	
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			if(this.xGradVector != null && this.yGradVector != null){
				if(this.xGradVector.length > 0 && this.yGradVector.length > 0){
					com.snsoft.util.SpriteUtil.deleteAllChild(this);
					
					var coorWidth:Number = this.width;
					var coorHeight:Number = this.height;
					
					//			var gradXSkinH:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_X_DEFAULT_SKIN)) as MovieClip;
					//			var gradYSkinW:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_Y_DEFAULT_SKIN)) as MovieClip;
					//			
					//			coorWidth -= gradYSkinW.width;
					//			coorHeight -= gradXSkinH.height;
					
					//坐标系对象
					this.coorSprite = new Sprite();
					this.addChild(this.coorSprite);
					
					//添加坐标轴
					var axesXSkin:MovieClip = getDisplayObjectInstance(getStyleValue(COOR_AXES_X_DEFAULT_SKIN)) as MovieClip;
					var axesYSkin:MovieClip = getDisplayObjectInstance(getStyleValue(COOR_AXES_Y_DEFAULT_SKIN)) as MovieClip;
					
					axesXSkin.width = coorWidth;
					axesXSkin.height = 8;
					
					axesYSkin.width = 8;
					axesYSkin.height = coorHeight;			
					
					this.coorSprite.addChild(axesYSkin);
					this.coorSprite.addChild(axesXSkin);
					
					//x刻度
					var xgn:Number = xGradVector.length;
					var xTextX:Number = 0;
					if(this.xGradType == GRAD_TYPE_AREA){
						this._xGradNum = xgn + 1;
					}
					
					var ygn:Number = yGradVector.length;
					var yTextY:Number = 0;
					if(this.yGradType == GRAD_TYPE_AREA){
						this._yGradNum = ygn + 1;
					}
					
					//刻度间隔长度
					var xlen:Number = coorWidth / (this.xGradNum - 1);
					var ylen:Number = coorHeight / (this.xGradNum - 1);
					
					if(this.xGradType == GRAD_TYPE_AREA){
						xTextX = xlen;
					}
					
					if(this.yGradType == GRAD_TYPE_AREA){
						yTextY = ylen;
					}
					
					for(var i:int = 0;i < this.xGradNum;i++){
						var gradXSkin:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_X_DEFAULT_SKIN)) as MovieClip;
						gradXSkin.x = i * xlen;
						this.coorSprite.addChild(gradXSkin);					
					}
					
					//y刻度
					for(var j:int = 0;j < this.xGradNum;j++){
						var gradYSkin:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_Y_DEFAULT_SKIN)) as MovieClip;
						gradYSkin.y = - j * ylen;
						this.coorSprite.addChild(gradYSkin);
						
						if(j > 0){
							var gradLineYSkin:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_LINE_Y_DEFAULT_SKIN)) as MovieClip;
							gradLineYSkin.y = - j * ylen;
							gradLineYSkin.width = coorWidth;
							this.coorSprite.addChild(gradLineYSkin);
						}
					}
					
					//把两坐标轴的交点做为原点，移动坐标系，y平移
					var coorRect:Rectangle = this.coorSprite.getRect(this);
					var tlPoint:Point = coorRect.topLeft;
					this.coorSprite.y = - tlPoint.y;
					//this.coorSprite.x = - tlPoint.x;
					
					var gradXSkinH:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_X_DEFAULT_SKIN)) as MovieClip;
					var gradYSkinW:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_Y_DEFAULT_SKIN)) as MovieClip;
					
					//x刻度文字
					for(var ii:int = 0;ii < xgn;ii++){
						
						var tfd:TextField = new TextField();
						var tft:TextFormat = getStyleValue(TEXT_FORMAT) as TextFormat;
						tfd.text = this.xGradVector[ii];
						tfd.selectable = false;
						this.coorSprite.addChild(tfd);
						tfd.setTextFormat(tft);
						TextFieldUtil.fitSize(tfd);
						tfd.x = ii * xlen - tfd.width * 0.5 + xTextX * 0.5;
						tfd.y = gradXSkinH.height;
						
					}
					
					//y刻度文字
					for(var jj:int = 0;jj < ygn;jj++){
						var tfdy:TextField = new TextField();
						var tfty:TextFormat = getStyleValue(TEXT_FORMAT) as TextFormat;
						tfdy.text = this.yGradVector[jj];
						tfdy.selectable = false;
						
						this.coorSprite.addChild(tfdy);
						tfdy.setTextFormat(tfty);
						TextFieldUtil.fitSize(tfdy);
						tfdy.x = - tfdy.width - gradYSkinW.width;
						tfdy.y = - jj * ylen - tfdy.height * 0.5 - yTextY * 0.5;
					}
				}
			}
		}
		
		public function get xGradVector():Vector.<String>
		{
			return _xGradVector;
		}
		
		public function set xGradVector(value:Vector.<String>):void
		{
			_xGradVector = value;
		}
		
		public function get yGradVector():Vector.<String>
		{
			return _yGradVector;
		}
		
		public function set yGradVector(value:Vector.<String>):void
		{
			_yGradVector = value;
		}		

		public function get yGradNum():int
		{
			return _yGradNum;
		}

		public function get xGradNum():int
		{
			return _xGradNum;
		}

		
	}
}