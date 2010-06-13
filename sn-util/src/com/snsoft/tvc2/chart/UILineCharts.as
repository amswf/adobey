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
				var cd:Coordinate = new Coordinate();
				var cdpv:Vector.<Number> = new Vector.<Number>();
				for(var i:int;i<ldv.length;i++){
					var ld:ListDO = ldv[i];
					var phv:Vector.<TextPointDO> = ld.listHv;
					var pv:Vector.<Point> = new Vector.<Point>();
					for(var j:int = 0;j<phv.length;j++){
						var tpd:TextPointDO = phv[i];
						var p:Point = new Point();
						p.y = Number(tpd.value);
						cdpv.push(p.y);
					}
				}
				var ygv:Vector.<String> = Vector.<String>(cd.calculateCalibration(cdpv,true));
				var xgv:Vector.<String> = new Vector.<String>();
				xgv.push("前3周","前2周","前1周","本周","下周");
				var uic:UICoor = new UICoor(xgv,ygv);
				this.addChild(uic);
				for(var ii:int;ii<ldv.length;ii++){
					var uil:UILine = new UILine(pv,true,this.delayTime,this.timeLength,this.timeOut);
					uil.setStyle(LINE_DEFAULT_SKIN,this.getStyle(LINE_DEFAULT_SKIN));
					uil.setStyle(POINT_DEFAULT_SKIN,this.getStyle(POINT_DEFAULT_SKIN));
					uil.setStyle(TEXT_FORMAT,this.getStyle(TEXT_FORMAT));
					this.addChild(uil);
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
	}
}