package com.snsoft.tvc2.bizSounds{
	import com.snsoft.tvc2.dataObject.TextPointDO;
	import com.snsoft.tvc2.media.TextPlayer;
	import com.snsoft.tvc2.util.PriceUtils;
	import com.snsoft.tvc2.util.StringUtil;
	
	public class DistributeSoundsManager{
		
		private var baseUrl:String = "mp3/biz/";
		
		public function DistributeSoundsManager()
		{
		}
		
		public function creatPriceSoundUrlList(distributeSoundsDO:DistributeSoundsDO):Vector.<Vector.<String>>{
			var currentDate:String = "";
			var nextDate:String = "";
			
			//今天
			if(distributeSoundsDO.dateType == DistributeSoundsDO.DATE_TYPE_DAY){
				currentDate = "jintian.mp3";
				nextDate = "mingtianjiageyuji.mp3";
			}
			else if(distributeSoundsDO.dateType == DistributeSoundsDO.DATE_TYPE_WEEK){//本周
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
			}
			else if(distributeSoundsDO.dateType == DistributeSoundsDO.DATE_TYPE_MONTH){//本月
				currentDate = "benyue.mp3";
				nextDate = "xiageyuejiageyuji.mp3";
			}
			else {
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
			}
			
			var urlvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			
			var curlv1:Vector.<String> = new Vector.<String>();
			
			//下面我们来看一下
			curlv1.push(baseUrl + "xiamianwomenlaikanyixia.mp3");
			
			//今天/本周/本月
			curlv1.push(baseUrl + currentDate);
			
			//农产品名称
			curlv1.push(baseUrl + distributeSoundsDO.goodsCode + ".mp3");
			
			//价格市场的分布情况
			curlv1.push(baseUrl + "jiageshichangdefenbuqingkuang.mp3");
			urlvv.push(curlv1);
			
			
			//较低价格
			var curlv21:Vector.<String> = new Vector.<String>();
			curlv21.push(baseUrl + "fenbu0.mp3");
			urlvv.push(curlv21);
			
			//中间价格
			var curlv22:Vector.<String> = new Vector.<String>();
			curlv22.push(baseUrl + "fenbu1.mp3");
			urlvv.push(curlv22);
			
			//较高价格
			var curlv23:Vector.<String> = new Vector.<String>();
			curlv23.push(baseUrl + "fenbu2.mp3");
			urlvv.push(curlv23);
			
			var curlv3:Vector.<String> = new Vector.<String>();
			
			//最低价格分布
			curlv3.push(baseUrl + "zuidijiagefenbu.mp3");
			
			//主要市场为
			curlv3.push(baseUrl + "zhuyaoshichangwei.mp3");
			urlvv.push(curlv3);
			
			var lowDisV:Vector.<TextPointDO> = distributeSoundsDO.lowDisV;
			
			//市场名称 + 价格
			pushPriceCard(urlvv,lowDisV);
			
			var curlv4:Vector.<String> = new Vector.<String>();
			
			//最高价格分布
			curlv4.push(baseUrl + "zuigaojiagefenbu.mp3");
			
			//主要市场为
			curlv4.push(baseUrl + "zhuyaoshichangwei.mp3");
			
			urlvv.push(curlv4);
			
			var highDisV:Vector.<TextPointDO> = distributeSoundsDO.highDisV;
			
			//市场名称 + 价格
			pushPriceCard(urlvv,highDisV);
			
			return urlvv;
		}
		
		private function pushPriceCard(urls:Vector.<Vector.<String>>,lowDisV:Vector.<TextPointDO>):void{
			
			if(lowDisV != null){
				for(var i:int =0;i<lowDisV.length;i++){
					var tpdo:TextPointDO = lowDisV[i];
					var lname:String = tpdo.name;
					var lvalue:String = tpdo.value;
					if(StringUtil.isEffective(lname,lvalue)){
						
						var lv:Number = Number(lvalue);
						if(lv > 0){
							var curlv:Vector.<String> = new Vector.<String>();
							curlv.push(baseUrl + lname + ".mp3");
							pushPriceUrls(curlv,lv);
							urls.push(curlv);
						}
					}
				}
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