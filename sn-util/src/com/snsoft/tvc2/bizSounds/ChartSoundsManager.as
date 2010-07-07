package com.snsoft.tvc2.bizSounds{
	import com.snsoft.tvc2.util.PriceUtils;

	public class ChartSoundsManager{
		
		private var baseUrl:String = "mp3/biz/";
		
		public function ChartSoundsManager(){
		}
		
		public function creatPriceSoundUrlList(chartSoundsDO:ChartSoundsDO):Vector.<String>{
			var urlv:Vector.<String> = new Vector.<String>();
			
			
			var currentDate:String = "";
			var nextDate:String = "";
			
			//今天
			if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_DAY){
				currentDate = "jintian.mp3";
				nextDate = "mingtianjiageyuji.mp3";
			}
			else if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_WEEK){//本周
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
			}
			else if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_MONTH){//本月
				currentDate = "benyue.mp3";
				nextDate = "xiageyuejiageyuji.mp3";
			}
			else {
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
			}
			
			urlv.push(baseUrl + currentDate);
			
			//xx地区
			urlv.push(baseUrl+chartSoundsDO.areaCode + ".mp3");
			
			//农产品名称
			urlv.push(baseUrl+chartSoundsDO.goodsCode + ".mp3");
			
			//的价格
			urlv.push(baseUrl+"jiage.mp3");
			
			//呈现下降趋势/呈现上升趋势/趋于平稳
			pushTrend(urlv,chartSoundsDO.priceTrend);
			
			//最高价格
			urlv.push(baseUrl+"zuigaojiage.mp3");
			
			//每公斤
			urlv.push(baseUrl+"meigongjin.mp3");
			
			//xxxx元
			pushPriceUrls(urlv,chartSoundsDO.highPrice);
			
			//最低价格
			urlv.push(baseUrl+"zuidijiage.mp3");
			
			//每公斤
			urlv.push(baseUrl+"meigongjin.mp3");
			
			//xxxx元
			pushPriceUrls(urlv,chartSoundsDO.lowPrice);
			
			//有预测价格没有历史价格时：
			if(!isNaN(chartSoundsDO.forecastPrice) && isNaN(chartSoundsDO.historyContrastPrice)){
				urlv.push(baseUrl+nextDate);//下周价格预计
				pushTrend(urlv,chartSoundsDO.forecastTrend);//预测走势
				urlv.push(baseUrl+"meigongjin.mp3");//每公斤
				//xxxx元
				pushPriceUrls(urlv,chartSoundsDO.forecastPrice);
				//urlv.push(baseUrl+"zuoyou.mp3");//左右
			}
			
			//有历史价格时：
			if(!isNaN(chartSoundsDO.historyContrastPrice)){
				urlv.push(baseUrl+"yuqunian.mp3");//与去年同期对比，本周实际价格每公斤
				pushTrend2(urlv,Math.abs(chartSoundsDO.historyContrastPrice));//上升/下降
				pushPriceUrls(urlv,chartSoundsDO.historyContrastPrice);//
			}
			
			//有历史和预测时：
			
			if(!isNaN(chartSoundsDO.forecastContrastPrice) && !isNaN(chartSoundsDO.historyContrastPrice)){
				urlv.push(baseUrl+nextDate);//下周价格预计
				urlv.push(baseUrl+"meigongjin.mp3");//每公斤
				pushTrend2(urlv,chartSoundsDO.forecastContrastPrice);//上升/下降
				//xxxx元
				pushPriceUrls(urlv,Math.abs(chartSoundsDO.forecastContrastPrice));
				//urlv.push(baseUrl+"zuoyou.mp3");//左右
			}			
			return urlv;
		}
		
		/**
		 * 价格指数 
		 * @param chartSoundsDO
		 * @return 
		 * 
		 */		
		public function creatExponentialSoundUrlList(chartSoundsDO:ChartSoundsDO):Vector.<String>{
			var urlv:Vector.<String> = new Vector.<String>();
			
			var currentDate:String = "";
			var nextDate:String = "";
			
			//今天
			if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_DAY){
				currentDate = "jintian.mp3";
				nextDate = "mingtianjiageyuji.mp3";
			}
			else if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_WEEK){//本周
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
			}
			else if(chartSoundsDO.dateType == ChartSoundsDO.DATE_TYPE_MONTH){//本月
				currentDate = "benyue.mp3";
				nextDate = "xiageyuejiageyuji.mp3";
			}
			else {
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
			}
			
			urlv.push(baseUrl + "womenlaikanyixia.mp3"); 
			urlv.push(baseUrl + chartSoundsDO.goodsCode + ".mp3"); 
			urlv.push(baseUrl + "jiagezhishubianhuaqingkuang.mp3");
			urlv.push(baseUrl + currentDate);
			urlv.push(baseUrl + "jiagezhishu.mp3");
			pushTrend(urlv,chartSoundsDO.priceExponentialTrend);
			if(!isNaN(chartSoundsDO.forecastPriceExponentialTrend)){
				urlv.push(baseUrl + nextDate);
				urlv.push(baseUrl + "jiagezhishu.mp3");
				pushTrend(urlv,chartSoundsDO.forecastPriceExponentialTrend);
			}
			
			return urlv;
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