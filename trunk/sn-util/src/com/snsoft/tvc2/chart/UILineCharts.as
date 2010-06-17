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
				
				for(var iii:int;iii<ldv.length;iii++){
					var pv:Vector.<Point> = new Vector.<Point>();
					var ptv:Vector.<String> = new Vector.<String>();
					var ld2:ListDO = ldv[iii];
					var phv2:Vector.<TextPointDO> = ld2.listHv;
					for(var jjj:int = 0;jjj<phv2.length;jjj++){
						var tpd2:TextPointDO = phv2[jjj];
						var p2:Point = new Point();
						
						if(NumberUtil.isEffective(tpd2.value)){
							p2.y = Number(tpd2.value);
						}
						else{
							p2.y = NaN;
						}
						p2.x = jjj;
						trace("p2: ",p2);
						var pr:Point = this.transPoint(uic,null,ycd,p2);
						pv.push(pr);
						ptv.push(String(p2.y.toFixed(2)));
						trace("pr: ",pr);
					}
					var uil:UILine = new UILine(pv,ptv,true,this.delayTime,this.timeLength,this.timeOut);
					uil.setStyle(LINE_DEFAULT_SKIN,this.getStyle(LINE_DEFAULT_SKIN));
					uil.setStyle(POINT_DEFAULT_SKIN,this.getStyle(POINT_DEFAULT_SKIN));
					uil.setStyle(TEXT_FORMAT,this.getStyle(TEXT_FORMAT));
					this.addChild(uil);
					uil.drawNow();
					uil.addEventListener(UILine.EVENT_POINT_CMP,handlerEventPointCmp);
					if(iii == 0){
						MyColorTransform.transColor(uil,1,200,0,0);
					}
					if(iii == 1){
						MyColorTransform.transColor(uil,1,0,200,0);
					}
					if(iii == 2){
						MyColorTransform.transColor(uil,1,0,0,200);
					}
				}
			}
		}
		
		private function handlerEventPointCmp(e:Event):void{
			
			var uil:UILine = e.currentTarget as UILine;
			if(uil != null){
				var index:int = uil.currentIndex;
				trace(index);
				var n:int = 0;
				if(index >= this.pointTextCountV.length){
					this.pointTextCountV.push(1);
				}
				else if(this.pointTextCountV[index] > 0){
					this.pointTextCountV[index] += 1;
					n = this.pointTextCountV[index];
				}
				
				var p:Point = uil.getCurrentPoint();
				var pt:String = uil.getCurrentPointText();
				
				var tfd:TextField = new TextField();
				tfd.text = pt;
				TextFieldUtil.fitSize(tfd);
				tfd.x = p.x;
				tfd.y = p.y;
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