package com.snsoft.tvc2.chart{
	import com.snsoft.util.SpriteUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	
	[Style(name="coorAxesX_default_skin", type="Class")]
	
	[Style(name="coorAxesY_default_skin", type="Class")]

	[Style(name="graduationLineX_default_skin", type="Class")]

	[Style(name="graduationLineY_default_skin", type="Class")]

	[Style(name="graduationX_default_skin", type="Class")]

	[Style(name="graduationY_default_skin", type="Class")]

	public class UICoor extends UIComponent{
		
		private var coorSprite:Sprite;
		
		private var _xGradNum:int = 5;
		
		private var _yGradNum:int = 5;
		
		private var _xGradValue:int = 1;
		
		private var _yGradValue:int = 1;
		
		
		
		/**
		 * 
		 * @param xGradNum x 轴刻度个数
		 * @param yGradNum y 轴刻度个数
		 * @param xGradValue x 轴单位刻度代表的坐标值
		 * @param yGradValue y 轴单位刻度代表的坐标值
		 * 
		 */		
		public function UICoor(xGradValue:Number = 1,yGradValue:Number = 1,xGradNum:int = 5,yGradNum:int = 5){
			
			this.xGradValue = xGradValue;
			this.yGradValue = yGradValue;
			
			this.xGradNum = xGradNum;
			this.yGradNum = yGradNum;
		}
		
		public static const COOR_AXES_X_DEFAULT_SKIN:String = "coorAxesX_default_skin";
		
		public static const COOR_AXES_Y_DEFAULT_SKIN:String = "coorAxesY_default_skin";
		
		public static const GRADUATION_LINE_X_DEFAULT_SKIN:String = "graduationLineX_default_skin";
		
		public static const GRADUATION_LINE_Y_DEFAULT_SKIN:String = "graduationLineY_default_skin";
		
		public static const GRADUATION_X_DEFAULT_SKIN:String = "graduationX_default_skin";
		
		public static const GRADUATION_Y_DEFAULT_SKIN:String = "graduationY_default_skin";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			coorAxesX_default_skin:"CoorAxesX_default_skin",
			coorAxesY_default_skin:"CoorAxesY_default_skin",
			graduationLineX_default_skin:"GraduationLineX_default_skin",
			graduationLineY_default_skin:"GraduationLineY_default_skin",
			graduationX_default_skin:"GraduationX_default_skin",
			graduationY_default_skin:"GraduationY_default_skin"
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
			com.snsoft.util.SpriteUtil.deleteAllChild(this);
			
			var coorWidth:Number = this.width;
			var coorHeight:Number = this.height;
			
			var gradXSkinH:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_X_DEFAULT_SKIN)) as MovieClip;
			var gradYSkinW:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_Y_DEFAULT_SKIN)) as MovieClip;
			
			coorWidth -= gradYSkinW.width;
			coorHeight -= gradXSkinH.height;
			
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
			
			//刻度间隔长度
			var xlen:Number = coorWidth / this.xGradNum;
			var ylen:Number = coorHeight / this.yGradNum;
			
			//x刻度
			for(var i:int = 0;i <= this.xGradNum;i++){
				var gradXSkin:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_X_DEFAULT_SKIN)) as MovieClip;
				gradXSkin.x = i * xlen;
				this.coorSprite.addChild(gradXSkin);
			}
			
			//y刻度
			for(var j:int = 0;j <= this.yGradNum;j++){
				var gradYSkin:MovieClip = getDisplayObjectInstance(getStyleValue(GRADUATION_Y_DEFAULT_SKIN)) as MovieClip;
				gradYSkin.y = - j * ylen;
				this.coorSprite.addChild(gradYSkin);
			}
			
			//把两坐标轴的交点做为原点，移动坐标系，y平移
			var coorRect:Rectangle = this.coorSprite.getRect(this);
			var tlPoint:Point = coorRect.topLeft;
			this.coorSprite.y = - tlPoint.y;
			this.coorSprite.x = - tlPoint.x;
		}
		
		public function transPoint(p:Point):Point{
			var rp:Point = new Point();
			rp.x = p.x + this.coorSprite.x;
			rp.y = this.coorSprite.y - p.y;
			return rp;
		}

		public function get xGradNum():int
		{
			return _xGradNum;
		}

		public function set xGradNum(value:int):void
		{
			_xGradNum = value;
		}

		public function get yGradNum():int
		{
			return _yGradNum;
		}

		public function set yGradNum(value:int):void
		{
			_yGradNum = value;
		}

		public function get xGradValue():int
		{
			return _xGradValue;
		}

		public function set xGradValue(value:int):void
		{
			_xGradValue = value;
		}

		public function get yGradValue():int
		{
			return _yGradValue;
		}

		public function set yGradValue(value:int):void
		{
			_yGradValue = value;
		}
		
	}
}