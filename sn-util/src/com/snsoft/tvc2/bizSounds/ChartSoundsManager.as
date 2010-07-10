package com.snsoft.tvc2.bizSounds{
	import com.snsoft.tvc2.util.PriceUtils;

	public class ChartSoundsManager{
		
		private var baseUrl:String = "mp3/biz/";
		
		public function ChartSoundsManager(){
		}
		
		public function creatPriceSoundUrlList(chartSoundsDO:ChartSoundsDO):BizSoundDO{
			trace(chartSoundsDO.forecastPrice);
			var urlv:Vector.<String> = new Vector.<String>();
			var textv:Vector.<String> = new Vector.<String>();
			
			var currentDate:String = "";
			var nextDate:String = "";
			
			var currentDateText:String = "";
			var nextDateText:String = "";
			
			//今天
			if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_DAY){
				currentDate = "jintian.mp3";
				nextDate = "mingtianjiageyuji.mp3";
				currentDateText = "今天，";
				nextDateText = "明天，";
			}
			else if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_WEEK){//本周
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
				currentDateText = "本周，";
				nextDateText = "下周，";
			}
			else if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_MONTH){//本月
				currentDate = "benyue.mp3";
				nextDate = "xiageyuejiageyuji.mp3";
				currentDateText = "本月，";
				nextDateText = "下个月，";
			}
			else {
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
				currentDateText = "本周，";
				nextDateText = "下周，";
			}
			
			//本周
			urlv.push(baseUrl + currentDate);
			textv.push(currentDateText);
			
			//xx地区
			urlv.push(baseUrl+chartSoundsDO.areaCode + ".mp3");
			textv.push(chartSoundsDO.areaText);
			
			//农产品名称
			urlv.push(baseUrl+chartSoundsDO.goodsCode + ".mp3");
			textv.push(chartSoundsDO.goodsText);
			
			//的价格
			urlv.push(baseUrl+"jiage.mp3");
			textv.push("的价格，");
			
			//呈现下降趋势/呈现上升趋势/趋于平稳
			pushTrend(urlv,chartSoundsDO.priceTrend);
			pushTrendText(textv,chartSoundsDO.priceTrend);
			textv.push("，");
			
			//最高价格
			urlv.push(baseUrl+"zuigaojiage.mp3");
			textv.push("最高价格");
			
			//每公斤
			urlv.push(baseUrl+"meigongjin.mp3");
			textv.push("最每公斤");
			
			//xxxx元
			pushPriceUrls(urlv,chartSoundsDO.highPrice);
			textv.push(chartSoundsDO.highPrice.toFixed(2) + "元，");
			
			//最低价格
			urlv.push(baseUrl+"zuidijiage.mp3");
			textv.push("最低价格");
			
			//每公斤
			urlv.push(baseUrl+"meigongjin.mp3");
			textv.push("每公斤");
			
			//xxxx元
			pushPriceUrls(urlv,chartSoundsDO.lowPrice);
			textv.push(chartSoundsDO.lowPrice.toFixed(2) + "元。");
			
			//有预测价格没有历史价格时：
			
			if(chartSoundsDO.hasForecast && !chartSoundsDO.hasHistory){
				urlv.push(baseUrl+nextDate);//下周价格预计
				textv.push(nextDateText);
				textv.push("价格预计");
				
				pushTrend(urlv,chartSoundsDO.forecastTrend);//预测走势
				pushTrendText(textv,chartSoundsDO.forecastTrend);
				textv.push("，");
				
				urlv.push(baseUrl+"meigongjin.mp3");//每公斤
				textv.push("每公斤");
				
				//xxxx元
				pushPriceUrls(urlv,chartSoundsDO.forecastPrice);
				textv.push(chartSoundsDO.forecastPrice.toFixed(2) + "元");
				textv.push("。");
				//urlv.push(baseUrl+"zuoyou.mp3");//左右
			}
			
			//有历史价格时：
			if(chartSoundsDO.hasHistory){
				urlv.push(baseUrl+"yuqunian.mp3");//与去年同期对比，本周实际价格每公斤
				textv.push("与去年同期对比，本周实际价格每公斤");
				
				pushTrend2(urlv,chartSoundsDO.historyContrastPrice);//上升/下降
				pushTrendText2(textv,chartSoundsDO.historyContrastPrice);
				
				pushPriceUrls(urlv,Math.abs(chartSoundsDO.historyContrastPrice));//
				textv.push(Math.abs(chartSoundsDO.historyContrastPrice).toFixed(2) + "元。");
			}
			
			//有历史和预测时：
			
			if(chartSoundsDO.hasForecast && chartSoundsDO.hasHistory){
				urlv.push(baseUrl+nextDate);//下周价格预计
				urlv.push(baseUrl+"meigongjin.mp3");//每公斤
				textv.push("下周价格预计，每公斤");
				
				pushTrend2(urlv,chartSoundsDO.forecastContrastPrice);//上升/下降
				pushTrendText2(textv,chartSoundsDO.forecastContrastPrice);//上升/下降
				//xxxx元
				pushPriceUrls(urlv,Math.abs(chartSoundsDO.forecastContrastPrice));
				textv.push(Math.abs(chartSoundsDO.forecastContrastPrice).toFixed(2) + "元。");
				
				//urlv.push(baseUrl+"zuoyou.mp3");//左右
			}	
			var urlvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			urlvv.push(urlv);
			var textvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			textvv.push(textv);
			
			var bizSoundDO:BizSoundDO = new BizSoundDO();
			bizSoundDO.urlVV = urlvv;
			bizSoundDO.textVV = textvv;
			return bizSoundDO;
		}
		
		/**
		 * 价格指数 
		 * @param chartSoundsDO
		 * @return 
		 * 
		 */		
		public function creatExponentialSoundUrlList(chartSoundsDO:ChartSoundsDO):BizSoundDO{
			var urlv:Vector.<String> = new Vector.<String>();
			var textv:Vector.<String> = new Vector.<String>();
			
			var currentDate:String = "";
			var nextDate:String = "";
			
			var currentDateText:String = "";
			var nextDateText:String = "";
			
			//今天
			if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_DAY){
				currentDate = "jintian.mp3";
				nextDate = "mingtian.mp3";
				currentDateText = "今天，";
				nextDateText = "明天，";
			}
			else if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_WEEK){//本周
				currentDate = "benzhou.mp3";
				nextDate = "xiazhou.mp3";
				currentDateText = "本周，";
				nextDateText = "下周，";
			}
			else if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_MONTH){//本月
				currentDate = "benyue.mp3";
				nextDate = "xiageyue.mp3";
				currentDateText = "本月，";
				nextDateText = "下个月，";
			}
			else {
				currentDate = "benzhou.mp3";
				nextDate = "xiazhou.mp3";
				currentDateText = "本周，";
				nextDateText = "下周，";
			}
			
			urlv.push(baseUrl + "womenlaikanyixia.mp3"); 
			textv.push("我们来看一下");
			
			urlv.push(baseUrl + chartSoundsDO.goodsCode + ".mp3"); 
			textv.push(chartSoundsDO.goodsText + "的");
			
			urlv.push(baseUrl + "jiagezhishubianhuaqingkuang.mp3");
			textv.push("的价格指数变化情况，");
			
			urlv.push(baseUrl + currentDate);
			textv.push(currentDateText);
			
			urlv.push(baseUrl + "jiagezhishu.mp3");
			textv.push("价格指数，");
			
			pushTrend(urlv,chartSoundsDO.priceExponentialTrend);
			pushTrendText(textv,chartSoundsDO.priceExponentialTrend);
			textv.push("。");
			
			if(chartSoundsDO.hasForecast){
				urlv.push(baseUrl + nextDate);
				textv.push(nextDateText);
				
				urlv.push(baseUrl + "jiagezhishu.mp3");
				urlv.push(baseUrl + "yuji.mp3");
				textv.push("价格指数预计，");
				
				pushTrend(urlv,chartSoundsDO.forecastPriceExponentialTrend);
				pushTrendText(textv,chartSoundsDO.forecastPriceExponentialTrend);
				textv.push("。");
			}
			
			var urlvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			urlvv.push(urlv);
			var textvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			textvv.push(textv);
			
			var bizSoundDO:BizSoundDO = new BizSoundDO();
			bizSoundDO.urlVV = urlvv;
			bizSoundDO.textVV = textvv;
			return bizSoundDO;
		}
		
		/**
		 * 呈现下降趋势/呈现上升趋势/趋于平稳 
		 * @param urls
		 * @param i
		 * 
		 */		
		private function pushTrend(urls:Vector.<String>,i:Number):void{
			
			if(i > 0){
				urls.push(baseUrl+"qushi2.mp3");
			}
			else if(i < 0){
				urls.push(baseUrl+"qushi1.mp3");
			}
			else if(i == 0){
				urls.push(baseUrl+"qushi0.mp3");
			}
		}
		
		private function pushTrendText(texts:Vector.<String>,i:Number):void{
			
			if(i > 0){
				texts.push("呈现上升趋势");
			}
			else if(i < 0){
				texts.push("呈现下降趋势");
			}
			else if(i == 0){
				texts.push("趋于平稳");
			}
		}
		
		/**
		 * 下降/上升 
		 * @param urls
		 * @param i
		 * 
		 */		
		private function pushTrend2(urls:Vector.<String>,i:Number):void{
			
			if(i >= 0){
				urls.push(baseUrl+"shangshen.mp3");
			}
			else if(i < 0){
				urls.push(baseUrl+"xiajiang.mp3");
			}
		}
		
		private function pushTrendText2(texts:Vector.<String>,i:Number):void{
			
			if(i >= 0){
				texts.push("上升");
			}
			else if(i < 0){
				texts.push("下降");
			}
		}
		
		
		/**
		 * 把子列表项放到主列表中去 
		 * @param urls
		 * @param price
		 * 
		 */		
		private function pushPriceUrls(urls:Vector.<String>,price:Number):void{
			var highPriceUrls:Vector.<String> = PriceUtils.toCNUpper(price);
			for(var i:int =0;i<highPriceUrls.length;i++){
				urls.push(highPriceUrls[i]);
			}
		}
	}
}