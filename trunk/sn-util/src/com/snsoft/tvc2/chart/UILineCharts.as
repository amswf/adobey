package com.snsoft.tvc2.chart{
	import com.snsoft.mapview.util.MyColorTransform;
	import com.snsoft.tvc2.dataObject.DataDO;
	import com.snsoft.tvc2.dataObject.ListDO;
	import com.snsoft.tvc2.dataObject.TextPointDO;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.geom.Point;
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
						var p:Point = new Point();
						p.y = Number(tpd.value);
						cdpv.push(p.y);
					}
				}
				var xv:Vector.<Number> = new Vector.<Number>();
				xv.push(0,1,2,3,4);
				var xcd:Coordinate = new Coordinate(xv);
				var ycd:Coordinate = new Coordinate(cdpv,true);
				var ygv:Vector.<String> = Vector.<String>(ycd.calibrationVct);
				var xgv:Vector.<String> = new Vector.<String>();
				xgv.push("前3周","前2周","前1周","本周","下周");
				trace("ycd.gradValue: ",ycd.gradValue);
				var uic:UICoor = new UICoor(xgv,ygv);
				this.addChild(uic);
				uic.drawNow();
				
				for(var ii:int;ii<ldv.length;ii++){
					var pv:Vector.<Point> = new Vector.<Point>();
					var ld2:ListDO = ldv[ii];
					var phv2:Vector.<TextPointDO> = ld2.listHv;
					for(var jj:int = 0;jj<phv2.length;jj++){
						var tpd2:TextPointDO = phv2[jj];
						var p2:Point = new Point();
						p2.y = Number(tpd2.value);
						p2.x = jj;
						trace("p2: ",p2);
						var pr:Point = this.transPoint(uic,null,ycd,p2);
						pv.push(pr);
						trace("pr: ",pr);
					}
					var uil:UILine = new UILine(pv,true,this.delayTime,this.timeLength,this.timeOut);
					uil.setStyle(LINE_DEFAULT_SKIN,this.getStyle(LINE_DEFAULT_SKIN));
					uil.setStyle(POINT_DEFAULT_SKIN,this.getStyle(POINT_DEFAULT_SKIN));
					uil.setStyle(TEXT_FORMAT,this.getStyle(TEXT_FORMAT));
					this.addChild(uil);
					uil.drawNow();
					if(ii == 0){
						MyColorTransform.transColor(uil,1,200,0,0);
					}
					if(ii == 1){
						MyColorTransform.transColor(uil,1,0,200,0);
					}
					if(ii == 2){
						MyColorTransform.transColor(uil,1,0,0,200);
					}
				}
			}
		}
		
		/**
		 * 
		 * @param uiCoor
		 * @param xcd
		 * @param ycd
		 * @param p
		 * @return 
		 * p2:  (x=1, y=120)
400 1 0 400 6
300 120 100 300 50
pr:  (x=66.66666666666667, y=180)
		 */		
		public function transPoint(uiCoor:UICoor,xcd:Coordinate,ycd:Coordinate,p:Point):Point{
			var rp:Point = new Point();
			if(xcd != null){
				rp.x = (p.x - xcd.gradeBaseValue) * uiCoor.width /xcd.differenceValue;
			}
			else {
				rp.x = p.x * uiCoor.width / (uiCoor.xGradVector.length - 1);
			}
			if(ycd != null){
				rp.y = uiCoor.height - (p.y - ycd.gradeBaseValue) * uiCoor.height / (ycd.differenceValue);
			}
			else {
				rp.y = uiCoor.height - p.y * uiCoor.height / (uiCoor.yGradVector.length - 1);
			}
			return rp;
		}
	}
}