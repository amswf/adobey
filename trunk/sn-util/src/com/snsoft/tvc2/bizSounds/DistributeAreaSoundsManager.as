package com.snsoft.tvc2.bizSounds{
	public class DistributeAreaSoundsManager{
		
		private var baseUrl:String = "mp3/biz/";
		
		public function DistributeAreaSoundsManager()
		{
		}
		
		public function creatDistributeAreaUrlList(distributeAreaSoundsDO:DistributeAreaSoundsDO):Vector.<Vector.<String>>{
			var currentDate:String = "";
			var nextDate:String = "";
			
			//今天
			if(distributeAreaSoundsDO.dateType == DistributeAreaSoundsDO.DATE_TYPE_DAY){
				currentDate = "jintian.mp3";
				nextDate = "mingtianjiageyuji.mp3";
			}
			else if(distributeAreaSoundsDO.dateType == DistributeAreaSoundsDO.DATE_TYPE_WEEK){//本周
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
			}
			else if(distributeAreaSoundsDO.dateType == DistributeAreaSoundsDO.DATE_TYPE_MONTH){//本月
				currentDate = "benyue.mp3";
				nextDate = "xiageyuejiageyuji.mp3";
			}
			else {
				currentDate = "benzhou.mp3";
				nextDate = "xiazhoujiageyuji.mp3";
			}
			
			
			var urlvv:Vector.<Vector.<String>> = new Vector.<Vector.<String>>();
			
			var curlv1:Vector.<String> = new Vector.<String>();
			
			curlv1.push(baseUrl + "xiamianwomenlaikanyixia.mp3");
			curlv1.push(baseUrl + currentDate);
			curlv1.push(baseUrl + "shengchannenglifenbuqingkuang.mp3");
			urlvv.push(curlv1);
			
			var curlv21:Vector.<String> = new Vector.<String>();
			curlv21.push(baseUrl + "channeng0.mp3");
			urlvv.push(curlv21);
			
			var curlv22:Vector.<String> = new Vector.<String>();
			curlv22.push(baseUrl + "channeng1.mp3");
			urlvv.push(curlv22);
			
			var curlv23:Vector.<String> = new Vector.<String>();
			curlv23.push(baseUrl + "channeng2.mp3");
			urlvv.push(curlv23);
			
			var curlv24:Vector.<String> = new Vector.<String>();
			curlv24.push(baseUrl + "channeng3.mp3");
			urlvv.push(curlv24);
			
			return urlvv;
		}
	}
}