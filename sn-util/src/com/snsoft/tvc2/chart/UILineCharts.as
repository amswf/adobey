package com.snsoft.tvc2.chart{
	import com.snsoft.mapview.util.MyColorTransform;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.text.EffectText;
	import com.snsoft.tvc2.util.NumberUtil;
	import com.snsoft.util.ColorTransformUtil;
	import com.snsoft.util.StringUtil;
	import com.snsoft.util.TextFieldUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UILineCharts extends UICoorChartBase{
		
		//开始播放时间
		private var delayTime:Number;
		
		//最小播放时长
		private var timeLength:Number;
		
		//最大播放时长
		private var timeOut:Number;
		
		//点列表的列表
		private var dataDo:DataDO;
		
		private var pointTextCountV:Vector.<int> = new Vector.<int>();
		
		private var cutlineSprite:Sprite;
		
		private var lineTextSprite:Sprite;
		
		private var lineSprite:Sprite;
		
		private var coorSprite:Sprite;
		
		private var lineNum:int = 0;
		
		private var lineCmpNum:int = 0;
		
		public function UILineCharts(dataDo:DataDO = null,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.dataDo = dataDo;
		}
		
		public static const LINE_DEFAULT_SKIN:String = "line_default_skin";
		
		public static const POINT_DEFAULT_SKIN:String = "point_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			line_default_skin:"Line_default_skin",
			point_default_skin:"Point_default_skin",
			myTextFormat:new TextFormat("宋体",16,0x000000)
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
			this.width = 300;
			super.configUI();	
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			if(this.dataDo != null){
				
				coorSprite = new Sprite();
				this.addChild(coorSprite);
				
				lineSprite = new Sprite();
				this.addChild(lineSprite);
				
				cutlineSprite = new Sprite();
				cutlineSprite.x = this.width + 80;
				this.addChild(cutlineSprite);
				
				lineTextSprite = new Sprite();
				this.addChild(lineTextSprite);
				
				var ldv:Vector.<ListDO> = this.dataDo.data;
				
				//把列表值全部放到一个列表中
				var cdpv:Vector.<Number> = new Vector.<Number>();
				for(var i:int;i<ldv.length;i++){
					var ld:ListDO = ldv[i];
					var phv:Vector.<TextPointDO> = ld.listHv;
					for(var j:int = 0;j<phv.length;j++){
						var tpd:TextPointDO = phv[j];
						if(NumberUtil.isEffective(tpd.value)){
							var n:Number = Number(tpd.value);
							cdpv.push(n);
						}
					}
				}
				
				//计算值坐标刻度个数和分度值
				var ycd:Coordinate = new Coordinate(cdpv,true);
				var ygv:Vector.<String> = Vector.<String>(ycd.calibrationVct);
				var xgv:Vector.<String> = new Vector.<String>();
				var xglv:Vector.<ListDO> = this.dataDo.xGraduationText;
				var xgldo:ListDO = xglv[0];
				var xgtpv:Vector.<TextPointDO> = xgldo.listHv;
				for(var ii:int = 0;ii < xgtpv.length;ii ++){
					var xgtp:TextPointDO = xgtpv[ii];
					xgv.push(xgtp.value);
				}
				
				//画坐标系
				var uic:UICoor = new UICoor(xgv,ygv);
				uic.width = this.width;
				uic.height = this.height;
			    uic.setStyle(TEXT_FORMAT,this.getStyleValue(TEXT_FORMAT));
				coorSprite.addChild(uic);
				uic.drawNow();
				
				var uilv:Vector.<UILine> = new Vector.<UILine>();
				
				var charPointDOVV:Vector.<Vector.<CharPointDO>> = new Vector.<Vector.<CharPointDO>>();
				
				//转换坐标值和显示值
				for(var i3:int;i3<ldv.length;i3++){
					var cpdov:Vector.<CharPointDO> = new Vector.<CharPointDO>();
					var ld2:ListDO = ldv[i3];
					var phv2:Vector.<TextPointDO> = ld2.listHv;
					for(var j3:int = 0;j3<phv2.length;j3++){
						var tpd2:TextPointDO = phv2[j3];
						var p2:Point = new Point();
						if(NumberUtil.isEffective(tpd2.value)){
							p2.y = Number(tpd2.value);
						}
						else{
							p2.y = NaN;
						}
						p2.x = j3;
						
						var pr:Point = this.transPoint(uic,null,ycd,p2);
						var cpdo:CharPointDO = new CharPointDO();
						cpdo.point = pr;
						cpdo.pointText = String(p2.y.toFixed(2));
						cpdov.push(cpdo);
					}
					charPointDOVV.push(cpdov);
				}
				
				
				
				//组织折线和图例
				var cpdotpvv:Vector.<Vector.<CharPointDO>> = this.calculatePointTextPlace(charPointDOVV,20);
				for(var i4:int;i4<charPointDOVV.length;i4++){
					var charPointDOV:Vector.<CharPointDO> = cpdotpvv[i4];
					var uil:UILine = new UILine(charPointDOV,false,this.delayTime,this.timeLength,this.timeOut,lineTextSprite);
					uil.setStyle(LINE_DEFAULT_SKIN,this.getStyleValue(LINE_DEFAULT_SKIN));
					uil.setStyle(POINT_DEFAULT_SKIN,this.getStyleValue(POINT_DEFAULT_SKIN));
					uil.setStyle(TEXT_FORMAT,this.getStyleValue(TEXT_FORMAT));
					uilv.push(uil);
					var color4:uint = 0x000000;
					//var ctf:ColorTransform = new ColorTransform();
					var lineSkin:String = "Line_default_skin";
					var pointSkin:String = "Point_default_skin";
					if(i4 == 0){
						color4 = 0xFF7F00;
						lineSkin = "Line_yello_skin";
						pointSkin = "Point_yello_skin";
					}
					else if(i4 == 1){
						color4 = 0x007F00;
						lineSkin = "Line_green_skin";
						pointSkin = "Point_green_skin";
					}
					else if(i4 == 2){
						color4 = 0x7F0000; 
						lineSkin = "Line_red_skin";
						pointSkin = "Point_red_skin";
					}
					//ColorTransformUtil.setColor(uil,uil.transformColor);
					//uil.transform.colorTransform = ctf;
					uil.transformColor = color4;
					uil.setStyle(UILine.LINE_DEFAULT_SKIN,lineSkin);
					uil.setStyle(UILine.POINT_DEFAULT_SKIN,pointSkin);
					//图例
					var ldo:ListDO = ldv[i4];
					var tft:TextFormat = getStyleValue(TEXT_FORMAT) as TextFormat;
					tft.color = color4;
					var cutlineText:TextField = EffectText.creatShadowTextField(ldo.text,tft);;
					cutlineText.y = cutlineSprite.height;
					cutlineSprite.addChild(cutlineText);					
					
					var l:MovieClip = getDisplayObjectInstance(lineSkin) as MovieClip;
					var s:MovieClip = getDisplayObjectInstance(pointSkin) as MovieClip;
					var e:MovieClip = getDisplayObjectInstance(pointSkin) as MovieClip;
					var clspr:Sprite = new Sprite();
					clspr.addChild(l);
					clspr.addChild(s);
					clspr.addChild(e);
					var px:Number = s.width / 2;
					var py:Number = s.height / 2;
					var pw:Number = 30;
					l.width = pw;
					e.x = pw;
					clspr.y = cutlineSprite.height + py;
					clspr.x = px;
					ColorTransformUtil.setColor(clspr,uil.transformColor);
					cutlineSprite.addChild(clspr);
				}
				
				lineNum = charPointDOVV.length;
				for(var i5:int;i5<charPointDOVV.length;i5++){
					var uil5:UILine = uilv[i5]
					lineSprite.addChild(uil5);
					uil5.addEventListener(Event.COMPLETE,handlerUILinePlayCmp);
				}
			}
		}
		
		private function handlerUILinePlayCmp(e:Event):void{
			lineCmpNum ++;
			if(lineCmpNum == lineNum){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}