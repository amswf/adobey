package com.snsoft.tvc2.chart{
	import fl.core.UIComponent;
	
	import flash.geom.Point;
	
	public class UICoorChartBase extends UIComponent{
		public function UICoorChartBase()
		{
			super();
		}
		
		//计算出显示数值显示位置，保证Y坐标不重合
		protected function calculatePointTextPlace(charPointDOVV:Vector.<Vector.<CharPointDO>>,yMin:Number):Vector.<Vector.<CharPointDO>>{
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
											orderpv.splice(k + 1,0,j);
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
								var pf:Point = pvf[i].pointTextPlace;
								trace(pf.y,ptp.y);
								if(ptp.y > pf.y - yMin){
									ptp.y = pf.y - yMin;  
								}
							}
						}
						else {
							ptp.y -= yMin;
							trace(ptp.y);
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
		protected function transPoint(uiCoor:UICoor,xcd:Coordinate,ycd:Coordinate,p:Point):Point{
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