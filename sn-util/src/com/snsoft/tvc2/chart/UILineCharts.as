package com.snsoft.tvc2.chart{
	import com.snsoft.mapview.util.MyColorTransform;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.util.NumberUtil;
	import com.snsoft.util.StringUtil;
	import com.snsoft.util.TextFieldUtil;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;
	import flash.geom.Point;
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
			this.width = 300;
			super.configUI();	
		}
		
		/**
		 * 
		 * 
		 */		
		override protected function draw():void{
			if(this.dataDo != null){
				var ldv:Vector.<ListDO> = this.dataDo.data;
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
				trace("ycd.gradValue: ",ycd.gradValue);
				var uic:UICoor = new UICoor(xgv,ygv);
				this.addChild(uic);
				uic.drawNow();
				var pvv:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
				var ptvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
				var uilv:Vector.<UILine> = new Vector.<UILine>();
				
				for(var i3:int;i3<ldv.length;i3++){
					var pv:Vector.<Point> = new Vector.<Point>();
					var ptv:Vector.<String> = new Vector.<String>();
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
						trace("p2: ",p2);
						var pr:Point = this.transPoint(uic,null,ycd,p2);
						pv.push(pr);
						ptv.push(String(p2.y.toFixed(2)));
						trace("pr: ",pr);
					}
					pvv.push(pv);
					ptvv.push(ptv);
					
				}
				var ptsvv:Vector.<Vector.<Point>> = this.calculatePointTextPlace(pvv,20);
				for(var i4:int;i4<pvv.length;i4++){
					var pv2:Vector.<Point> = pvv[i4];
					var ptv2:Vector.<String> = ptvv[i4];
					var ptsv:Vector.<Point> = ptsvv[i4];
					trace(pv2);
					trace(ptsv);
					var uil:UILine = new UILine(pv2,ptv2,ptsv,true,this.delayTime,this.timeLength,this.timeOut,i4);
					uil.setStyle(LINE_DEFAULT_SKIN,this.getStyle(LINE_DEFAULT_SKIN));
					uil.setStyle(POINT_DEFAULT_SKIN,this.getStyle(POINT_DEFAULT_SKIN));
					uil.setStyle(TEXT_FORMAT,this.getStyle(TEXT_FORMAT));
					this.addChild(uil);
					uilv.push(uil);
					uil.addEventListener(UILine.EVENT_POINT_CMP,handlerEventPointCmp);
					if(i4 == 0){
						MyColorTransform.transColor(uil,1,200,0,0);
					}
					if(i4 == 1){
						MyColorTransform.transColor(uil,1,0,200,0);
					}
					if(i4 == 2){
						MyColorTransform.transColor(uil,1,0,0,200);
					}
				}
				
				for(var i5:int = 0;i5<uilv.length;i5++){
					var uil2:UILine = uilv[i5];
					uil2.drawNow();
				}
			}
		}
		
		private function calculatePointTextPlace(pvv:Vector.<Vector.<Point>>,yMin:Number):Vector.<Vector.<Point>>{
			var maxpvLen:int = 0;
			for(var iMax:int =0;iMax<pvv.length;iMax++){
				var mpv:Vector.<Point> = pvv[iMax];
				if(mpv.length > maxpvLen){
					maxpvLen = mpv.length;
				}
			}
			var ptvv:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
			
			for(var ii:int =0;ii<pvv.length;ii++){
				var pv2:Vector.<Point> = pvv[ii];
				var ptv2:Vector.<Point> = new Vector.<Point>();
				for(var jj:int =0;jj<pv2.length;jj++){
					var p2:Point = pv2[jj];
					var pt:Point = p2.clone();
					ptv2.push(pt); 
				}
				ptvv.push(ptv2);
			}
			
			for(var i:int =0;i<maxpvLen;i++){
				var orderpv:Vector.<int> = new Vector.<int>();
				for(var j:int =0;j<pvv.length;j++){
					var pv:Vector.<Point> = pvv[j];
					if(i < pv.length){
						var p:Point = pv[i];
						var opvl:int = orderpv.length;
						trace(p);
						if(opvl > 0){
							for(var k:int = 0;k < opvl;k++){
								var ok:int = orderpv[k];
								var opv:Vector.<Point> = pvv[ok];
								var op:Point = opv[i];
								if(p.y > op.y){
									if(k + 1 == opvl){
										orderpv.push(j);
										break;
									}
									else{
										var ek:int = orderpv[k + 1];
										var epv:Vector.<Point> = pvv[ek];
										var ep:Point = epv[i];
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
				trace("orderpv:",orderpv);
				
				
				trace("一列：");
				for(var j3:int = orderpv.length -1;j3 >= 0;j3 --){
					var orderIndex:int = orderpv[j3];
					var pv3:Vector.<Point> = ptvv[orderIndex];
					if(i < pv3.length){
						var p3:Point = pv3[i];
						trace(orderIndex,p3);
						if( j3 + 1 <= orderpv.length -1){
							var orderFrontIndex:int = orderpv[j3 + 1];
							var pvf:Vector.<Point> = ptvv[orderFrontIndex];
							if(i < pvf.length){
								var pf:Point = pvf[i];
								if(p3.y > pf.y - yMin){
									p3.y = pf.y - yMin;  
								}
							}
						}
						else {
							p3.y -= yMin;
						}
					}
				}
				
			}
			return ptvv;
		}
		
		private function handlerEventPointCmp(e:Event):void{
			
			var uil:UILine = e.currentTarget as UILine;
			if(uil != null){
				var index:int = uil.currentIndex;
				
				var n:int = 0;
				if(index >= this.pointTextCountV.length){
					this.pointTextCountV.push(1);
				}
				else if(this.pointTextCountV[index] > 0){
					this.pointTextCountV[index] += 1;
					n = this.pointTextCountV[index];
				}
				trace("index,n:",index,n);
				var p:Point = uil.getCurrentPoint();
				var pt:String = uil.getCurrentPointText();
				var ptp:Point = uil.getCurrentPointTextPlace();
				
				var tfd:TextField = new TextField();
				tfd.text = pt;
				TextFieldUtil.fitSize(tfd);
				tfd.x = ptp.x;
				tfd.y = ptp.y;
				this.addChild(tfd);
			}
			
		}
		
		/**
		 * 
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
				rp.x = p.x * uiCoor.width / (uiCoor.xGradVector.length - 1);
			}
			
			if(isNaN(p.y)){
				rp.y = NaN;
			}
			else if(ycd != null){
				rp.y = uiCoor.height - (p.y - ycd.gradeBaseValue) * uiCoor.height / (ycd.differenceValue);
			}
			else {
				rp.y = uiCoor.height - p.y * uiCoor.height / (uiCoor.yGradVector.length - 1);
			}
			return rp;
		}
	}
}