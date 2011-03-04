package tvc
{
	import fl.video.FLVPlayback;
	import fl.video.VideoScaleMode;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import tvc.ParseXMLFile;
	import tvc.parseXML.Info;
	import tvc.parseXML.LineArea;
	import tvc.parseXML.MapArea;
	import tvc.parseXML.PoleArea;
	import tvc.parseXML.PriceLine;
	import tvc.parseXML.PriceMap;
	import tvc.parseXML.PricePole;
	public class test
	{	
		public function test(){
			var player:FLVPlayback = new FLVPlayback();
			player.align = "center";
			player.autoPlay = true;
			player.cuePoints = new Array();
			player.scaleMode = VideoScaleMode.MAINTAIN_ASPECT_RATIO;
			player.skin = "SkinUnderPlayStopSeekMuteVol.swf";
			player.skinAutoHide = false;
			player.skinBackgroundAlpha = 0.85;
			player.skinBackgroundColor = 0x47abcb;
			player.source = "video.flv";
			player.volume = 1;	
		}	
	}
	/*
	var parses:ParseXMLFile = new ParseXMLFile();
	var ac:AlterableCoordinates = new AlterableCoordinates();
	var info:Info = parses.getInfo();
	var priceMap:PriceMap = info.getPriceMap();
	var subsectionsArray:Array = priceMap.getSubsections();
	subsectionsArray[i];
	var parses:ParseXMLFile = new ParseXMLFile();
		var info:Info = parses.getInfo();
		var priceLine:PriceLine = info.getPriceline();
		var lineArea:Array = priceLine.getAreas();
		var linePrices:Array = lineArea[0].getPrices();
		var lineForecast:Array = lineArea[0].getForecasts();
		
		var parses_p:ParseXMLFile = new ParseXMLFile();
		var info_p:Info = parses_pole.getInfo();
		var pole_p:PricePole = info_p.getPricepole();
		var poleAreas:Array = pole_p.getAreas();
		var poleArea:PoleArea = poleAreas[0];
		var forcast:Array = poleArea.getForecasts();
		var oldPrice:Array = poleArea.getOldprices();
		var price:Array = poleArea.getPrices();
	var parses:ParseXMLFile = new ParseXMLFile();
		var info:Info = parses.getInfo();
		info.getCompany();
		var pricemap:PriceMap = info.getPriceMap();
		parses.getSign() == true;
		
		var areas:Array = pricemap.getAreas();
		var area:MapArea = areas[0];
		area.getAreaName();
		area.getCoorX();
		area.getCoorY();
		
	var info:Info = new Info();
		var priceline:PriceLine = new PriceLine();
		var area:LineArea = new LineArea();
		var prices:Array = new Array();
		var i:Number = 24.345;
		prices.push (i);
		if (prices != null) {
			area.setPrices (prices);
			var areas:Array = new Array();
			areas.push (area);
			priceline.setAreas (areas);
			info.setPriceline (priceline);
		}
		var areas1:Array = info.getPriceline().getAreas();
		var area1:LineArea = areas1[0];
		var prices1:Array = area1.getPrices();
		trace(prices1[0]);
		var parses:ParseXMLFile = new ParseXMLFile();
		parses.parseXML("msg.xml");
		*/
}