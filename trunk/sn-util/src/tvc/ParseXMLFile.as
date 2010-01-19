package tvc
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import tvc.parseXML.Info;
	import tvc.parseXML.LineArea;
	import tvc.parseXML.MapArea;
	import tvc.parseXML.PoleArea;
	import tvc.parseXML.PriceLine;
	import tvc.parseXML.PriceMap;
	import tvc.parseXML.PricePole;

	/**
	 * 解析数据XML文件,返回信息对像 info
	 * 
	 */
	public class ParseXMLFile {
		
		static  var infos:Array = new Array();
		static  var sign:Boolean = false;


		/**
		 * 
		 */
		public function parseXML(xmlurl:String):Array {
			var languageXMLLoader:URLLoader = new URLLoader();
			languageXMLLoader.addEventListener (Event.COMPLETE, completeHandler);
			languageXMLLoader.load (new URLRequest(xmlurl));
			return infos;
		}
		
		
		/**
		 * 
		 */
		public function completeHandler (eventObj:Event):void {
			var xml:XML = new XML(eventObj.currentTarget.data);
			var xmlList:XMLList = xml.children();
			for( var iXml:int = 0 ; iXml < xmlList.length() ; iXml ++){ 
				var infoXML:XML = xmlList[iXml];
				var infoList:XMLList = infoXML.children();
				var info:Info = new Info();
				var timeNode:XML = infoList[0];
				info.setTime(timeNode.text());//时间
				//trace(timeNode.text());
				var companyNode:XML = infoList[1];//公司名称
				info.setCompany(companyNode.text());
				var cropNameNode:XML = infoList[2];//作物名称
				info.setCropName(cropNameNode.text());
				//trace(companyNode.text());
				if(true){
					var priceLineNode:XML = infoList[3];
					var priceLineList:XMLList = priceLineNode.children();//价格曲线
					var priceLine:PriceLine = new PriceLine();
					//var cropNameNode:XML = priceLineList[0];
					
					//trace(cropNameNode.text());
					var areasNode:XML = priceLineList[0];
					var areasList:XMLList = areasNode.children();
					var areas:Array = new Array();
					for(var ial:int = 0; ial < areasList.length(); ial ++){
						var area:LineArea = new LineArea();
						var areanode:XML = areasList[ial]
						var areaList:XMLList = areanode.children();
						var areaNameNode:XML = areaList[0];
						area.setAreaName(areaNameNode.text());
						//trace(areaNameNode.text());
						var prices:Array = new Array();
						var pricesNode:XML = areaList[1];
						var pricesList:XMLList = pricesNode.children();
						for(var ipl = 0; ipl < pricesList.length() ; ipl ++){
							var priceNode:XML = pricesList[ipl];
							var price:Number = priceNode.text();
							//trace(price);
							prices.push(price);
						}
						area.setPrices(prices);
						var forecasts:Array = new Array();
						var forecastsNode:XML = areaList[2];
						var forecastsList:XMLList = forecastsNode.children();
						for(var ifl:int = 0 ; ifl < forecastsList.length() ; ifl ++){
							var forecastNode:XML = forecastsList[ifl];
							var forecast:Number = forecastNode.text();
							//trace(forecast);
							forecasts.push(forecast);
						}
						area.setForecasts(forecasts);
						areas.push(area);
					}
					priceLine.setAreas(areas);
					info.setPriceline(priceLine);
				}
				if(true){
					var pricePoleNode:XML = infoList[4]
					var pricePoleList:XMLList = pricePoleNode.children();//价格柱状图
					var pricePole:PricePole = new PricePole();
					var pareasNode:XML = pricePoleList[0];
					var pareasList:XMLList = pareasNode.children();
					var pareas:Array = new Array();
					for(var ipal:int = 0; ipal < pareasList.length(); ipal ++){
						var parea:PoleArea = new PoleArea();
						var pareaNode:XML = pareasList[ipal]
						var pareaList:XMLList = pareaNode.children();
						var pareaNameNode:XML = pareaList[0];
						parea.setAreaName(pareaNameNode.text());
						//trace(pareaNameNode.text());
						var pprices:Array = new Array();
						var ppricesNode:XML = pareaList[1];
						var ppricesList:XMLList = ppricesNode.children();
						for(var ippl = 0; ippl < ppricesList.length() ; ippl ++){
							var ppriceNode:XML = ppricesList[ippl];
							var pprice:Number = ppriceNode.text();
							//trace(pprice);
							pprices.push(pprice);
						}
						parea.setPrices(pprices);
						var pforecasts:Array = new Array();
						var pforecastsNode:XML = pareaList[2];
						var pforecastsList:XMLList = pforecastsNode.children();
						for(var ipfl:int = 0 ; ipfl < pforecastsList.length() ; ipfl ++){
							var pforecastNode:XML = pforecastsList[ipfl];
							var pforecast:Number = pforecastNode.text();
							//trace(pforecast);
							pforecasts.push(pforecast);
						}
						parea.setForecasts(pforecasts);
						var poldPrices:Array = new Array();
						var poldPricesNode:XML = pareaList[3];
						var poldPricestList:XMLList = poldPricesNode.children();
						for(var iol:int = 0 ; iol < poldPricestList.length() ; iol ++){
							var poldPriceNode:XML = poldPricestList[iol];
							var poldPrice:Number = poldPriceNode.text();
							poldPrices.push(poldPrice);
						}
						parea.setOldprices(poldPrices);
						pareas.push(parea);
					}
					pricePole.setAreas(pareas);
					info.setPricepole(pricePole);
				}
				if(true){
					var priceMapNode:XML = infoList[5];
					var priceMapList:XMLList = priceMapNode.children();//价格地图
					var priceMap:PriceMap = new PriceMap();
					var subsectionsNode:XML = priceMapList[0];
					var subsectionsList:XMLList = subsectionsNode.children();
					var subsections:Array = new Array();
					for(var isl:int = 0; isl < subsectionsList.length(); isl ++){
						var subsectionNode:XML = subsectionsList[isl];
						var subsection:String = subsectionNode.text();
						//trace(subsection);
						subsections.push(subsection);
					}
					priceMap.setSubsections(subsections);
					var mareasNode:XML = priceMapList[1];
					var mareasList:XMLList = mareasNode.children();
					var mareas:Array = new Array();
					for(var imal:int = 0; imal < mareasList.length(); imal ++){
						var marea:MapArea = new MapArea();
						var mareaNode:XML = mareasList[imal];
						var mareaList:XMLList = mareaNode.children();
						var mareaNameNode:XML = mareaList[0];
						marea.setAreaName(mareaNameNode.text());
						var mareaValueNode:XML = mareaList[1];
						marea.setAreaValue(mareaValueNode.text());
						//trace(mareaNameNode.text());
						var coorXNode:XML = mareaList[2];
						marea.setCoorX(coorXNode.text());
						//trace(coorXNode.text());
						var coorYNode:XML = mareaList[3];
						marea.setCoorY(coorYNode.text());
						//trace(coorYNode.text());
						mareas.push(marea);
					}
					priceMap.setAreas(mareas);
					info.setPriceMap(priceMap);
				}
				infos.push(info);
			}
			if( infos.length > 0){
				sign = true;
			}
		}
		
		public function getInfos():Array{
			return infos;
		}
		public function getSign():Boolean{
			return sign;
		}
	}
}