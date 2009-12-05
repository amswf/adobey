package com.snsoft.core
{
	import com.cyjb.dates.DateLunar;
	
	import fl.core.UIComponent;

	/**
	 * 当前日历显示日期列表,包括五个星期，本月全部天，上月尾部天，下月首部天。 
	 * @author Administrator
	 * 
	 */	
	public class UILunarCalendar extends UIComponent
	{
		//一天的时长，单位毫秒
		private static var ONE_DAY_TIME:Number = 24 * 60 * 60 * 1000;
	 	
	 	//列数
	 	private static var PAGE_LIST_NUM:Number = 7;
	 	
	 	//行数
	 	private static var PAGE_ROLL_NUM:Number = 5;
	 	
	 	//当前时间
	 	private var currentDate:Date = new Date();
	 	
	 	//当前日历显示日期DateLunar列表,包括五个星期，本月全部天，上月尾部天，下月首部天。
	 	private var currentPageDateList:Array;
	 	
	 	
		public function UILunarCalendar()
		{
			super();
		}
		
		/**
		 * 通过给定的时间算出当前日历页面第一天，以周一做为每周第一天 
		 * @param date
		 * 
		 */		
		private function getCurrentPageFirstDate(date:Date):Date{
			
			if(date != null){
			 	date.setDate(1);
			 	var day:Number = date.getDay();
			 	day = ( day + 6 ) % 7;
			 	var time:Number = date.getTime();
			 	time  -= day * UILunarCalendar.ONE_DAY_TIME;
			 	date.time = time;
			 	return date;
		 	}
		 	return null;
		}
		
		/**
		 * 创建当前日历页面显示日期列表 
		 * @param date
		 * @return 
		 * 
		 */		
		private function creatCurrentPageDateList(date:Date):Array{
			if(date != null){
				var firstDayDate:Date = this.getCurrentPageFirstDate(date);
				var firstDayTime:Number = firstDayDate.getTime();
				var array:Array = new Array();
				var pageNum:Number = UILunarCalendar.PAGE_LIST_NUM * UILunarCalendar.PAGE_ROLL_NUM;
				for(var i:int = 0;i< pageNum;i++){
			 		var tm:Number = firstDayTime + i * UILunarCalendar.ONE_DAY_TIME;
			 		var dt:Date = new Date();
			 		dt.time = tm;
			 		var dl:DateLunar = new DateLunar(dt);
			 		array.push(dl);
			 	}
				return array;
			}
			return null;
		}
		
		public function test():void{
			this.currentPageDateList = this.creatCurrentPageDateList(this.currentDate);
			for(var i:int = 0;i < this.currentPageDateList.length;i ++){
				var dl:DateLunar = this.currentPageDateList[i] as DateLunar; 
				trace("DateLunar:" + dl);
			}
		}
	}
}