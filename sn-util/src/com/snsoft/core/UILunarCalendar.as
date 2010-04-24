﻿package com.snsoft.core{
	import com.cyjb.dates.DateLunar;
	import com.snsoft.util.ShapeUtil;
	
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.core.UIComponent;
	import fl.events.ComponentEvent;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

	/**
	 * 当前日历显示日期列表,包括五个星期，本月全部天，上月尾部天，下月首部天。 
	 * @author Administrator
	 * 
	 */
	public class UILunarCalendar extends UIComponent {
		//一天的时长，单位毫秒
		private static var ONE_DAY_TIME:Number = 24 * 60 * 60 * 1000;

		//列数
		private static var PAGE_LIST_NUM:Number = 7;

		//行数
		private static var PAGE_ROLL_NUM:Number = 6;

		//通用元件空隙 X方向
		private static var spaceX:Number = 10;

		//通用元件空隙 Y方向
		private static var spaceY:Number = 10;

		//年选择元件宽度
		private static var yearComboBoxWidth:Number = 60;

		//月选择元件宽度
		private static var monthComboBoxWidth:Number = 60;

		//星期一 到 星期日的标题 Y 坐标修正值
		private static var weeksTitleMCamendY:Number = 20;
		
		//当前时间 X 坐标修正值
		private static var timeMCamendX:Number = 200;
		

		//当前时间
		private var currentDate:Date = new Date();

		//当前日历显示日期DateLunar列表,包括五个星期，本月全部天，上月尾部天，下月首部天。
		private var currentPageDateList:Array;

		//输出显示每天的公历，农历
		private static var calendarDaySkinName:String = "CalendarDaySkin";

		//星期一 到 星期日 
		private static var calendarWeekTitleSkinName:String = "CalendarWeekTitleSkin";

		//日期详细标签
		private static var calendarDayMoreSkinName:String = "CalendarDayMoreSkin";

		//日历主背景
		private static var calendarDayBackSkinName:String = "CalendarDayBackSkin";

		//时间显示MC
		private static var calendarDayTimeViewSkinName:String = "CalendarDayTimeViewSkin";

		//日期选择的父MC
		private static var calendarDayYearMonthComboBoxSkinName:String = "CalendarDayYearMonthComboBoxSkin";
		
		private static var calendarDayDatesBackSkinName:String = "CalendarDayDatesBackSkin";

		//星期的中文名称列表
		private var weekCnNames:Array = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"];

		//日期列表背景 年 月 显示对象
		private var pageDatesBackMC:MovieClip;

		//日期列表的父MC
		private var currentPageDatesParentSprite:Sprite;

		//日期列表数组，用于事件响应数据传递
		private var dayMcs:Array = new Array();

		//星期 标题 列表显示父MC
		private var weekTitleSprite:Sprite;

		//日期
		private var dayMoreBaseSprite:Sprite;

		//年 月下拉选择和当前日期显示父MC
		private var yearMonthControlMC:MovieClip;

		//时间显示MC
		private var timeMc:MovieClip;

		//年选择下拉列表
		private var yearComboBox:ComboBox = new ComboBox();

		//月选择下拉列表
		private var monthComboBox:ComboBox = new ComboBox();


		public function UILunarCalendar() {
			this.addEventListener(ComponentEvent.RESIZE,handlerResize);
			this.addEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			super();
		}


		/**
		 * 当前项目改变宽高事件 
		 * @param e
		 * 
		 */
		private function handlerResize(e:Event):void {

		}

		/**
		 * 当前项目进跳入帧事件 
		 * @param e
		 * 
		 */
		private function handlerEnterFrame(e:Event):void {
			//删除监听器
			try {
				this.removeEventListener(Event.ENTER_FRAME,handlerEnterFrame);
			} catch (e:Error) {
			}

			//背景
			var backSkin:MovieClip = this.createSkinByName(UILunarCalendar.calendarDayBackSkinName);
			if (backSkin != null) {
				this.addChild(backSkin);
			}
			
			//日历背景 年 月
			var pageDatesBackMC:MovieClip = this.createSkinByName(UILunarCalendar.calendarDayDatesBackSkinName);
			this.createPageDatesBackMC(pageDatesBackMC);
			this.pageDatesBackMC = pageDatesBackMC;
			this.addChild(this.pageDatesBackMC);
			
			
			//日期选择控制按钮
			var ymcbMC:MovieClip = this.createSkinByName(UILunarCalendar.calendarDayYearMonthComboBoxSkinName);
			this.yearMonthControlMC = this.createYearMonthControlMC(ymcbMC);
			this.yearMonthControlMC.x = spaceX;
			this.yearMonthControlMC.y = spaceY;
			this.addChild(this.yearMonthControlMC);

			//时间显示MC
			var tmc:MovieClip = this.createSkinByName(UILunarCalendar.calendarDayTimeViewSkinName);
			if (tmc != null) {
				refreshCalendarDayTimeViewTodayDate(tmc);
				this.timeMc = tmc;
				this.addChild(this.timeMc);
				this.timeMc.x = this.yearMonthControlMC.x + UILunarCalendar.timeMCamendX + spaceX;
				this.timeMc.y = spaceY;
				var timer:Timer = new Timer(500,0);
				timer.addEventListener(TimerEvent.TIMER,handlerTimeTextFieldRefeshTimerEvent);
				timer.start();
			}

			//标题 星期一 到 星期日
			this.weekTitleSprite = new Sprite();
			this.addChild(this.weekTitleSprite);
			this.createWeekTitle(weekTitleSprite);
			this.weekTitleSprite.x = spaceX;
			this.weekTitleSprite.y = this.yearMonthControlMC.y + UILunarCalendar.weeksTitleMCamendY + spaceY;

			//当前月日历日期列表对象
			this.currentPageDatesParentSprite = new Sprite();
			this.addChild(this.currentPageDatesParentSprite);
			this.currentPageDatesParentSprite.x = spaceX;
			this.currentPageDatesParentSprite.y = this.weekTitleSprite.height + this.weekTitleSprite.y;
			this.createCurrentPageDatesSprite(this.currentPageDatesParentSprite);

			//日期MouseOver事件弹出详细信息MC
			dayMoreBaseSprite = new Sprite();
			this.addChild(dayMoreBaseSprite);

			//背景：宽/高
			if (backSkin != null) {
				backSkin.width = this.currentPageDatesParentSprite.width + this.currentPageDatesParentSprite.x + spaceX;
				backSkin.height = this.currentPageDatesParentSprite.height + this.currentPageDatesParentSprite.y + spaceY;
				this.width = backSkin.width;
				this.height = backSkin.height;
			}
		}
		
		private function createPageDatesBackMC(pdbMC:MovieClip):MovieClip{
			if(pdbMC != null){
				var year:TextField = pdbMC.year as TextField;
				if(year != null){
					year.text = String(this.currentDate.fullYear);
				}
				var month:TextField = pdbMC.month as TextField;
				if(month != null){
					month.text = String(this.currentDate.month + 1);
				}
				return pdbMC;
			}
			return null;
		}
		
		private function createYearMonthControlMC(ymcbMC:MovieClip):MovieClip{
			if (ymcbMC != null) {
				var tfm:TextFormat = new TextFormat();
				tfm.size = 14;
				
				var yearComboBox:ComboBox = ymcbMC.yearComboBox;
				if (yearComboBox != null) {
					this.yearComboBox = yearComboBox;
					this.createYearComboBox(yearComboBox);
					//yearComboBox.setStyle("textFormat",tfm);
					yearComboBox.addEventListener(Event.CHANGE,handlerYearComboBoxChange);
				}
				var monthComboBox:ComboBox = ymcbMC.monthComboBox;
				if (monthComboBox != null) {
					this.monthComboBox = monthComboBox;
					this.createMonthComboBox(monthComboBox);
					//monthComboBox.setStyle("textFormat",tfm);
					monthComboBox.addEventListener(Event.CHANGE,handlerMonthComboBoxChange);
				}
				var todayButton:Button = ymcbMC.todayButton;
				if(todayButton != null){
					todayButton.setStyle("textFormat",tfm);
					todayButton.addEventListener(MouseEvent.CLICK,handlerTodayButtonClick);
				}
				return ymcbMC;
			}
			return null;
		}
		
		private function handlerTimeTextFieldRefeshTimerEvent(e:Event):void {
			var timer:Timer = e.currentTarget as Timer;
			var splitStr:String = ":";
			if (timer != null) {
				var n:int = timer.currentCount % 2;
				if (n % 2 == 0) {
					splitStr = " ";
				}
			}
			var date:Date = new Date();
			var hours:String = formatTime(String(date.hours));
			var minutes:String = formatTime(String(date.minutes));
			var seconds:String = formatTime(String(date.seconds));
			var str:String = hours + splitStr + minutes + splitStr + seconds;
			var tmc:MovieClip = this.timeMc;
			if (tmc != null) {
				var tf:TextField = tmc.textField as TextField;
				if (tf != null) {
					tf.text = str;
				}
				if(date.getHours() == 0 && date.getMinutes() == 0 && date.getSeconds() == 0){
					this.refreshCalendarDayTimeViewTodayDate(tmc);
					this.createYearMonthControlMC(this.yearMonthControlMC);
					this.resetDate(date.fullYear,date.month); 
					trace("00:00:00");
				}
			}
		}
		
		function refreshCalendarDayTimeViewTodayDate(tmc:MovieClip):void{
			if (tmc != null) {
				var dl:DateLunar = new DateLunar();
				var yearCyclical:TextField = tmc.yearCyclical as TextField;
				if (yearCyclical != null) {
					yearCyclical.text = dl.yearCyclicalCN;
				}
				var animalCN:TextField = tmc.animalCN as TextField;
				if (animalCN != null) {
					animalCN.text = dl.animalCN;
				}
			}
		}

		private function formatTime(str:String):String {
			if (str != null) {
				if (str.length < 2) {
					str = "0" + str;
				}
				return str;
			}
			return null;
		}

		private function createSkinByName(skinName:String):MovieClip {
			var main:MovieClip = new MovieClip();
			var mc:MovieClip;
			try {
				var MClass:Class = getDefinitionByName(skinName) as Class;
				mc = new MClass() as MovieClip;
			} catch (e:Error) {
				trace("动态加载找不到类：" +skinName);
			}
			return mc;
		}
		
		private function handlerTodayButtonClick(e:Event):void{
			var date:Date = new Date();
			this.createYearMonthControlMC(this.yearMonthControlMC);
			this.resetDate(date.fullYear,date.month); 
		}
		
		private function handlerYearComboBoxChange(e:Event):void {
			var cb:ComboBox = e.currentTarget as ComboBox;
			if (cb != null) {
				var year:Number = Number(cb.value);
				this.resetDate(year,NaN);
			}
		}

		private function handlerMonthComboBoxChange(e:Event):void {
			var cb:ComboBox = e.currentTarget as ComboBox;
			if (cb != null) {
				var month:Number = Number(cb.value);
				this.resetDate(NaN,month);
			}
		}

		private function resetDate(year:Number,month:Number):void {
			if (! isNaN(year)) {
				this.currentDate.fullYear = year;
			}
			if (! isNaN(month)) {
				this.currentDate.month = month;
			}
			this.createPageDatesBackMC(this.pageDatesBackMC);
			this.removieSpriteAllChild(this.currentPageDatesParentSprite);
			this.createCurrentPageDatesSprite(this.currentPageDatesParentSprite);
		}

		private function createMonthComboBox(cb:ComboBox):void {
			if (cb != null) {
				while(cb.length > 0){
					cb.removeItemAt(0);
				}
				cb.rowCount = 12;
				for (var i:int = 0; i< 12; i++) {
					var obj:Object = creatComboBoxIterm(String(i + 1),String(i));
					cb.addItem(obj);
					var date:Date = new Date();
					if (date.month == i) {
						cb.selectedItem = obj;
					}
				}
			}
		}

		private function createYearComboBox(cb:ComboBox):void {
			if (cb != null) {
				while(cb.length > 0){
					cb.removeItemAt(0);
				}
				cb.rowCount = 10;
				for (var i:int = 1901; i< 2101; i++) {
					var obj:Object = creatComboBoxIterm(String(i),String(i));
					cb.addItem(obj);
					var date:Date = new Date();
					if (date.fullYear == i) {
						cb.selectedItem = obj;
					}
				}
			}
		}

		private function creatComboBoxIterm(name:String,value:String):Object {
			var obj:Object = new Object();
			obj.label = name;
			obj.data = value;
			return obj;
		}

		private function createCalendarDayMore(dayMc:MovieClip,dl:DateLunar):MovieClip {
			var main:MovieClip = new MovieClip();
			var cdm:MovieClip;
			try {
				var MClass:Class = getDefinitionByName(UILunarCalendar.calendarDayMoreSkinName) as Class;
				cdm = new MClass() as MovieClip;
			} catch (e:Error) {
				trace("动态加载找不到类：" +UILunarCalendar.calendarDayMoreSkinName);
			}
			if (cdm != null && dayMc != null && dl != null) {
				var cdmX:Number = this.currentPageDatesParentSprite.x + dayMc.x + dayMc.width;
				var cdmY:Number = this.currentPageDatesParentSprite.y + dayMc.y + dayMc.height;
				var leftView:Boolean = false;
				var rightView:Boolean = false;
				var topView:Boolean = false;
				var bottomView:Boolean = false;
				if (cdmX + cdm.width > this.currentPageDatesParentSprite.x + this.currentPageDatesParentSprite.width) {
					cdmX = this.currentPageDatesParentSprite.x + dayMc.x - cdm.width;
					rightView = true;
				}
				else {
					leftView = true;
				}
				if (cdmY + cdm.height > this.currentPageDatesParentSprite.y + this.currentPageDatesParentSprite.height) {
					cdmY = this.currentPageDatesParentSprite.y + dayMc.y - cdm.height;
					bottomView = true;
				}
				else {
					topView = true;
				}
				cdm.x = cdmX;
				cdm.y = cdmY;
				var su:ShapeUtil = new ShapeUtil();
				var dmpX:Number = this.currentPageDatesParentSprite.x + dayMc.x + dayMc.width / 2;
				var dmpY:Number = this.currentPageDatesParentSprite.y + dayMc.y + dayMc.height / 2;
				var dayMcPoint:Point = new Point(dmpX,dmpY);
				var p1:Point = new Point(cdm.x,cdm.y);
				var p2:Point = new Point(cdm.x + cdm.width,cdm.y);
				var p3:Point = new Point(cdm.x + cdm.width,cdm.y + cdm.height);
				var p4:Point = new Point(cdm.x,cdm.y + cdm.height);
				var color:int = 0x000000;
				var alpha:Number = 0.05;
				if (topView) {
					var shape1:Shape = su.drawShapeWithPoint(color,alpha,new Point(p1.x,p1.y),new Point(p2.x,p2.y),new Point(dayMcPoint.x,dayMcPoint.y));
					main.addChild(shape1);
				}
				if (rightView) {
					var shape2:Shape = su.drawShapeWithPoint(color,alpha,new Point(p2.x,p2.y),new Point(p3.x,p3.y),new Point(dayMcPoint.x,dayMcPoint.y));
					main.addChild(shape2);
				}
				if (bottomView) {
					var shape3:Shape = su.drawShapeWithPoint(color,alpha,new Point(p3.x,p3.y),new Point(p4.x,p4.y),new Point(dayMcPoint.x,dayMcPoint.y));
					main.addChild(shape3);
				}
				if (leftView) {
					var shape4:Shape = su.drawShapeWithPoint(color,alpha,new Point(p4.x,p4.y),new Point(p1.x,p1.y),new Point(dayMcPoint.x,dayMcPoint.y));
					main.addChild(shape4);
				}
				this.setValueTextFiled(cdm.animalCN,String(dl.animalCN));
				this.setValueTextFiled(cdm.year,String(dl.dateSolar.fullYear));
				this.setValueTextFiled(cdm.month,String(dl.dateSolar.month + 1));
				this.setValueTextFiled(cdm.date,String(dl.dateSolar.date));
				this.setValueTextFiled(cdm.day,String(dl.dayCN));
				var solarTermCN:String = "";
				if (dl.solarTermCN != null) {
					solarTermCN = dl.solarTermCN;
				}
				this.setValueTextFiled(cdm.solarTermCN,solarTermCN);
				this.setValueTextFiled(cdm.monthCN,String(dl.monthCN));
				this.setValueTextFiled(cdm.dateCN,String(dl.dateCN));
				this.setValueTextFiled(cdm.yearCyclical,String(dl.yearCyclicalCN));
				this.setValueTextFiled(cdm.monthCyclical,String(dl.monthCyclicalCN));
				this.setValueTextFiled(cdm.dateCyclical,String(dl.dateCyclicalCN));
				main.addChild(cdm);
				return main;
			}
			return null;
		}

		private function setValueTextFiled(obj:Object,str:String):void {
			if (obj is TextField) {
				var tf:TextField = obj as TextField;
				tf.text = str;
			}
		}

		/**
		 * 创建 星期一 到 星期日 标题 
		 * @param sprite
		 * 
		 */
		private function createWeekTitle(sprite:Sprite):void {
			for (var i:int = 0; i < 7,i < this.weekCnNames.length; i++) {
				var weekMc:MovieClip;
				try {
					var MClass:Class = getDefinitionByName(UILunarCalendar.calendarWeekTitleSkinName) as Class;
					weekMc = new MClass() as MovieClip;
				} catch (e:Error) {
					trace("动态加载找不到类：" +UILunarCalendar.calendarWeekTitleSkinName);
				}
				if (weekMc != null) {
					var weekendWeekTitleText:TextField = weekMc.weekendWeekTitleText as TextField;
					var weekTitleText:TextField = weekMc.weekTitleText as TextField;
					if (weekendWeekTitleText != null && weekTitleText != null) {
						if (i == 5 || i == 6) {
							weekendWeekTitleText.text = weekCnNames[i];
						}
						else {
							weekTitleText.text = weekCnNames[i];
						}
					}
					weekMc.x = weekMc.width * i;
					sprite.addChild(weekMc);
				}
			}
		}


		private function removieSpriteAllChild(sprite:Sprite):void {
			if (sprite != null) {
				while (sprite.numChildren > 0) {
					sprite.removeChildAt(0);
				}
			}
		}

		/**
		 * 把日期例表对象添加到 sprite 对象 
		 * @param sprite
		 * 
		 */
		private function createCurrentPageDatesSprite(sprite:Sprite):void {
			if (sprite != null) {
				this.currentPageDateList = this.creatCurrentPageDateList(this.currentDate);
				for (var i:int = 0; i < this.currentPageDateList.length; i ++) {
					var dl:DateLunar = this.currentPageDateList[i] as DateLunar;
					var dayMc:MovieClip;
					try {
						var Sclass:Class = getDefinitionByName(UILunarCalendar.calendarDaySkinName) as Class;
						dayMc = new Sclass() as MovieClip;
					} catch (e:Error) {
						trace("动态加载找不到类："+UILunarCalendar.calendarDaySkinName);
						trace(e.getStackTrace());
					}
					if (dayMc != null) {
						var dayText:TextField = dayMc.dayText as TextField;
						var cnDayText:TextField = dayMc.cnDayText as TextField;
						var weekendDayText:TextField = dayMc.weekendDayText as TextField;
						var weekendCnDayText:TextField = dayMc.weekendCnDayText as TextField;
						var cdss:MovieClip = dayMc.cdss as MovieClip;
						cdss.visible = false;
						if (dayText != null && cnDayText != null && weekendDayText != null && weekendCnDayText != null) {
							var dayStr:String = String(dl.dateSolar.date);
							var cnDayStr:String = String(dl.dateCN);
							if (dl.dateSolar.month != this.currentDate.month) {
								dayMc.visible = false;
							}

							var cdcds:MovieClip = dayMc.cdcds as MovieClip;
							if (cdcds != null) {
								cdcds.visible = false;
							}
							var date:Date = new Date();
							if (dl.dateSolar.fullYear == date.fullYear
							&& dl.dateSolar.month == date.month
							&& dl.dateSolar.date == date.date) {
								if (cdcds != null) {
									cdcds.visible = true;
								}
							}
							if (dl.date == 1) {
								cnDayStr = dl.monthCN;
							}
							if (dl.solarTerm >= 0) {
								cnDayStr = dl.solarTermCN;
							}
							if (dl.dateSolar.day == 0 || dl.dateSolar.day == 6) {
								weekendDayText.text = dayStr;
								weekendCnDayText.text = cnDayStr;
							}
							else {
								dayText.text = dayStr;
								cnDayText.text = cnDayStr;
							}
							dayMc.x = (i % 7) * dayMc.width;
							dayMc.y = int(i / 7) * dayMc.height;
							dayMc.name = "dayMC" + i;
							dayMcs[dayMc.name] = dl;
							dayMc.addEventListener(MouseEvent.MOUSE_OVER,handlerDayMcMouseOver);
							dayMc.addEventListener(MouseEvent.MOUSE_OUT,handlerDayMcMouseOut);
							sprite.addChild(dayMc);
						}
						else {
							trace("CalendarDaySkin中没有dayText/cnDayText/weekendCnDayText/weekendCnDayText");
						}
					}
				}
			}
			else {
				trace("createCurrentPageDatesSprite(sprite:Sprite):sprite == null");
			}
		}

		/**
		 *  
		 * @param e
		 * 
		 */
		private function handlerDayMcMouseOver(e:Event):void {
			var dayMc:MovieClip = e.currentTarget as MovieClip;

			if (dayMc != null) {
				var cdss:MovieClip = dayMc.cdss as MovieClip;
				if (cdss != null) {
					cdss.visible = true;
				}
				var name:String = dayMc.name;
				var i:int = -1;
				try {
					i = int(name.substring(5,name.length));
				} catch (e:Error) {
					trace(e.getStackTrace());
				}
				if (i >= 0) {
					var dl:DateLunar = this.currentPageDateList[i] as DateLunar;
					var mc:MovieClip = createCalendarDayMore(dayMc,dl);
					if (this.dayMoreBaseSprite != null) {
						this.dayMoreBaseSprite.mouseEnabled = false;
						this.dayMoreBaseSprite.buttonMode = false;
						this.dayMoreBaseSprite.mouseChildren = false;
						this.dayMoreBaseSprite.addChild(mc);
					}
				}
			}
		}

		/**
		 *  
		 * @param e
		 * 
		 */
		private function handlerDayMcMouseOut(e:Event):void {
			var dayMc:MovieClip = e.currentTarget as MovieClip;
			if (dayMc != null) {
				var cdss:MovieClip = dayMc.cdss as MovieClip;
				if (cdss != null) {
					cdss.visible = false;
				}
			}
			if (this.dayMoreBaseSprite != null) {
				this.removieSpriteAllChild(this.dayMoreBaseSprite);
			}
		}

		/**
		 * 通过给定的时间算出当前日历页面第一天，以周一做为每周第一天 
		 * @param date
		 * 
		 */
		private function getCurrentPageFirstDate(date:Date):Date {
			var dt:Date = new Date();
			dt.time = date.time;
			if (dt != null) {
				dt.setDate(1);
				var day:Number = dt.getDay();
				day = ( day + 6 ) % 7;
				var time:Number = dt.getTime();
				time -= day * UILunarCalendar.ONE_DAY_TIME;
				dt.time=time;
				return dt;
			}
			return null;
		}

		/**
		 * 创建当前日历页面显示日期列表 
		 * @param date
		 * @return
		 * 
		 */
		private function creatCurrentPageDateList(date:Date):Array {
			if (date!=null) {
				var firstDayDate:Date=this.getCurrentPageFirstDate(date);
				var firstDayTime:Number=firstDayDate.getTime();
				var array:Array = new Array();
				var pageNum:Number=UILunarCalendar.PAGE_LIST_NUM*UILunarCalendar.PAGE_ROLL_NUM;
				for (var i:int = 0; i< pageNum; i++) {
					var tm:Number=firstDayTime+i*UILunarCalendar.ONE_DAY_TIME;
					var dt:Date = new Date();
					dt.time=tm;
					var dl:DateLunar=new DateLunar(dt);
					array.push(dl);
				}
				return array;
			}
			return null;
		}

		public function test():void {
			this.createCurrentPageDatesSprite(this.currentPageDatesParentSprite);
		}
	}
}