package com.snsoft.tvc2.bizSounds{
	public class DistributeAreaSoundsManager{
		
		private var baseUrl:String = "mp3/biz/";
		
		public function DistributeAreaSoundsManager()
		{
		}
		
		public function creatDistributeAreaUrlList(distributeAreaSoundsDO:DistributeAreaSoundsDO):BizSoundDO{
			var currentDate:String = "";
			var nextDate:String = "";
			
			var currentDateText:String = "";
			var nextDateText:String = "";
			
			//今天
			if(distributeAreaSoundsDO.dateType == DistributeAreaSoundsDO.DATE_TYPE_DAY){
				currentDate = "jintian.mp3";
				nextDate = "mingtian.mp3";
				currentDateText = "今天，";
				nextDateText = "明天，";
			}
			else if(distributeAreaSoundsDO.dateType == DistributeAreaSoundsDO.DATE_TYPE_WEEK){//本周
				currentDate = "benzhou.mp3";
				nextDate = "xiazhou.mp3";
				currentDateText = "本周，";
				nextDateText = "下周，";
			}
			else if(distributeAreaSoundsDO.dateType == DistributeAreaSoundsDO.DATE_TYPE_MONTH){//本月
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
			
			curlv1.push(baseUrl + "xiamianwomenlaikanyixia.mp3");
			curlTextv1.push("下面我们来看一下");
			
			curlv1.push(baseUrl + currentDate);
			curlTextv1.push(currentDateText);
				
			//农产品名称
			curlv1.push(baseUrl + distributeAreaSoundsDO.goodsCode + ".mp3");
			curlTextv1.push(distributeAreaSoundsDO.goodsText +"的");
			
			curlv1.push(baseUrl + "shengchannenglifenbuqingkuang.mp3");
			curlTextv1.push("的生产能力分布情况：");
			
			urlvv.push(curlv1);
			textvv.push(curlTextv1);
			
			var curlv21:Vector.<String> = new Vector.<String>();
			var curlTextv21:Vector.<String> = new Vector.<String>();
			curlv21.push(baseUrl + "channeng0.mp3");
			curlTextv21.push("低产能地区，");
			urlvv.push(curlv21);
			textvv.push(curlTextv21);
			
			var curlv22:Vector.<String> = new Vector.<String>();
			var curlTextv22:Vector.<String> = new Vector.<String>();
			curlv22.push(baseUrl + "channeng1.mp3");
			curlTextv22.push("中低产能地区，");
			urlvv.push(curlv22);
			textvv.push(curlTextv22);
			
			var curlv23:Vector.<String> = new Vector.<String>();
			var curlTextv23:Vector.<String> = new Vector.<String>();
			curlv23.push(baseUrl + "channeng2.mp3");
			curlTextv23.push("中高产能地区，");
			urlvv.push(curlv23);
			textvv.push(curlTextv23);
			
			var curlv24:Vector.<String> = new Vector.<String>();
			var curlTextv24:Vector.<String> = new Vector.<String>();
			curlv24.push(baseUrl + "channeng3.mp3");
			curlTextv24.push("高产能地区。");
			urlvv.push(curlv24);
			textvv.push(curlTextv24);
			
			var bizSoundDO:BizSoundDO = new BizSoundDO();
			bizSoundDO.urlVV = urlvv;
			bizSoundDO.textVV = textvv;
			return bizSoundDO;
		}
	}
}