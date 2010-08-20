package com.snsoft.tvc2.chart{
	import com.snsoft.mapview.util.MyColorTransform;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.media.Mp3Player;
	import com.snsoft.util.text.EffectText;
	import com.snsoft.util.text.TextStyles;
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
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	[Style(name="pillar_default_skin", type="Class")]
	
	[Style(name="myTextFormat", type="Class")]
	
	/**
	 * 柱状图业务 
	 * @author Administrator
	 * 
	 */	
	public class UIPillarCharts extends UICoorChartBase{
		
		//点列表的列表
		private var dataDo:DataDO;
		
		private var pointTextCountV:Vector.<int> = new Vector.<int>();
		
		private var cutlineSprite:Sprite;
		
		private var lineTextSprite:Sprite;
		
		private var lineSprite:Sprite;
		
		private var coorSprite:Sprite;
		
		private var lineNum:int = 0;
		
		private var lineCmpNum:int = 0;
		
		private var maxpvLen:int = 0;
		
		private var charPointDOTextVV:Vector.<Vector.<CharPointDO>>;
		
		private var currentIndex:int;
		
		private var xgp:Number = 0.2;
		
		private var xbl:Number;//起点坐标
		
		private var xw:Number;//宽度
		
		private var isBizSoundCmp:Boolean = false;
		
		public function UIPillarCharts(dataDo:DataDO = null,delayTime:Number = 0,timeLength:Number = 0,timeOut:Number = 0){
			super();
			this.delayTime = delayTime;
			this.timeLength = timeLength;
			this.timeOut = timeOut;
			this.dataDo = dataDo;
		}
		
		public static const PILLAR_DEFAULT_SKIN:String = "pillar_default_skin";
		
		public static const TEXT_FORMAT:String = "myTextFormat";
		
		/**
		 * 
		 */		
		private static var defaultStyles:Object = {
			pillar_default_skin:"Pillar_default_skin",
			myTextFormat:new TextFormat("宋体",18,0x000000)
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
		
		override protected function draw():void {
		}
		
		override protected function initPlay():void {
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
				var ygv:Vector.<String> = new Vector.<String>();
				var xgv:Vector.<String> = new Vector.<String>();
				var xglv:Vector.<ListDO> = this.dataDo.xGraduationText;
				var xgldo:ListDO = xglv[0];
				var xgtpv:Vector.<TextPointDO> = xgldo.listHv;
				for(var ii:int = 0;ii < xgtpv.length;ii ++){
					var xgtp:TextPointDO = xgtpv[ii];
					xgv.push(xgtp.value);
				}
				
				for(var i7:int =0;i7< ycd.calibrationVct.length;i7++){
					var yc:Number = ycd.calibrationVct[i7];
					ygv.push(yc.toFixed(2));
				}
				
				//画坐标系
				var unitX:String = this.dataDo.unitX;
				var unitY:String = this.dataDo.unitY;
				if(!com.snsoft.tvc2.util.StringUtil.isEffective(unitX)){
					unitX = "";
				}
				if(!com.snsoft.tvc2.util.StringUtil.isEffective(unitY)){
					unitY = "";
				}
				var uic:UICoor = new UICoor(xgv,ygv,unitX,unitY,UICoor.GRAD_TYPE_AREA,UICoor.GRAD_TYPE_POINT);
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
				
				
				
				
				var cpdotpvv:Vector.<Vector.<CharPointDO>> = this.calculatePointTextPlace(charPointDOVV,20);
				
				charPointDOTextVV = cpdotpvv;
				
				for(var iMax:int =0;iMax<cpdotpvv.length;iMax++){
					var mpv:Vector.<CharPointDO> = cpdotpvv[iMax];
					if(mpv.length > maxpvLen){
						maxpvLen = mpv.length;
					}
				}
				
				//图例
				for(var i6:int = 0;i6<ldv.length;i6++){
					var color6:uint = 0x000000;
					//var ctf6:ColorTransform = new ColorTransform();
					var pillarSkin:String = "Pillar_default_skin";
					if(i6 == 0){
						color6 = 0xFF7F00;
						pillarSkin = "Pillar_yello_skin";
					}
					else if(i6 == 1){
						color6 = 0x007F00;
						pillarSkin = "Pillar_green_skin";
					}
					else if(i6 == 2){
						color6 = 0x7F0000; 
						pillarSkin = "Pillar_red_skin";
					}
					var ldo:ListDO = ldv[i6];
					
					var cutlineText:TextField = EffectText.creatTextByStyleName(ldo.text,TextStyles.STYLE_CUTLINE_TEXT,color6);;
					cutlineText.y = cutlineSprite.height;
					cutlineSprite.addChild(cutlineText);
					
					var pillar:MovieClip = getDisplayObjectInstance(pillarSkin) as MovieClip;
					pillar.height = 20;
					var clspr:Sprite = new Sprite();
					clspr.addChild(pillar);
					var px:Number = pillar.width / 2;
					var py:Number = pillar.height;
					clspr.y = cutlineSprite.height + py;
					//ColorTransformUtil.setColor(clspr,color);
					//clspr.transform.colorTransform = ctf6;
					cutlineSprite.addChild(clspr);
				}
				
				//计算每组柱的起点坐标和宽度
				var xlen:Number = uic.xGradLength;
				xbl = int(xlen * xgp);//起点坐标
				xw = int((xlen *(1 - xgp * 2)) / cpdotpvv.length);//宽度
				currentIndex = 0;
			}
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function play():void {
			playNext();
			playSounds();
		}
		
		private function playSounds():void{
			if(this.dataDo != null){
				var bizSoundList:Vector.<Vector.<Sound>> = dataDo.bizSoundList;
				if(bizSoundList != null){
					var cBizSoundList:Vector.<Sound> = bizSoundList[0];
					var bizSound:Mp3Player = new Mp3Player(cBizSoundList);
					bizSound.addEventListener(Event.COMPLETE,handlerBizSoundCmp);
					this.addChild(bizSound); 
				}
				else {
					isBizSoundCmp = true;	
					dispatchEventState();
				}
			}
		}
		
		private function handlerBizSoundCmp(e:Event):void{
			isBizSoundCmp = true;	
			dispatchEventState();
		}
		
		private function playNext():void{
			//组织柱状显示
			var j4:int = currentIndex;
			currentIndex ++;
			if(j4 < maxpvLen && maxpvLen > 0){
				var pillarNum:int = 0;
				for(var i4:int = 0;i4<charPointDOTextVV.length;i4++){
					var charPointDOV:Vector.<CharPointDO> = charPointDOTextVV[i4];
					if(j4 < charPointDOV.length){
						var cpdo4:CharPointDO = charPointDOV[j4];
						var valuey:Number = cpdo4.point.y;
						if(!isNaN(valuey)){
							var uip:UIPillar = new UIPillar(cpdo4,false,this.lineTextSprite);
							uip.setStyle(TEXT_FORMAT,this.getStyleValue(TEXT_FORMAT));
							uip.height = this.height;
							uip.width = xw;
							
							uip.x = uip.width * pillarNum + xbl;
							var color4:uint = 0x000000;
							//var ctf:ColorTransform = new ColorTransform();
							var pillarSkin4:String = "Pillar_default_skin";
							if(i4 == 0){
								color4 = 0xFF7F00;
								pillarSkin4 = "Pillar_yello_skin";
							}
							else if(i4 == 1){
								color4 = 0x007F00;
								pillarSkin4 = "Pillar_green_skin";
							}
							else if(i4 == 2){
								color4 = 0x7F0000; 
								pillarSkin4 = "Pillar_red_skin";
							}
							//ColorTransformUtil.setColor(uip,color4);
							//uip.transform.colorTransform = ctf;
							uip.setStyle(UIPillar.PILLAR_DEFAULT_SKIN,pillarSkin4);
							uip.transformColor = color4;
							lineNum ++;
							this.lineSprite.addChild(uip);
							uip.addEventListener(Event.COMPLETE,handlerUIPillarPlayCmp);
							pillarNum ++;
						}
					}
				}
			}
			else {
				this.isPlayCmp = true;
				this.dispatchEventState();
			}
		}
		
		private function handlerUIPillarPlayCmp(e:Event):void{
			lineCmpNum ++;
			if(lineCmpNum == lineNum){
				playNext();
				
			}
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function dispatchEventState():void{
			var sign:Boolean = false;
			if(this.isPlayCmp && this.isTimeLen && isBizSoundCmp){
				sign = true;
			}
			else if(this.isTimeOut){
				sign = true;
			}
			
			if(sign){
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
	}
}