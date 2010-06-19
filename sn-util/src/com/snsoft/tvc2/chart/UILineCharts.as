﻿package com.snsoft.tvc2.chart{
	import com.snsoft.mapview.util.MyColorTransform;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.TextPointDO;
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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UILineCharts extends UIComponent{
		
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
					if(i4 == 0){
						uil.transformColor = 0x990000;
					}
					if(i4 == 1){
						uil.transformColor = 0x009900;
					}
					if(i4 == 2){
						uil.transformColor = 0x000099; 
					}
					ColorTransformUtil.setColor(uil,uil.transformColor);
					
					//图例
					var ldo:ListDO = ldv[i4];
					var cutlineText:TextField = new TextField();
					cutlineText.y = cutlineSprite.height;
					cutlineSprite.addChild(cutlineText);
					cutlineText.text = ldo.text;
					cutlineText.selectable = false;
					var tft:TextFormat = getStyleValue(TEXT_FORMAT) as TextFormat;
					tft.color = uil.transformColor;
					cutlineText.setTextFormat(tft);
					TextFieldUtil.fitSize(cutlineText);
					
					
					var l:MovieClip = getDisplayObjectInstance(getStyleValue(LINE_DEFAULT_SKIN)) as MovieClip;
					var s:MovieClip = getDisplayObjectInstance(getStyleValue(POINT_DEFAULT_SKIN)) as MovieClip;
					var e:MovieClip = getDisplayObjectInstance(getStyleValue(POINT_DEFAULT_SKIN)) as MovieClip;
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
				
				for(var i5:int;i5<charPointDOVV.length;i5++){
					var uil5:UILine = uilv[i5]
					lineSprite.addChild(uil5);
				}
			}
		}
		
		//计算出显示数值显示位置，保证Y坐标不重合
		private function calculatePointTextPlace(charPointDOVV:Vector.<Vector.<CharPointDO>>,yMin:Number):Vector.<Vector.<CharPointDO>>{
			var maxpvLen:int = 0;
			for(var iMax:int =0;iMax<charPointDOVV.length;iMax++){
				var mpv:Vector.<CharPointDO> = charPointDOVV[iMax];
				if(mpv.length > maxpvLen){
					maxpvLen = mpv.length;
				}
			}
			var cpdovvClone:Vector.<Vector.<CharPointDO>> = new Vector.<Vector.<CharPointDO>>();
			
			for(var ii:int =0;ii<charPointDOVV.length;ii++){
				var cpdov:Vector.<CharPointDO> = charPointDOVV[ii];
				var cpdovClone:Vector.<CharPointDO> = new Vector.<CharPointDO>();
				for(var jj:int =0;jj<cpdov.length;jj++){
					var cpdo:CharPointDO = new CharPointDO();
					cpdo.point = cpdov[jj].point.clone();
					cpdo.pointText = cpdov[jj].pointText;
					cpdovClone.push(cpdo); 
				}
				cpdovvClone.push(cpdovClone);
			}
			
			for(var i:int =0;i<maxpvLen;i++){
				var orderpv:Vector.<int> = new Vector.<int>();
				for(var j:int =0;j<cpdovvClone.length;j++){
					var pv:Vector.<CharPointDO> = cpdovvClone[j];
					if(i < pv.length){
						var p:Point = pv[i].point;
						var opvl:int = orderpv.length;
					
						if(opvl > 0){
							for(var k:int = 0;k < opvl;k++){
								var ok:int = orderpv[k];
								var opv:Vector.<CharPointDO> = cpdovvClone[ok];
								var op:Point = opv[i].point;
								if(p.y > op.y){
									if(k + 1 == opvl){
										orderpv.push(j);
										break;
									}
									else{
										var ek:int = orderpv[k + 1];
										var epv:Vector.<CharPointDO> = cpdovvClone[ek];
										var ep:Point = epv[i].point;
										if(p.y < ep.y){
											orderpv.push(j);
											break;
										}
									}
								}
								else {
									orderpv.splice(0,0,j);
									break;
								}
							}
						}
						else{
							orderpv.push(j);
						}
					}
				}
				
				for(var j3:int = orderpv.length -1;j3 >= 0;j3 --){
					var orderIndex:int = orderpv[j3];
					var pv3:Vector.<CharPointDO> = cpdovvClone[orderIndex];
					if(i < pv3.length){
						var ptp:Point = pv3[i].point.clone();
						pv3[i].pointTextPlace = ptp;
						var p3:Point = pv3[i].point;
						if( j3 + 1 <= orderpv.length -1){
							var orderFrontIndex:int = orderpv[j3 + 1];
							var pvf:Vector.<CharPointDO> = cpdovvClone[orderFrontIndex];
							if(i < pvf.length){
								var pf:Point = pvf[i].point;
								if(ptp.y > pf.y - yMin){
									ptp.y = pf.y - yMin;  
								}
							}
						}
						else {
							ptp.y -= yMin;
						}
					}
				}
				
			}
			return cpdovvClone;
		}
		
		/**
		 * 转换点坐标
		 * @param uiCoor
		 * @param xcd
		 * @param ycd
		 * @param p
		 * @return 
		 *  
		 */		
		public function transPoint(uiCoor:UICoor,xcd:Coordinate,ycd:Coordinate,p:Point):Point{
			var rp:Point = new Point();
			if(isNaN(p.x)){
				rp.x = NaN;
			}
			else if(xcd != null){
				rp.x = (p.x - xcd.gradeBaseValue) * uiCoor.width /xcd.differenceValue;
			}
			else {
				rp.x = p.x * uiCoor.width / (uiCoor.xGradNum - 1);
			}
			
			if(isNaN(p.y)){
				rp.y = NaN;
			}
			else if(ycd != null){
				rp.y = uiCoor.height - (p.y - ycd.gradeBaseValue) * uiCoor.height / (ycd.differenceValue);
			}
			else {
				rp.y = uiCoor.height - p.y * uiCoor.height / (uiCoor.yGradNum - 1);
			}
			return rp;
		}
	}
}