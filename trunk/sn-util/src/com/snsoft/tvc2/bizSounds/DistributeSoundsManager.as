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
		
		public function creatPriceSoundUrlList(distributeSoundsDO:DistributeSoundsDO):BizSoundDO{
			var currentDate:String = "";
			var nextDate:String = "";
			
			var currentDateText:String = "";
			var nextDateText:String = "";
			
			//今天
			if(distributeSoundsDO.dateType == DistributeSoundsDO.DATE_TYPE_DAY){
				currentDate = "jintian.mp3";
				nextDate = "mingtian.mp3";
				currentDateText = "今天，";
				nextDateText = "明天，";
			}
			else if(distributeSoundsDO.dateType == DistributeSoundsDO.DATE_TYPE_WEEK){//本周
				currentDate = "benzhou.mp3";
				nextDate = "xiazhou.mp3";
				currentDateText = "本周，";
				nextDateText = "下周，";
			}
			else if(distributeSoundsDO.dateType == DistributeSoundsDO.DATE_TYPE_MONTH){//本月
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
			
			var urlvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			var textvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			
			var curlv1:Vector.<String> = new Vector.<String>();
			var curlTextv1:Vector.<String> = new Vector.<String>();
			
			//下面我们来看一下
			curlv1.push(baseUrl + "xiamianwomenlaikanyixia.mp3");
			curlTextv1.push("下面我们来看一下，");
			
			//今天/本周/本月
			curlv1.push(baseUrl + currentDate);
			curlTextv1.push(currentDateText);
			
			//农产品名称
			curlv1.push(baseUrl + distributeSoundsDO.goodsCode + ".mp3");
			curlTextv1.push(distributeSoundsDO.goodsText +"的");
			
			//价格市场的分布情况
			curlv1.push(baseUrl + "jiageshichangdefenbuqingkuang.mp3");
			curlTextv1.push("价格市场的分布情况，");
			
			urlvv.push(curlv1);
			textvv.push(curlTextv1);
			
			//较低价格
			var curlv21:Vector.<String> = new Vector.<String>();
			var curlTextv21:Vector.<String> = new Vector.<String>();
			curlv21.push(baseUrl + "fenbu0.mp3");
			curlTextv21.push("较低价格，");
			urlvv.push(curlv21);
			textvv.push(curlTextv21);
			
			//中间价格
			var curlv22:Vector.<String> = new Vector.<String>();
			var curlTextv22:Vector.<String> = new Vector.<String>();
			curlv22.push(baseUrl + "fenbu1.mp3");
			curlTextv22.push("中间价格，");
			urlvv.push(curlv22);
			textvv.push(curlTextv22);
			
			//较高价格
			var curlv23:Vector.<String> = new Vector.<String>();
			var curlTextv23:Vector.<String> = new Vector.<String>();
			curlv23.push(baseUrl + "fenbu2.mp3");
			curlTextv23.push("较高价格。");
			urlvv.push(curlv23);
			textvv.push(curlTextv23);
			
			
			var descurlv:Vector.<String> = new Vector.<String>();
			var descurlTextv:Vector.<String> = new Vector.<String>();
			
			var lowDesV:Vector.<TextPointDO> = distributeSoundsDO.lowDesV;
			var highDesV:Vector.<TextPointDO> = distributeSoundsDO.highDesV;
			
			if(lowDesV != null && highDesV != null){
				if(lowDesV.length > 0 && highDesV.length > 0){
					descurlv.push(baseUrl + "congquyushangkan.mp3");
					descurlv.push(baseUrl + "gaojiaweijizhongzai.mp3");
					descurlTextv.push("从区域上看，高价位地区集中在");
					
					for(var i:int =0;i< highDesV.length;i++){
						var htpdo:TextPointDO = highDesV[i];
						var hname:String = htpdo.name;
						var htext:String = htpdo.text;
						descurlv.push(baseUrl + hname +".mp3");
						descurlTextv.push(htext);
						if(i < highDesV.length - 1){
							descurlTextv.push("、");
						}
						else {
							descurlv.push(baseUrl + "diqu.mp3");
							descurlTextv.push("地区，");
						}
					}
					
					descurlv.push(baseUrl + "dijiaweidiquzai.mp3");
					descurlTextv.push("低价位地区在");
					
					for(var i2:int =0;i2< lowDesV.length;i2++){
						var ltpdo:TextPointDO = lowDesV[i2];
						var lname:String = ltpdo.name;
						var ltext:String = ltpdo.text;
						descurlv.push(baseUrl + lname +".mp3");
						descurlTextv.push(ltpdo.text);
						if(i < lowDesV.length - 1){
							descurlTextv.push("、");
						}
						else {
							descurlv.push(baseUrl + "diqu.mp3");
							descurlTextv.push("地区，");
						}
					}
					
					descurlv.push(baseUrl + "qitadiqu.mp3");
					descurlTextv.push("其他地区价格处于中间水平。");
					
					urlvv.push(descurlv);
					textvv.push(descurlTextv);
				}
			}
			
			
			
			var curlv3:Vector.<String> = new Vector.<String>();
			var curlTextv3:Vector.<String> = new Vector.<String>();
			
			//最低价格分布
			curlv3.push(baseUrl + "zuidijiagefenbu.mp3");
			
			//主要市场为
			curlv3.push(baseUrl + "zhuyaoshichangwei.mp3");
			curlTextv3.push("最低价格分布，主要市场为，");
			
			urlvv.push(curlv3);
			textvv.push(curlTextv3);
			
			var lowDisV:Vector.<TextPointDO> = distributeSoundsDO.lowDisV;
			
			//市场名称 + 价格
			pushPriceCard(urlvv,lowDisV);
			pushPriceTextCard(textvv,lowDisV);
			
			
			var curlv4:Vector.<String> = new Vector.<String>();
			var curlTextv4:Vector.<String> = new Vector.<String>();
			
			//最高价格分布
			curlv4.push(baseUrl + "zuigaojiagefenbu.mp3");
			
			//主要市场为
			curlv4.push(baseUrl + "zhuyaoshichangwei.mp3");
			
			urlvv.push(curlv4);
			curlTextv4.push("最高价格分布，主要市场为，");
			textvv.push(curlTextv4);
			
			var highDisV:Vector.<TextPointDO> = distributeSoundsDO.highDisV;
			
			//市场名称 + 价格
			pushPriceCard(urlvv,highDisV);
			pushPriceTextCard(textvv,highDisV);
			
			var bizSoundDO:BizSoundDO = new BizSoundDO();
			bizSoundDO.urlVV = urlvv;
			bizSoundDO.textVV = textvv;
			return bizSoundDO;
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
		
		private function pushPriceTextCard(texts:Vector.<Vector.<String>>,lowDisV:Vector.<TextPointDO>):void{
			
			if(lowDisV != null){
				for(var i:int =0;i<lowDisV.length;i++){
					var tpdo:TextPointDO = lowDisV[i];
					var ltext:String = tpdo.text;
					var lvalue:String = tpdo.value;
					if(StringUtil.isEffective(ltext,lvalue)){
						var curlv:Vector.<String> = new Vector.<String>();
						var lv:Number = Number(lvalue);
						if(lv > 0){
							
							curlv.push(ltext);
							curlv.push(lv.toFixed(2)+ "元");
							if(i == lowDisV.length - 1){
								curlv.push("。");
							}
							else{
								curlv.push("，");
							}
							trace(curlv);
							texts.push(curlv);
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